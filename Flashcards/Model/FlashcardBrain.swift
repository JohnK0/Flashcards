//
//  FlashcardBrain.swift
//  Flashcards
//
//  Created by John Kim on 11/24/20.
//

import Foundation

struct FlashcardBrain {
    
    private var allFlashcards = [
        Flashcard(text: "but those who hope in the LORD will renew their strength.\nThey will soar on wings like eagles;\nthey will run and not grow weary,\nthey will walk and not be faint.\n     - Isaiah 40:31"),
        Flashcard(text: "10 So do not fear, for I am with you;\ndo not be dismayed, for I am your God.\nI will strengthen you and help you;\nI will uphold you with my righteous right hand.\n     Isaiah 41:10"),
        Flashcard(text: "One thing have I asked of the LORD, that will I seek after:\nthat I may dwell in the house of the LORD all the days of my life,\nto gaze upon the beauty of the LORD and to inquire in his temple.\n     - Psalm 27:4"),
        Flashcard(text: "For I am convinced that neither death nor life,\nneither angels nor demons, neither the present nor the future,\nnor any powers, neither height nor depth,\nnor anything else in all creation,\nwill be able to separate us from the love of God\nthat is in Christ Jesus our Lord.\n     -Romans 8:38-39")
    ]
    private var currentFlashcards = Queue()
    private var allFlashcardCount: Int
    
    init (){
        currentFlashcards.addList(allFlashcards)
        allFlashcardCount = allFlashcards.count
    }
    mutating func reset() {
        setupFlashcards()
    }
    mutating func setupFlashcards() {
        shuffleFlashcards()
        currentFlashcards.addList(allFlashcards)
    }
    func noCurrentFlashcardsLeft() -> Bool{
        if  currentFlashcards.getCount() == 0 {
            return true
        }
        return false
    }
    mutating func shuffleFlashcards() { // self.variables: flashcards
        allFlashcards.shuffle()
    }
    mutating func addFlashcard(_ userText: String) {
        allFlashcardCount += 1
        let text = Flashcard(text: userText)
        allFlashcards.append(text)
        currentFlashcards.enqueue(text)
    }
    mutating func memorizedFlashcard() {
        _ = currentFlashcards.dequeue()
    }
    mutating func rotate() {
        currentFlashcards.rotate()
    }
    func getCurrentFlashcardCount() -> Int {
        currentFlashcards.getCount()
    }
    func getAllFlashcardCount() -> Int {
        return allFlashcardCount
    }
    func flashcard() -> Flashcard {
        return currentFlashcards.getNode()
    }
}
