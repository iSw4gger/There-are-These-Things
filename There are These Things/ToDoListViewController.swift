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
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgan"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //grabbing a reference to the cell that is selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //deselects the row so it doesn't stay gray.
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

