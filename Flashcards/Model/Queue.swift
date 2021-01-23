//
//  Queue.swift
//  Flashcards
//
//  Created by John Kim on 11/25/20.
//

import Foundation
import CoreData

struct Queue {
    private var queue = [NSManagedObject]()
    
    mutating func addList(_ list: [NSManagedObject]) {
        queue = list
    }
    mutating func dequeue() -> NSManagedObject {
        return queue.removeFirst()
        
    }
    mutating func enqueue(_ node: NSManagedObject) {
        queue.append(node)
    }
    mutating func rotate() {
        enqueue(dequeue())
    }
    
    func getNode() -> NSManagedObject {
        return queue.first!
    }
    
    func getCount() -> Int {
        return queue.count
    }
}
