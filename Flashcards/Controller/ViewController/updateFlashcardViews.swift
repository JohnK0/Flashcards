////
////  updateFlashcardViews.swift
////  Flashcards
////
////  Created by John Kim on 1/28/21.
////
//
import UIKit
//
extension ViewController {
//    
    func resetFlashcardControl() {
        flashcardControl.numberOfPages = flashcardBrain.getCurrentFlashcardCount()
    }
    func removeFlashcardControlPage() {
        flashcardControl.numberOfPages = flashcardControl.numberOfPages - 1
    }
    func moveFlashcardControlCurrentPage (direction: Int) {
        let currentCount = flashcardBrain.getCurrentFlashcardCount()
        if currentCount > 1 {
            if direction == 1 && flashcardControl.currentPage == currentCount - 1 {
                flashcardControl.currentPage = 0
            } else if direction == -1 && flashcardControl.currentPage == 0{
                flashcardControl.currentPage = currentCount-1
            } else {
                flashcardControl.currentPage = flashcardControl.currentPage + direction
            }
        }
    }
//    
    func updateFlashcardLabel(flip: Bool = false, down: Bool = false) {
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardLabel.text = "To add a flashcard, press the add button on the top right."
            return
        }
        let label = UILabel()
        var attributedText: NSMutableAttributedString
        if flashcardBrain.getCurrentFlashcard() == nil {
            attributedText = frodoGandalfQuote(label)
        } else {
            
            if full {
                attributedText = getFrontText(label, underline: true)
                attributedText.append(NSMutableAttributedString(string: "\n\n"))
                attributedText.append(getBackText(label))
            } else if flip || down {
                if flip {
                    currSide = !currSide
                }
                if currSide {
                    attributedText = getBackText(label)
                } else {
                    attributedText = getFrontText(label)
                }
            } else {
                if defaultSide {
                    attributedText = getBackText(label)
                } else {
                    attributedText = getFrontText(label)
                }
            }
        }
        flashcardLabel.attributedText = attributedText
    }
    
    func updateProgressBar() {
        let currentFlashcardCount = flashcardBrain.getCurrentFlashcardCount()
        let allFlashcardCount = flashcardBrain.getAllFlashcardCount()
        if allFlashcardCount == 0 {
            progressBar.progress = 0
        } else {
        progressBar.progress = 1.0 - Float(currentFlashcardCount)/Float(allFlashcardCount)
        }
    }
    
    func getFrontText(_ label: UILabel, underline: Bool = false) -> NSMutableAttributedString {
        var attributedText = label.createAttributedText(text: (flashcardBrain.getCurrentFlashcard()!.value(forKey: "source") as? String)!, textSize: 28, alignment: .center)
        if underline {
            attributedText = label.underlineAttributedText(attributedText, color: "BodyTextColor")
        }
        return attributedText
    }
    
    func getBackText(_ label: UILabel) -> NSMutableAttributedString {
        return label.createAttributedText(text: (flashcardBrain.getCurrentFlashcard()!.value(forKey: "body") as? String)!, textSize: 17, spacing: 5)
    }

    func frodoGandalfQuote(_ label: UILabel) -> NSMutableAttributedString {
        let frodo = "Frodo"
        let frodoQuote = "I wish it need not have happened in my time."
        let gandalf = "Gandalf the Grey"
        let gandalfQuote = "So do I, and so do all who live to see such times. But that is not for them to decide. All we have to decide is what to do with the time that is given us."
        let attributedText = label.createAttributedText(text: frodo, textSize: headerTextSize, alignment: .center, underline: true)
        attributedText.append(NSMutableAttributedString(string: "\n"))
        attributedText.append(label.createAttributedText(text: frodoQuote, textSize: bodyTextSize, spacing: bodySpacing))
        attributedText.append(NSMutableAttributedString(string: "\n"))
        attributedText.append(label.createAttributedText(text: gandalf, textSize: headerTextSize, alignment: .center, underline: true))
        attributedText.append(NSMutableAttributedString(string: "\n"))
        attributedText.append(label.createAttributedText(text: gandalfQuote, textSize: bodyTextSize, spacing: bodySpacing))
        return attributedText
    }
//    
}
