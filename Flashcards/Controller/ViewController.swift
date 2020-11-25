//
//  ViewController.swift
//  Flashcards
//
//  Created by John Kim on 11/20/20.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var flashcardLabel: UILabel!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var memorizedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    var flashcardBrain = FlashcardBrain()
    var flashcard: Flashcard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashcard = flashcardBrain.flashcard()
    }
    
    func noFlashcards() -> Bool {
        if flashcardBrain.flashcardCount == 0 {
            return false
        }
        return true
    }
    
    func setUpFlashcards() {
        if noFlashcards() {
            flashcardLabel.text = "To submit a flashcard,\nopen the hidden text box below the progress bar\nand enter in the text.\nThen press the bottom right of the progress bar\n to submit."
        } else {
            flashcardBrain.shuffleFlashcards()
            let flashcard = flashcardBrain.flashcards[flashcardBrain.currentIndex]
            updateFlashcardLabel(flashcard.text)
            updateProgressBar()
        }
        
        
        
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if !noFlashcards() {
            if sender == redoButton {
                redoButtonPressed() // tbf
            }
            if !flashcardBrain.allMemorized() {
                if sender == memorizedButton {
                    memorizedButtonPressed()
                    updateProgressBar()
                }
                if sender == nextButton {
                    nextButtonPressed()
                }
            }
        }
        if sender == submitButton {
            addFlashcard()
        }
    }
    
    func redoButtonPressed() {
        flashcardBrain.finished = false
        setUpFlashcards()
    }
    
    func memorizedButtonPressed() {
        flashcardBrain.memorizedFlashcard()
        if flashcardBrain.memorizedCount < flashcardBrain.flashcardCount {
            flashcardBrain.currentIndex += 1 // Go to next flashcard with memorized: false
            updateFlashcardLabel(flashcard!.text)
        } else {
            flashcardBrain.finished = true
            updateFlashcardLabel()
        }
    }
    
    func nextButtonPressed() {
        flashcardBrain.newIndex()
        flashcard = flashcardBrain.flashcard()
        updateFlashcardLabel(flashcard!.text)
    }
    
    
    
    func addFlashcard() {
        guard !(textView.text == nil) else {
            return
        }
        let text = textView.text!
        if text != "" {
            flashcardBrain.addFlashcard(text)
            if noFlashcards() {
                updateFlashcardLabel(flashcard!.text)
            }
            updateProgressBar()
            textView.text = ""
        }
    }
    
    func updateFlashcardLabel(_ text: String = "O̲ppa̲ (っ-̶●̃益●̶̃)っ ,︵‿ S̲t̲yl̲e̲") {
        flashcardLabel.text = text
    }
    
    func updateProgressBar() {
        let memorized = flashcardBrain.memorizedCount
        let flashcardCount = flashcardBrain.flashcardCount
        progressBar.progress = 1.0 - Float(memorized)/Float(flashcardCount)
    }
    
}
