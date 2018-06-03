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

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Test"
        itemArray.append(newItem2)
        
        
        for n in itemArray{
            print(n.title)
        }
        
        //grabbing the user defaults and sticking them in the array.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        
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
    
        
        //grabbing a reference to the cell that is selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.tableView.reloadData()
            
            //stored in a p list file
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            print("Success!")
        }
        
        //add a text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a thing..."
            addThing = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
            
}
        
        

    

