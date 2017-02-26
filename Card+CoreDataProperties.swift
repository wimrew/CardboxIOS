//
//  Card+CoreDataProperties.swift
//  CardBoxIOS
//
//  Created by macmini on 2/4/17.
//  Copyright © 2017 macmini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Card {

    @NSManaged var fronttext: String?
    @NSManaged var backtext: String?
    @NSManaged var deckname: String?
    @NSManaged var path: String?
    @NSManaged var id: NSNumber
    
}
