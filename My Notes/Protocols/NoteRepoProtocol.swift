//
//  NoteProtocol.swift
//  My Notes
//
//  Created by Christian on 16/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import Foundation
import CoreData

protocol NoteRepoProtocol
{
    func saveAll()
    func loadAll(with request: NSFetchRequest<Note>, and predicate: NSPredicate?, category: Category) -> [Note]
    func deleteFromSwipe(at indexPath: IndexPath, fromArray notes: inout[Note]) -> [Note]
}
