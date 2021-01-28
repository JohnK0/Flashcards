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
    
    mutating func memorizedFlashcard() {
        let temp = currFlashcard!.next
        _ = currFlashcards.remove(node: currFlashcard!)
        currFlashcard = temp
        if temp != nil {
            print((currFlashcard!.value.value(forKey: "source") as? String)!)
        }
        
    }
    mutating func back() {
        currFlashcard = currFlashcard?.previous
    }
    mutating func next() {
        currFlashcard = currFlashcard?.next
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
