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
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!

    var flashcardBrain = FlashcardBrain()
    var managedContext: NSManagedObjectContext?
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retainedButton.layer.cornerRadius = retainedButton.frame.width/2
        retainedButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.layer.masksToBounds = true
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

    func saveFlashcard(_ body: String, _ source: String, _ memorized: Bool = false) {
        let entity = NSEntityDescription.entity(forEntityName: "Flashcard", in: managedContext!)!
        let flashcard = NSManagedObject(entity: entity, insertInto: managedContext!)
        flashcard.setValue(body, forKeyPath: "body")
        flashcard.setValue(source, forKeyPath: "source")
        flashcard.setValue(memorized, forKeyPath: "memorized")
        
        do {
            try managedContext!.save()
            flashcardBrain.addFlashcard(flashcard)
            updateFlashcard()
            updateProgressBar()
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
        flashcardBrain.memorizedFlashcard()
        updateFlashcard()
    }
    
    func nextButtonPressed() {
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
    
    func updateFlashcardLabel(_ text: String = "Finished!", _ source: String = "") {
        if flashcardBrain.getAllFlashcardCount() == 0 {
            flashcardLabel.text = "To submit a flashcard,\nopen the hidden text box below the progress bar\nand enter in the text.\nThen press the bottom right of the progress bar\n to submit."
        }
        flashcardLabel.text = text+"\n-"+source
    }
    
    func updateProgressBar() {
        let currentFlashcardCount = flashcardBrain.getCurrentFlashcardCount()
        let allFlashcardCount = flashcardBrain.getAllFlashcardCount()
        if currentFlashcardCount == 0 {
            progressBar.progress = 0
        } else {
        progressBar.progress = 1.0 - Float(currentFlashcardCount)/Float(allFlashcardCount)
        }
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
