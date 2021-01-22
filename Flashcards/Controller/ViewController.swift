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
    @IBOutlet weak var retainedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var flashcardBrain = FlashcardBrain()
    var flashcard: Flashcard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retainedButton.layer.cornerRadius = retainedButton.frame.width/2
        retainedButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.layer.masksToBounds = true
        updateFlashcard()
        
        
    }

    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if flashcardBrain.getAllFlashcardCount() != 0 && sender == redoButton {
            redoButtonPressed()
        }
        if !flashcardBrain.noCurrentFlashcardsLeft() {
            if sender == retainedButton {
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
            updateFlashcardLabel(flashcard!.text, flashcard!.source)
        } else {
            updateFlashcardLabel()
        }
        
    }
    
    func updateFlashcardLabel(_ text: String = "Finished!", _ source: String = "") {
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardLabel.text = "To submit a flashcard,\nopen the hidden text box below the progress bar\nand enter in the text.\nThen press the bottom right of the progress bar\n to submit."
        }
        flashcardLabel.text = text+"\n-"+source
    }
    
    func updateProgressBar() {
        let currentFlashcardCount = flashcardBrain.getCurrentFlashcardCount()
        let allFlashcardCount = flashcardBrain.getAllFlashcardCount()
        progressBar.progress = 1.0 - Float(currentFlashcardCount)/Float(allFlashcardCount)
    }
    
    @IBAction func createFlashcardButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCreate", sender: self)
        
    }
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        if seque.identifier == "goToCreate" {
            let destinationVC = seque.destination as! CreateFlashcardController
            destinationVC.flashcardBrain = flashcardBrain
        }
    }
    
}
