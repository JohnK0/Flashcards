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
    var managedContext: NSManagedObjectContext?
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redoButton.tintColor = UIColor(named: "TopButtonColor")
        addButton.tintColor = UIColor(named: "TopButtonColor")
        retainedButton.tintColor = UIColor(named: "TopButtonColor")
        nextButton.tintColor = UIColor(named: "TopButtonColor")
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
            recognizer.direction = .left
            self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func bottonButtonTapped(_ i: Int) {
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
    
    @objc func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "goToFlashcardList", sender: self)
         
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
                flag = true
            }
            updateFlashcard()
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
        flashcardBrain.setupFlashcards()
        updateFlashcard()
        updateProgressBar()

    }
    
    func memorizedButtonPressed() {
        bottonButtonTapped(1)
        flashcardBrain.memorizedFlashcard()
        updateFlashcard()
    }
    
    func nextButtonPressed() {
        bottonButtonTapped(1)
        flashcardBrain.rotate()
        updateFlashcard()
    }
    
    func updateFlashcard() {
        if !flashcardBrain.noCurrentFlashcardsLeft() {
            let flashcard = flashcardBrain.getCurrentFlashcard()
            updateFlashcardLabel((flashcard.value(forKeyPath: "body") as? String)!, (flashcard.value(forKeyPath: "source") as? String)!)
        } else {
            updateFlashcardLabel()
        }
        
    }
    
    func updateFlashcardLabel(_ body: String = "Redo?", _ source: String = "John Kim") {
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardLabel.text = "To add a flashcard, press the add button on the top right."
        }
        let source = source
        
        let attributedText = NSMutableAttributedString(string: source, attributes: [NSAttributedString.Key.font: UIFont(name: "Lora-Regular", size: 28)!])
        attributedText.append(NSMutableAttributedString(string: "\n\n"))
        attributedText.append(NSMutableAttributedString(string: body, attributes: [NSAttributedString.Key.font: UIFont(name: "Lora-Regular", size: 17)!]))
        
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
    
    @IBAction func createFlashcardButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCreate", sender: self)
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
