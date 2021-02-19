//
//  Set+CoreDataProperties.swift
//  Refine
//
//  Created by John Kim on 2/18/21.
//
//

import Foundation
import CoreData


extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var name: String?

}

extension Set : Identifiable {

}
