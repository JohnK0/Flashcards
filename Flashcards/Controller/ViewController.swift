//
//  ViewController.swift
//  Flashcards
//
//  Created by John Kim on 11/20/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var flashcardLabel: UILabel!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var retainedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    

    var flashcardBrain = FlashcardBrain()
    var currFlashcard: NSManagedObject?
    var managedContext: NSManagedObjectContext?
    var flag: Bool = false
    var full: Bool = false
    // false: front true: back
    var currSide: Bool = false
    // false: front true: back
    var defaultSide: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redoButton.tintColor = UIColor(named: "TopButtonColor")
        addButton.tintColor = UIColor(named: "TopButtonColor")
        retainedButton.tintColor = UIColor(named: "TopButtonColor")
        nextButton.tintColor = UIColor(named: "TopButtonColor")
        
        let downRecognizer = createDirectionFunction(selector: #selector(makeFull), direction: .up)
        flashcardLabel.addGestureRecognizer(downRecognizer)
        let upRecognizer = createDirectionFunction(selector: #selector(makeHalf), direction: .down)
        flashcardLabel.addGestureRecognizer(upRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(flip))
        flashcardLabel.addGestureRecognizer(tap)
    }
    
    func createDirectionFunction(selector: Selector, direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer{
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: selector)
        recognizer.direction = direction
        return recognizer
    }
    
    @objc func makeFull(a: Int) {
        full = true
        updateFlashcardLabel()
    }
    
    @objc func makeHalf() {
        full = false
        updateFlashcardLabel(down: true)
    }
    
    @objc func toggleBetweenFrontandBack() {
        defaultSide = !defaultSide
        updateFlashcardLabel()
    }
    
    @objc func flip() {
        if !full {
            updateFlashcardLabel(flip: true)
        }
    }
    
    @objc func hapticFeedback(_ i: Int) {
        switch i {
        case 1:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case 2:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case 3:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        
        default:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Flashcard")
        do {
            flashcardBrain.flashcards = try managedContext!.fetch(fetchRequest)
            print(flashcardBrain.getAllFlashcardCount())
            if !flag {
                flashcardBrain.setupFlashcards()
                currFlashcard = flashcardBrain.getCurrentFlashcard()
                flag = true
            }
            updateFlashcardLabel()
            updateProgressBar()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        hapticFeedback(2)
        flashcardBrain.setupFlashcards()
        updateFlashcardLabel(flip: false)
        updateProgressBar()

    }
    
    func memorizedButtonPressed() {
        hapticFeedback(2)
        flashcardBrain.memorizedFlashcard()
        updateFlashcardLabel(flip: false)
    }
    
    func nextButtonPressed() {
        hapticFeedback(2)
        flashcardBrain.rotate()
        updateFlashcardLabel(flip: false)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        hapticFeedback(2
        )
        self.performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    func getFrontText(_ label: UILabel, underline: Bool = false) -> NSMutableAttributedString {
        var attributedText = label.createAttributedText(text: (currFlashcard!.value(forKey: "source") as? String)!, textSize: 28, alignment: .center)
        if underline {
            attributedText = label.underlineAttributedText(attributedText, color: "BodyTextColor")
        }
        return attributedText
    }
    
    func getBackText(_ label: UILabel) -> NSMutableAttributedString {
        return label.createAttributedText(text: (currFlashcard!.value(forKey: "body") as? String)!, textSize: 17, spacing: 5)
    }

    func updateFlashcardLabel(flip: Bool = false, down: Bool = false) {
        currFlashcard = flashcardBrain.getCurrentFlashcard()
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardLabel.text = "To add a flashcard, press the add button on the top right."
        }
        
        let label = UILabel()
        var attributedText: NSMutableAttributedString
        
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
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        let s = seque
        if s.identifier == "goToCreate" {
            let destinationVC = seque.destination as! CreateFlashcardController
            destinationVC.flashcardBrain = flashcardBrain
            destinationVC.managedContext = managedContext
        }
        else if s.identifier == "goToFlashcardList" {
            let trans = CATransition()
            trans.type = CATransitionType.moveIn
            trans.subtype = CATransitionSubtype.fromLeft
            trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            trans.duration = 0.35
            self.navigationController?.view.layer.add(trans, forKey: nil)
        }
    }
    
}
