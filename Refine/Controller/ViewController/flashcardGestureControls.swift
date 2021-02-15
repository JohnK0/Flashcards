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
                        hapticFeedback(3)
                        uiView.animateBackground(view: self.flashcardView, color: UIColor(named: flashcardViewBackgroundColor)!)
                        memorizeHoldToCancelTimer?.invalidate()
                        let touchLocation = sender.location(in: flashcardView)
                        if flashcardView.bounds.contains(touchLocation) {
                            print("End")
                            memorizedFlashcard()
                        }
                    case .began:
                        hapticFeedback(3)
                        uiView.animateBackground(view: self.flashcardView, color: UIColor(named:flashcardViewMemorizingBackgroundColor)!)
                        memorizeHoldToCancelTimer?.invalidate()
                        memorizeHoldToCancelTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(memorizeHoldToCancelDuration), repeats: false) { _ in
                                    sender.state = .cancelled
                                }
//                        memorizeHoldTimer = Timer.scheduledTimer(timeInterval: TimeInterval(memorizeHoldDuration), repeats: false)
                        print("Began")
                    case .cancelled:
                        hapticFeedback(3)
                        uiView.animateBackground(view: self.flashcardView, color: UIColor(named:flashcardViewBackgroundColor)!)
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
        updateFlashcardView()
    }
    
    @objc func makeHalf() {
        full = false
        hapticFeedback(3)
        updateFlashcardView(down: true)
    }
    
    @objc func toggleBetweenFrontandBack() {
        hapticFeedback(3)
        defaultSide = !defaultSide
        updateFlashcardView()
    }
    
    @objc func swipeToPreviousFlashcard() {
        hapticFeedback(3)
        moveFlashcardControlCurrentPage(direction: -1)
        previousFlashcard()
    }
    
    @objc func SwipeToNextFlashcard() {
        hapticFeedback(3)
        moveFlashcardControlCurrentPage(direction: 1)
        nextFlashcard()
    }
    
    
    @objc func flip() {
        if !full {
            hapticFeedback(2)
            updateFlashcardView(flip: true)
        }
    }

}
