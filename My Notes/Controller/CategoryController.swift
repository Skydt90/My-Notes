//
//  CategoryTableViewController.swift
//  My Notes
//
//  Created by Christian on 11/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework
import FBSDKCoreKit

class CategoryController: SwipeCellController
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadCategories()
    }

    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories[indexPath.row]
    
        cell.textLabel?.text = category.name
        cell.backgroundColor = UIColor(hexString: category.color ?? "FF9810") // default value if empty
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color ?? "FF9810")!, returnFlat: true)
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "showNotes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destination = segue.destination as! NoteController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destination.category = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Button Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField // storing local tf in global variable to increase scope
        }
        
        // when "Add Category" is pressed
        let action = UIAlertAction(title: "Add Category", style: .default)
        { (action) in
            let category = Category(context: self.context)
            
            if textField.text == ""
            {
                alert.dismiss(animated: true, completion: nil)
            }
            else
            {
                category.name = textField.text!
                category.color = UIColor.randomFlat.hexValue()
                self.categories.append(category)
                self.saveCategories()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem)
    {
        let alertController = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Yes", style: .default)
        { _ in
            AccessToken.current = nil
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(UIAlertAction(title: "No", style: .default))
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - CRUD Operations
    func saveCategories()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            try categories = context.fetch(request)
        }
        catch
        {
            print("Error loading categories: \(error)")
        }
    }
    
    override func deleteModelFromSwipe(at indexPath: IndexPath)
    {
        let category = categories[indexPath.row]
        context.delete(category)
        categories.remove(at: indexPath.row)
        saveCategories()
    }
}
