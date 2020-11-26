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
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        
        if sender == submitButton {
            addFlashcard()
        }
        if flashcardBrain.getAllFlashcardCount() != 0 && sender == redoButton {
            redoButtonPressed()
        }
        if !flashcardBrain.noCurrentFlashcardsLeft() {
            if sender == memorizedButton {
                memorizedButtonPressed()
                updateProgressBar()
            }
            if sender == nextButton {
                nextButtonPressed()
            }
        }
    }
    
    func redoButtonPressed() {
        flashcardBrain.reset()
        updateFlashcard()
        updateProgressBar()
    }
    
    func memorizedButtonPressed() {
        flashcardBrain.memorizedFlashcard()
        updateFlashcard()
    }
    
    func nextButtonPressed() {
        flashcardBrain.rotate()
        updateFlashcard()
    }
    
    func updateFlashcard() {
        if !flashcardBrain.noCurrentFlashcardsLeft() {
            flashcard = flashcardBrain.flashcard()
            updateFlashcardLabel(flashcard!.text)
        } else {
            updateFlashcardLabel()
        }
        
    }
    
    func addFlashcard() {
        guard !(textView.text == nil) else {
            return
        }
        let text = textView.text!
        if text != "" {
            flashcardBrain.addFlashcard(text)
            if flashcardBrain.noCurrentFlashcardsLeft() {
                updateFlashcard()
            }
            textView.text = ""
            updateProgressBar()
        }
    }
    
    func updateFlashcardLabel(_ text: String = "O̲ppa̲ (っ-̶●̃益●̶̃)っ ,︵‿ S̲t̲yl̲e̲") {
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardLabel.text = "To submit a flashcard,\nopen the hidden text box below the progress bar\nand enter in the text.\nThen press the bottom right of the progress bar\n to submit."
        }
        flashcardLabel.text = text
    }
    
    func updateProgressBar() {
        let currentFlashcardCount = flashcardBrain.getCurrentFlashcardCount()
        let allFlashcardCount = flashcardBrain.getAllFlashcardCount()
        progressBar.progress = 1.0 - Float(currentFlashcardCount)/Float(allFlashcardCount)
    }
    
}
