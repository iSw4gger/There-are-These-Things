//
//  ViewController.swift
//  There are These Things
//
//  Created by Jared Boynton on 5/26/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
//since this class inherits table view controller, we don't have to do all the methods required when setting up a table view(delegate, data source, etc.). This comes behind the scenes.
    
    //we have to get an object of app delegate, this is how we do it. Then we can grab the persistent container which is our core data
    //context is the temporary area that interacts with the core database (SQL Database). THis is where you can CRUD (create read update destroy). For example, once you are happy with changes made, you can call the context.save (in app delegate)
    //a row in the database is equal to one "NSManagedObject'. The columns in the database are the properties (i.e. - title & done). The entity is the entire table.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        //once selectedCategory gets a value, then didSet is called
        //we did this because at this point we can be sure we have values and don't crash app.
        didSet{
            loadItems()
        }
    }
    
    //grabbing a file path to where the data will be stored. Using .first
    
    //you can create different plists that store data in a different plist. Example, work to do list, home to do list, etc. Reduces loading time.

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        //this will delete items from the database
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()
        
        //grabbing a reference to the cell that is selected
        
        //deselects the row so it doesn't stay gray.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //need a popup here to add items. Then append to array.
        
        var addThing = UITextField()
        
        let alert = UIAlertController(title: "Add a Thing", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Thing", style: .default) { (action) in
            //what happens when the user clicks add item on the UI alert.
            
            let newItem = Item(context: self.context)
            
            //so you can get categories
            //adds item to that particular category and retains it in that category.
            newItem.parentCategory = self.selectedCategory
            newItem.title = addThing.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        //add a text field to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a thing..."
            addThing = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
        do{
            //this save comes from the app delegate method of 'saveContext'
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //loads data that loads the contents of the URL (from the FilePath above)
    // the '= Item.fetchRequest is the default value that is assigned when a parameter is not passed. In this case, the default is Item.fetchRequest. This is important for the ViewDidLoad call.
    //the 'with' is an internal parameter used within the function.
    //the 'predicate' parameter is used to allow for whatever search queries we want to make.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        //predicate used for searches and retrieving data. In this case, it loads all data that matches the items with the parentCategory name attribute.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        //instead of the 2 lines below, need to use optional binding to ensure that it is never 'nil' and crashes app.
        
        //if not nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        
//        request.predicate = compoundPredicate

        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            //searches for that specific request that matches and assigns to itemArray
            itemArray = try context.fetch(request)
        }
        catch{
            print("error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}

//extends the ToDoController so you dont have to put it at the top, plus it modularizes your code into specific functionalities.

//MARK: - Search bar functionality
extension ToDoListViewController : UISearchBarDelegate{
    //delegate method that indicates when the user clicked search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //fetches data from the SQL database
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //the [cd] is to make the search request not case sensitive (c) or diacratic (d) - symbols
        //predicate is a way to fetch data.
        //whatever is typed in the box, once the user searches it replaces the '%@' with the search bar text.
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        //passes in the request made above, then sticks it in an array.
        //predicate in this case is what you see above, indicating the search and not the predicate from load items method (which is categories)
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //only when the text has changed AND!!!! the character count went to 0.
        if searchBar.text?.count == 0{
            loadItems()
            //gets rid of the cursor. Must run on the main queue to work. 
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
        


