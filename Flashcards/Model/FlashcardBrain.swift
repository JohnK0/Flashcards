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
    private var currentFlashcards = LinkedList<NSManagedObject>()
    private var currFlashcard: Node<NSManagedObject>?
    private var itr = 0
    private var flashcardLength: Int = 0
    
    mutating func setFlashcards(_ flashcards: [NSManagedObject]) {
        self.flashcards = flashcards
        setupFlashcards()
    }
    
    mutating func setupFlashcards() {
//        shuffleFlashcards()
        currentFlashcards.removeAll()
        for flashcard in flashcards {
            flashcard.setValue(false, forKey: "Memorized")
            currentFlashcards.append(value: flashcard)
        }
        currentFlashcards.first!.previous = currentFlashcards.last
        currentFlashcards.last!.next = currentFlashcards.first
        currFlashcard = currentFlashcards.first
        print(currentFlashcards.getCount())
        print((currentFlashcards.first!.value.value(forKey: "source") as? String)!)
        
    }
    
    mutating func shuffleFlashcards() { // self.variables: flashcards
        flashcards.shuffle()
    }
    
    func getFlashcards() -> [NSManagedObject]{
        return flashcards
    }
    
    func noCurrentFlashcardsLeft() -> Bool{
        if  currentFlashcards.isEmpty {
            return true
        }
        return false
    }
    
    
    mutating func addFlashcard(_ flashcard: NSManagedObject) {
        flashcards.append(flashcard)
        currentFlashcards.append(value: flashcard)
    }
    
    mutating func memorizedFlashcard() {
        let temp = currFlashcard!.next
        _ = currentFlashcards.remove(node: currFlashcard!)
        currFlashcard = temp
        print((currFlashcard!.value.value(forKey: "source") as? String)!)
    }
    mutating func back() {
        currFlashcard = currFlashcard!.previous
    }
    mutating func next() {
        currFlashcard = currFlashcard!.next
    }
    func getCurrentFlashcardCount() -> Int {
        currentFlashcards.getCount()
    }
    func getAllFlashcardCount() -> Int {
        return flashcards.count
    }
    func getCurrentFlashcard() -> NSManagedObject {
        return currFlashcard!.value
    }

    
}
