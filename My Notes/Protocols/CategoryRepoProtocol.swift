//
//  File.swift
//  My Notes
//
//  Created by Christian on 16/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import Foundation
import CoreData

protocol CategoryRepoProtocol
{
    func saveAll()
    func loadAll() -> [Category]
    func deleteFromSwipe(at indexPath: IndexPath, fromArray categories: inout[Category]) -> [Category]
}
