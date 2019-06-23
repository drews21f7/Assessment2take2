//
//  List+Convenience.swift
//  Assessment2take2
//
//  Created by Drew Seeholzer on 6/23/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation
import CoreData

extension List {
    
    @discardableResult
    convenience init(item: String, context: NSManagedObjectContext = CoreDataStack.managedObjectContext ) {
        self.init(context: context)
        self.item = item
    }
}
