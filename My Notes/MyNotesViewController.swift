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

    let noteArray = ["note 1", "note 2", "note 3"]
    
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


}

