//
//  SwipeCellController.swift
//  My Notes
//
//  Created by Christian on 11/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellController: UITableViewController, SwipeTableViewCellDelegate // protocol
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    
    //MARK: - SwipeCell Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        guard orientation == .right
            else
        {
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { (action, indexPath) in
            self.deleteModelFromSwipe(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "trash-icon")
        
        return [deleteAction]
    }
    
    // makes full swipe possible
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions
    {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func deleteModelFromSwipe(at indexPath: IndexPath)
    {
        // override in subclass
    }
}
