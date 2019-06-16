//
//  NoteRepository.swift
//  My Notes
//
//  Created by Christian on 16/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import Foundation
import CoreData

class NoteRepository: NoteRepoProtocol
{
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext)
    {
        self.context = context
    }
    
    
    //MARK: - CRUD Operations
    func saveAll()
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
    
    func loadAll(with request: NSFetchRequest<Note> = Note.fetchRequest(), and predicate: NSPredicate? = nil, category: Category) -> [Note]
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
        var notes = [Note]()
        
        // optional binding to check nil value in arg
        if let compoundPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, compoundPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do
        {
            notes = try context.fetch(request)
        }
        catch
        {
            print("Error loading context: \(error)")
        }
        return notes
    }
    
    func deleteFromSwipe(at indexPath: IndexPath, fromArray notes: inout[Note]) -> [Note]
    {
        let note = notes[indexPath.row]
        context.delete(note)
        notes.remove(at: indexPath.row)
        saveAll()
        return notes
    }
}
