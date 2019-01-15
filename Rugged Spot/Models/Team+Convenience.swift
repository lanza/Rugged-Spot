//
//  Team.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 12/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CoreData

extension Team {
    convenience init(name: String, phoneNumber: String?, url: String?, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        self.init(context: context)
        self.name = name
        self.url = url
        self.phoneNumber = phoneNumber
    }
}
