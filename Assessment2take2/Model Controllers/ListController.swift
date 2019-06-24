//
//  ListController.swift
//  Assessment2take2
//
//  Created by Drew Seeholzer on 6/23/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    
    static var sharedInstance = ListController()
    
    var fetchedResultsController: NSFetchedResultsController<List>
    
    init() {
        
        let request: NSFetchRequest<List> = List.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isChecked", ascending: false)]
        let resultsController: NSFetchedResultsController<List> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.managedObjectContext, sectionNameKeyPath: "Checked", cacheName: nil)
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch. \(error.localizedDescription)")
        }
    }
    
    //MARK: - CRUD
    
    func add(itemWithName item: String) {
        let _ = List(item: item)
        saveToPersistentStore()
    }
    
    func toggleIsCheckedFor(item: List) {
        item.isChecked = !item.isChecked
        saveToPersistentStore()
    }
    
    func delete(item: List) {
        CoreDataStack.managedObjectContext.delete(item)
        saveToPersistentStore()
    }
    
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context, item not saved")
        }
    }
}
