//
//  ViewController.swift
//  There are These Things
//
//  Created by Jared Boynton on 5/26/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {


    let realm = try! Realm()
    //see toDoController for examples.
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category?{
        //once selectedCategory gets a value, then didSet is called
        //we did this because at this point we can be sure we have values and don't crash app.
        didSet{
            loadItems()
        }
    }
    
    
    //you can create different plists that store data in a different plist. Example, work to do list, home to do list, etc. Reduces loading time.

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if toDoItems is not nil
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        //if the toDoItems results are not nil set the accessories and title
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            //if checked mark it true, if false no mark
            cell.accessoryType = item.done ? .checkmark: .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //it toDoItems is not nil
        if let item = toDoItems?[indexPath.row]{
            do{
            try realm.write {
                //done is equal to the opposite
                //item.done = !item.done
                realm.delete(item)

            }
            }catch{
                print("error changing the done propery \(error)")
            }
        }
        tableView.reloadData()
        
        

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //need a popup here to add items. Then append to array.
        
        var addThing = UITextField()
        
        let alert = UIAlertController(title: "Add a Thing", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Thing", style: .default) { (action) in
            //what happens when the user clicks add item on the UI alert.
            
            //if current category is not nil
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = addThing.text!
                        newItem.dateCreated = Date()
                        //this simply assigns the parent category, assigning the item to a category.
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error saving item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        //add a text field to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a thing..."
            addThing = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func loadItems() {
        
        //all of the items that are a part of the selected category. This comes from 'prepareForSegue' in catVC
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
       
        tableView.reloadData()
    }
    
}

//extends the ToDoController so you dont have to put it at the top, plus it modularizes your code into specific functionalities.

//MARK: - Search bar functionality
extension ToDoListViewController : UISearchBarDelegate{
    //delegate method that indicates when the user clicked search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //update toDoItems filtered by the predicate parameter
        //%@ is the search bar text.
        //toDoItems is already populated from the Category VC 'selectedCategory'
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
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



