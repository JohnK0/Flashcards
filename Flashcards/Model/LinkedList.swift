//
//  Queue.swift
//  Flashcards
//
//  Code based from
// https://www.raywenderlich.com/947-swift-algorithm-club-swift-linked-list-data-structure

import Foundation
        
public class Node<T> {
  var value: T
  var next: Node<T>?
  weak var previous: Node<T>?

  init(value: T) {
    self.value = value
  }
}

public class LinkedList<T> {
    fileprivate var head: Node<T>?
    private var tail: Node<T>?
    private var count: Int = 0
    
    public var isEmpty: Bool {
        return head == nil
    }

    public var first: Node<T>? {
        return head
    }

    public var last: Node<T>? {
        return tail
    }

    public func append(value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
            if let headNode = head {
                newNode.next = headNode
                headNode.previous = newNode
            } else {
                print("No head node")
            }
            
        } else {
          head = newNode
        }
        tail = newNode
        count = count + 1
    }

    public func nodeAt(index: Int) -> Node<T>? {
        if index >= 0 {
          var node = head
          var i = index
          while node != nil {
            if i == 0 { return node }
            i -= 1
            node = node!.next
          }
        }
        return nil
    }

    public func removeAll() {
        head = nil
        tail = nil
        count = 0
    }

    public func remove(node: Node<T>) -> T {
        if self.count == 2 {
            node.next!.previous = nil
            node.next!.next = nil
        } else {
            let prev = node.previous
            let next = node.next

            if let prev = prev {
              prev.next = next
            } else {
              head = next
            }
            next?.previous = prev

            if next == nil {
              tail = prev
            }

            node.previous = nil
            node.next = nil
        }
        count = count - 1
        return node.value
    }
    
    public func getCount() -> Int {
        return count
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var text = "["
        var node = head

        while node != nil {
          text += "\(node!.value)"
          node = node!.next
          if node != nil { text += ", " }
        }
        return text + "]"
    }
}
