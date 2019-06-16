//
//  CategoryRepository.swift
//  My Notes
//
//  Created by Christian on 16/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import Foundation
import CoreData

class CategoryRepository: CategoryRepoProtocol
{
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext)
    {
        self.context = context
    }
    

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
    
    func loadAll() -> [Category]
    {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        var categories = [Category]()
        do
        {
            try categories = context.fetch(request)
        }
        catch
        {
            print("Error loading categories: \(error)")
        }
        return categories
    }
    
    func deleteFromSwipe(at indexPath: IndexPath, fromArray categories: inout[Category]) -> [Category]
    {
        let category = categories[indexPath.row]
        context.delete(category)
        categories.remove(at: indexPath.row)
        saveAll()
        return categories
    }
}
