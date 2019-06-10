//
//  ViewController.swift
//  My Notes
//
//  Created by Christian on 10/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import CoreData

class MyNotesViewController: UITableViewController
{
    // current app as object, casting to own class AppDelegate, then grapping the persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noteArray = [Note]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadNotes()
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = noteArray[indexPath.row]
        
        cell.textLabel?.text = note.title
        
        // ternary operator:
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = note.isChecked ? .checkmark : .none
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // done equals the opposite of current value
        noteArray[indexPath.row].isChecked = !noteArray[indexPath.row].isChecked
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        saveNotes()
    }
    
    
    //MARK: - Button Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Note", message: "", preferredStyle: .alert)
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Add new Note"
            textField = alertTextField // storing local tf in global variable to increase scope
        }
        
        // when "Add Note" is pressed
        let action = UIAlertAction(title: "Add Note", style: .default)
        { (action) in
            let note = Note(context: self.context)
            
            if note.title == ""
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                note.title = textField.text!
                note.isChecked = false
                self.noteArray.append(note)
                self.saveNotes()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - CRUD Operations
    func saveNotes()
    {
        do
        {
            try context.save()
        }
        catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // external & internal perameter, = default value
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest())
    {
        do
        {
            noteArray = try context.fetch(request)
        }
        catch {
            print("Error loading context: \(error)")
        }
    }
    
    func deleteNote(note: NSManagedObject)
    {
        context.delete(note)
        saveNotes()
    }
}


//MARK: - Searchbar Delegation Methods
extension MyNotesViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text != ""
        {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // not case & diacretic sense
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            request.predicate = predicate
            request.sortDescriptors = [sortDescriptor]
            loadNotes(with: request)
        }
        else
        {
            self.view.endEditing(true)
        }
    }
}
