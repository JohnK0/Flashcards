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
    var empty = true
    
    @IBOutlet weak var flashcardLabel: UILabel!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var memorizedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFlashcardsCount()
        total = flashcards.count
        if total > 0 {
            setUpFlashcards()
            empty = false
        }
    }
    
    func setUpFlashcards() {
        tempFlashcards = flashcards
        tempFlashcards.shuffle()
        updateProgressBar()
        updateFlashcardLabel(text: tempFlashcards.first!)
    }
    
    func checkFlashcardsCount() {
        if flashcards.count == 0 {
            flashcardLabel.text = "To submit a flashcard,\n open the hidden text box below the progress bar\nand enter in the text.\nThen press the bottom right of the progress bar\n to submit."
        }
        
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle!)
        if !empty {
            if sender == redoButton {
                redoButtonPressed()
            }
            if !finished {
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
            addNewFlashcard()
        }
    }
    
    func redoButtonPressed() {
        finished = false
        setUpFlashcards()
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
    func nextButtonPressed() {
        let temp = tempFlashcards.first!
        tempFlashcards.removeFirst()
        tempFlashcards.append(temp)
        updateFlashcardLabel(text:tempFlashcards.first!)
    }
    func addNewFlashcard() {
        guard !(textView.text == nil) else {
            return
        }
        let text = textView.text!
        if text != "" {
            if empty == true {
                updateFlashcardLabel(text: textView.text!)
                empty = false
            }
            flashcards.append(text)
            tempFlashcards.append(text)
            total += 1
            updateProgressBar()
            textView.text = ""
        }
    }
    
    func updateFlashcardLabel(text: String = "O̲ppa̲ (っ-̶●̃益●̶̃)っ ,︵‿ S̲t̲yl̲e̲") {
        flashcardLabel.text = text
    }
    
    func updateProgressBar() {
        progressBar.progress = 1.0 - Float(tempFlashcards.count)/Float(total)
    }
}
