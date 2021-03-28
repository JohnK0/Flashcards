//
//  Flashcard+CoreDataProperties.swift
//  Refine
//
//  Created by John Kim on 3/27/21.
//
//

import Foundation
import CoreData


extension Flashcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashcard> {
        return NSFetchRequest<Flashcard>(entityName: "Flashcard")
    }

    @NSManaged public var body: String?
    @NSManaged public var language: String?
    @NSManaged public var memorized: Bool
    @NSManaged public var setID: String?
    @NSManaged public var source: String?
    @NSManaged public var translation: String?
    @NSManaged public var set: Set?

}

extension Flashcard : Identifiable {

}
