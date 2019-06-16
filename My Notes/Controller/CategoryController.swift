//
//  CategoryTableViewController.swift
//  My Notes
//
//  Created by Christian on 11/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import ChameleonFramework
import FBSDKCoreKit

class CategoryController: SwipeCellController
{
    let categoryRepository = CategoryRepository(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    var categories = [Category]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        categories = categoryRepository.loadAll()
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
    
    
    //MARK: - Seague Prepare
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField // storing local tf in global variable to increase scope
        }
        
        // when "Add Category" is pressed
        let action = UIAlertAction(title: "Add Category", style: .default)
        { (action) in
            let category = Category(context: context)
            
            if textField.text == ""
            {
                alert.dismiss(animated: true, completion: nil)
            }
            else
            {
                category.name = textField.text!
                category.color = UIColor.randomFlat.hexValue()
                self.categories.append(category)
                self.categoryRepository.saveAll()
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
    
    
    //MARK: - Delete Override
    override func deleteModelFromSwipe(at indexPath: IndexPath)
    {
        categories = categoryRepository.deleteFromSwipe(at: indexPath, fromArray: &categories)
    }
}
