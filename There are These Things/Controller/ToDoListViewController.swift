//
//  ViewController.swift
//  There are These Things
//
//  Created by Jared Boynton on 5/26/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
//since this class inherits table view controller, we don't have to do all the methods required when setting up a table view(delegate, data source, etc.). This comes behind the scenes.
    
    var itemArray = [Item]()
    
    //grabbing a file path to where the data will be stored. Using .first
    
    //you can create different plists that store data in a different plist. Example, work to do list, home to do list, etc. Reduces loading time.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Test"
        itemArray.append(newItem2)
        
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
        //print(itemArray[indexPath.row])
        
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
            
            let newItem = Item()
            newItem.title = addThing.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        //add a text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a thing..."
            addThing = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            //writing data to the URL path above.
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding")
        }
        
        self.tableView.reloadData()
    }
    
    //loads data that loads the contents of the URL (from the FilePath above)
    func loadItems() {
        //encoding saves it, decoding reads it
        //try reading it using decode
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                //if able to read it, add to this array using the decode from the dataFilePath
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array \(error)")
            }
        }
    }
}
        
        


