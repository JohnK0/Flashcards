//
//  ViewController.swift
//  Flashcards
//
//  Created by John Kim on 11/20/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var flashcardLabel: UILabel!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var retainedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var flashcardControl: UIPageControl!
    

    var flashcardBrain = FlashcardBrain()
    var managedContext: NSManagedObjectContext?
    var flag: Bool = false
    var full: Bool = false
    // false: front true: back
    var currSide: Bool = false
    // false: front true: back
    var defaultSide: Bool = false
    weak var memorizeHoldToCancelTimer: Timer?
    weak var memorizeHoldTimer: Timer?
    let memorizeHoldToCancelDuration = 3
    let memorizeHoldDuration = 2
    
    let headerTextSize = 28
    let bodyTextSize = 17
    let bodySpacing = 5
    let topButtonColor = "TopButtonColor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redoButton.tintColor = UIColor(named: topButtonColor)
        addButton.tintColor = UIColor(named: topButtonColor)
//        retainedButton.tintColor = UIColor(named: topButtonColor)
//        nextButton.tintColor = UIColor(named: topButtonColor)
        
        setUpGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Flashcard")
        do {
            flashcardBrain.setFlashcards(try managedContext!.fetch(fetchRequest))
            resetFlashcardControl()
            updateFlashcardLabel()
            updateProgressBar()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setUpGestureRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(heldToMemorize))
        longPressRecognizer.minimumPressDuration = 0.35
        flashcardLabel.addGestureRecognizer(longPressRecognizer)
        let downRecognizer = createDirectionFunction(selector: #selector(makeFull), direction: .up)
        flashcardLabel.addGestureRecognizer(downRecognizer)
        let upRecognizer = createDirectionFunction(selector: #selector(makeHalf), direction: .down)
        flashcardLabel.addGestureRecognizer(upRecognizer)
        let leftRecognizer = createDirectionFunction(selector: #selector(nextFlashcard), direction: .left)
        flashcardLabel.addGestureRecognizer(leftRecognizer)
        let rightRecognizer = createDirectionFunction(selector: #selector(lastFlashcard), direction: .right)
        flashcardLabel.addGestureRecognizer(rightRecognizer)
        let tap = UITapGestureRecognizer(target: self, action: #selector(flip))
        flashcardLabel.addGestureRecognizer(tap)
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
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case 4:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        
        default:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        hapticFeedback(2)
        if flashcardBrain.getAllFlashcardCount() != 0 && sender == redoButton {
            redoButtonPressed()
        }
        if !flashcardBrain.noCurrentFlashcardsLeft() {
            if sender == retainedButton {
                memorizedFlashcard()
            }
            if sender == nextButton {
                nextFlashcard()
            }
        }
    }
    
    func redoButtonPressed() {
        flashcardBrain.setupFlashcards()
        resetFlashcardControl()
        updateFlashcardLabel(flip: false)
        updateProgressBar()

    }
    
    func memorizedFlashcard() {
        flashcardBrain.memorizedFlashcard()
        removeFlashcardControlPage()
        updateFlashcardLabel(flip: false)
        updateProgressBar()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        hapticFeedback(2
        )
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
