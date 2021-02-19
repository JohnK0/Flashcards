//
//  FlashcardBrain.swift
//  Flashcards
//
//  Created by John Kim on 11/24/20.
//

import Foundation
import CoreData

struct FlashcardBrain {
    private var flashcards: [NSManagedObject] = []
    private var currFlashcards = LinkedList<NSManagedObject>()
    private var currFlashcard: Node<NSManagedObject>?
    private var itr = 0
    private var flashcardLength: Int = 0
    private var emptyDeck = true
    
    mutating func setFlashcards(_ flashcards: [NSManagedObject]) {
        if !flashcards.isEmpty {
            self.flashcards = flashcards
            setupFlashcards()
        }
    }
    
    mutating func setupFlashcards() {
        emptyDeck = false
//        shuffleFlashcards()
        currFlashcards.removeAll()
        for flashcard in flashcards {
            flashcard.setValue(false, forKey: "Memorized")
            currFlashcards.append(value: flashcard)
        }
        currFlashcards.first!.previous = currFlashcards.last
        currFlashcards.last!.next = currFlashcards.first
        currFlashcard = currFlashcards.first
        print(currFlashcards.getCount())
        print((currFlashcards.first!.value.value(forKey: "source") as? String)!)
        
    }
    
    mutating func shuffleFlashcards() { // self.variables: flashcards
        flashcards.shuffle()
    }
    
    func getFlashcards() -> [NSManagedObject]{
        return flashcards
    }
    
    func noCurrentFlashcardsLeft() -> Bool{
        if  currFlashcards.isEmpty {
            return true
        }
        return false
    }
    
    
    mutating func addFlashcard(_ flashcard: NSManagedObject) {
        flashcards.append(flashcard)
        currFlashcards.append(value: flashcard)
        if emptyDeck {
            currFlashcard = currFlashcards.first
        }
        
    }
    
    mutating func deleteFlashcard(_ managedContext: NSManagedObjectContext) {
        // Remove the flashcard
        managedContext.delete(currFlashcard!.value)
        
        // Save the data
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        for i in 0...flashcards.count {
            if flashcards[i] == currFlashcard!.value {
                flashcards.remove(at: i)
                break
            }
        }
        let temp = currFlashcard!
        currFlashcard = currFlashcard!.next				
        _ = currFlashcards.remove(node: temp)
    }
    
    mutating func memorizedFlashcard() {
        let temp = currFlashcard!.next
        _ = currFlashcards.remove(node: currFlashcard!)
        currFlashcard = temp
        if temp != nil {
            print((currFlashcard!.value.value(forKey: "source") as? String)!)
        }
        
    }
    mutating func back() {
        if let previous = currFlashcard?.previous {
            currFlashcard = previous
        } else {
            return
        }
    }
    mutating func next() {
        if let next = currFlashcard?.next {
            currFlashcard = next
        } else {
            return
        }
    }
    func getCurrentFlashcardCount() -> Int {
        currFlashcards.getCount()
    }
    func getAllFlashcardCount() -> Int {
        return flashcards.count
    }
    func getCurrentFlashcard() -> NSManagedObject? {
        return currFlashcard?.value
    }

    
}
