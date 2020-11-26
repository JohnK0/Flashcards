//
//  Queue.swift
//  Flashcards
//
//  Created by John Kim on 11/25/20.
//

import Foundation

struct Queue {
    private var queue = [Flashcard]()
    var count: Int = 0
    
    mutating func addList(_ list: [Flashcard]) {
        queue = list
        count = queue.count
    }
    mutating func dequeue() -> Flashcard {
        count -= 1
        return queue.removeFirst()
        
    }
    mutating func enqueue(_ node: Flashcard) {
        queue.append(node)
        count += 1
    }
    mutating func rotate() {
        enqueue(dequeue())
    }
    
    func getNode() -> Flashcard {
        return queue.first!
    }
    
    func getCount() -> Int {
        return count
    }
}
