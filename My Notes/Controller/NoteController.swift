//
//  ViewController.swift
//  My Notes
//
//  Created by Christian on 10/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class NoteController: SwipeCellController
{
    @IBOutlet weak var searchBar: UISearchBar!
    let noteRepository = NoteRepository(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    var notes = [Note]()
    var category : Category?
    {
        didSet
        {
            notes = noteRepository.loadAll(category: category!)
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        notes = noteRepository.loadAll(category: category!)
        self.tableView.reloadData()
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.title
        // only move forward with .darken if not unwrapped as nil
        if let color = UIColor(hexString: category!.color!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(notes.count))
        {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.tintColor = ContrastColorOf(color, returnFlat: true)
        }
        
        // ternary operator:
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = note.isChecked ? .checkmark : .none
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // done equals the opposite of current value
        notes[indexPath.row].isChecked = !notes[indexPath.row].isChecked
        
        tableView.reloadData()
        
        noteRepository.saveAll()
    }
    
    
    //MARK: - Button Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        // current app as object, casting to own class AppDelegate, then grapping the persistentContainer
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
            let note = Note(context: context)
            
            if textField.text == ""
            {
                alert.dismiss(animated: true, completion: nil)
            }
            else
            {
                note.title = textField.text!
                note.isChecked = false
                note.parentCategory = self.category
                self.notes.append(note)
                self.noteRepository.saveAll()
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Delete Override
    override func deleteModelFromSwipe(at indexPath: IndexPath)
    {
        notes = noteRepository.deleteFromSwipe(at: indexPath, fromArray: &notes)
    }
    
    
    //MARK: - Styling Navigation Bar
    func styleNavigation(withHexCode hexcode: String)
    {
        guard let navigationBar = navigationController?.navigationBar else {fatalError()}
        guard let navigationColor = UIColor(hexString: hexcode) else {fatalError()}

        searchBar.barTintColor = navigationColor
        navigationBar.barTintColor = navigationColor
        navigationBar.tintColor = ContrastColorOf(navigationColor, returnFlat: true)
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navigationColor, returnFlat: true)]
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        title = category?.name
        guard let color = category?.color else {fatalError()}
        styleNavigation(withHexCode: color)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        styleNavigation(withHexCode: "FF9810")
    }
}


//MARK: - Searchbar Delegation Methods
extension NoteController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text != ""
        {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // non case & diacretic
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            notes = noteRepository.loadAll(with: request, and: predicate, category: category!)
            self.tableView.reloadData()
        }
        else
        {
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count == 0)
        {
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
                self.notes = self.noteRepository.loadAll(category: self.category!)
                self.tableView.reloadData()
            }
        }
    }
}
