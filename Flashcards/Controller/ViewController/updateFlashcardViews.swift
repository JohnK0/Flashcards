////
////  updateFlashcardViews.swift
////  Flashcards
////
////  Created by John Kim on 1/28/21.
////
//
import UIKit
//

extension UITextView {
   func centerVertically() {
       let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
       let size = sizeThatFits(fittingSize)
       let topOffset = (bounds.size.height - size.height * zoomScale) / 2
       let positiveTopOffset = max(1, topOffset)-10
       contentOffset.y = -positiveTopOffset
   }
}

extension UIView {
    func animateBackground(view: UIView, color: UIColor, duration: Float = 0.2) {
        UIView.transition(with: view, duration: TimeInterval(duration), options: .transitionCrossDissolve, animations: {
            view.backgroundColor = color
        },
        completion: nil)
    }
    
    func animateProgressTintColor(view: UIProgressView, color: UIColor, duration: Float = 0.4) {
        UIView.transition(with: view, duration: TimeInterval(duration), options: .transitionCrossDissolve, animations: {
            view.progressTintColor = color
        },
        completion: nil)
    }
}

extension ViewController {
    
    func resetFlashcardControl() {
        flashcardControl.numberOfPages = flashcardBrain.getCurrentFlashcardCount()
        flashcardControl.currentPage = 0
        currentPage = 0
    }
    func removeFlashcardControlPage() {
        if currentPage == flashcardControl.numberOfPages-1 {
            flashcardControl.currentPage = 0
            currentPage = 0
        }
        flashcardControl.numberOfPages = flashcardControl.numberOfPages - 1
        
    }
    func moveFlashcardControlCurrentPage (direction: Int) {
        let currentCount = flashcardBrain.getCurrentFlashcardCount()
        if currentCount > 1 {
            if direction == 1 && flashcardControl.currentPage == currentCount - 1 {
                flashcardControl.currentPage = 0
                currentPage = 0
            } else if direction == -1 && flashcardControl.currentPage == 0{
                flashcardControl.currentPage = currentCount-1
                currentPage = currentCount-1
            } else {
                flashcardControl.currentPage = flashcardControl.currentPage + direction
                currentPage = currentPage + direction
            }
        }
    }
    
    func previousFlashcard() {
        flashcardBrain.back()
        updateFlashcardView(flip: false)
    }
    
    func nextFlashcard() {
        flashcardBrain.next()
        updateFlashcardView(flip: false)
    }
    
    func updateFlashcardView(flip: Bool = false, down: Bool = false) {
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardView.text = "To add a flashcard, press the add button on the top right."
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
            } else if flip {
                currSide = !currSide
                if currSide {
                    attributedText = getBackText(label)
                } else {
                    attributedText = getFrontText(label)
                }
            } else if down {
                attributedText = getFrontText(label)
            } else {
                if defaultSide {
                    attributedText = getBackText(label)
                } else {
                    attributedText = getFrontText(label)
                }
            }
        }
        
        flashcardView.attributedText = attributedText
        flashcardView.centerVertically()
    }
    
    func updateProgressBar() {
        let currentFlashcardCount = flashcardBrain.getCurrentFlashcardCount()
        let allFlashcardCount = flashcardBrain.getAllFlashcardCount()
        if allFlashcardCount == 0 {
            progressBar.progress = 0
        } else {
            if progressBar.progressTintColor == UIColor(named: progressBarProgressTintColor)! {
                uiView.animateProgressTintColor(view: progressBar, color: .orange, duration: 0.2)
            }
        progressBar.progress = 1.0 - Float(currentFlashcardCount)/Float(allFlashcardCount)
        }
        if progressBar.progress == 1 {
            uiView.animateProgressTintColor(view: progressBar, color: UIColor(named: progressBarProgressTintColor)!)
        }
    }
    
    func getFrontText(_ label: UILabel, underline: Bool = false) -> NSMutableAttributedString {
        var attributedText = label.createAttributedText(text: (flashcardBrain.getCurrentFlashcard()!.value(forKey: "source") as? String)!, textSize: 28, alignment: .center)
        if underline {
            attributedText = label.underlineAttributedText(attributedText, color: flashcardViewTextColor)
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
