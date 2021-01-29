//
//  flashcardGestureControls.swift
//  Flashcards
//
//  Created by John Kim on 1/28/21.
//

import UIKit

extension ViewController {
    
    func createDirectionFunction(selector: Selector, direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer{
        
        
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: selector)
        recognizer.direction = direction
        return recognizer
    }
    
    @objc func heldToMemorize(sender: UILongPressGestureRecognizer) {
        if !flashcardBrain.noCurrentFlashcardsLeft() {
            switch (sender.state) {
                    case .ended:
                        memorizeHoldToCancelTimer?.invalidate()
                        let touchLocation = sender.location(in: flashcardLabel)
                        if flashcardLabel.bounds.contains(touchLocation) {
                            print("End")
                            memorizedFlashcard()
                        }
                    case .began:
                        memorizeHoldToCancelTimer?.invalidate()
                        memorizeHoldToCancelTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(memorizeHoldToCancelDuration), repeats: false) { _ in
                                    sender.state = .cancelled
                                }
//                        memorizeHoldTimer = Timer.scheduledTimer(timeInterval: TimeInterval(memorizeHoldDuration), repeats: false)
                        print("Began")
                    case .cancelled:
                        print("Cancelled")
                    case .changed:
                        print("Changed")
                    default:
                        print("Nothing")
                }
        }
    }
    
    @objc func makeFull(a: Int) {
        full = true
        hapticFeedback(3)
        updateFlashcardLabel()
    }
    
    @objc func makeHalf() {
        full = false
        hapticFeedback(3)
        updateFlashcardLabel(down: true)
    }
    
    @objc func toggleBetweenFrontandBack() {
        hapticFeedback(3)
        defaultSide = !defaultSide
        updateFlashcardLabel()
    }
    
    @objc func lastFlashcard() {
        hapticFeedback(2)
        moveFlashcardControlCurrentPage(direction: -1)
        flashcardBrain.back()
            updateFlashcardLabel(flip: false)
    }
    
    @objc func nextFlashcard() {
        hapticFeedback(2)
        moveFlashcardControlCurrentPage(direction: 1)
        flashcardBrain.next()
            updateFlashcardLabel(flip: false)
    }
    
    @objc func flip() {
        if !full {
            hapticFeedback(2)
            updateFlashcardLabel(flip: true)
        }
    }

}
