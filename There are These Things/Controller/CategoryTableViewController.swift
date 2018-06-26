//
//  CategoryTableViewController.swift
//  There are These Things
//
//  Created by Jared Boynton on 6/19/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {

    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //question mark makes it optional and checks if nil. If nil, return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category Cell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            //grabs all of those items associated with that category when the user selects the category
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        //pulls out all data in the category section of Realm.
        //this returns a 'Result' object and therefore have to set the categories array to that type instead of of type 'Category'
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var addCategory = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let category = Category()
            category.name = addCategory.text!
            
            //since the 'Results' object is auto-updating (see docs) then you don't need to append.
            //self.categories.append(category)
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add category"
            addCategory = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}
