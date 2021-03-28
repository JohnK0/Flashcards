//
//  Set+CoreDataProperties.swift
//  Refine
//
//  Created by John Kim on 3/27/21.
//
//

import Foundation
import CoreData


extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }
    @NSManaged public var name: String?
    @NSManaged public var flashcard: NSSet?

}

// MARK: Generated accessors for flashcard
extension Set {

    @objc(addFlashcardObject:)
    @NSManaged public func addToFlashcard(_ value: Flashcard)

    @objc(removeFlashcardObject:)
    @NSManaged public func removeFromFlashcard(_ value: Flashcard)

    @objc(addFlashcard:)
    @NSManaged public func addToFlashcard(_ values: NSSet)

    @objc(removeFlashcard:)
    @NSManaged public func removeFromFlashcard(_ values: NSSet)

}

extension Set : Identifiable {

}
