//
//  ViewController.swift
//  My Notes
//
//  Created by Christian on 10/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit

class MyNotesViewController: UITableViewController
{

    var noteArray = ["note 1", "note 2", "note 3"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = noteArray[indexPath.row]
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Button Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default)
        { (action) in
            // when "Add Note" is pressed
            self.noteArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Add new Note"
            textField = alertTextField // storing local tf in global variable to increase scope
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

