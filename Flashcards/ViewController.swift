//
//  ViewController.swift
//  Flashcards
//
//  Created by John Kim on 11/20/20.
//

import UIKit

class ViewController: UIViewController {
    
    var flashcards = [String]()
    var tempFlashcards = [String]()
    var total = 0
    var finished = false
    
    @IBOutlet weak var flashcardLabel: UILabel!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var memorizedButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToFlashcards()
        total = flashcards.count
        tempFlashcards = flashcards
        tempFlashcards.shuffle()
        
        updateProgressBar()
        updateFlashcardLabel(text: tempFlashcards[0])
        
    }

    func addToFlashcards() {
        flashcards.append("Hello")
        flashcards.append("Bye")
    }
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle!)
        if !finished {
            if sender.currentTitle! == "Memorized" {
                memorizedButtonPressed()
                updateProgressBar()
            }
            if sender.currentTitle! == "Redo" {
                redoButtonPressed()
            }
        }
    }
    func redoButtonPressed() {
        let temp = tempFlashcards.first!
        tempFlashcards.removeFirst()
        tempFlashcards.append(temp)
        updateFlashcardLabel(text:tempFlashcards.first!)
    }
    
    func memorizedButtonPressed() {
        if tempFlashcards.count > 1 {
            tempFlashcards.removeFirst()
            updateFlashcardLabel(text:tempFlashcards.first!)
        } else {
            finished = true
            tempFlashcards.removeFirst()
            updateFlashcardLabel()
        }
    }
    
    func updateFlashcardLabel(text: String = "O̲ppa̲ (っ-̶●̃益●̶̃)っ ,︵‿ S̲t̲yl̲e̲") {
        flashcardLabel.text = text
    }
    
    func updateProgressBar() {
        progressBar.progress = 1.0 - Float(tempFlashcards.count)/Float(total)
    }
    
}

public struct Queue<T> {
  private var elements: [T] = []

  mutating func enqueue(_ value: T) {
    elements.append(value)
  }

  mutating func dequeue() -> T? {
    guard !elements.isEmpty else {
      return nil
    }
    return elements.removeFirst()
  }

  var head: T? {
    return elements.first
  }

  var tail: T? {
    return elements.last
  }
}
