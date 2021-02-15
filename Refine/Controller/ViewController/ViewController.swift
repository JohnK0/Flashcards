//
//  ViewController.swift
//  Flashcards
//
//  Created by John Kim on 11/20/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
//  IIBOutlets
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var flashcardView: UITextView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var retainedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var flashcardControl: UIPageControl!
//  instances
    var flashcardBrain = FlashcardBrain()
    let uiView = UIView()
//  colors
    let flashcardViewTextColor = "BodyTextColor"
    let flashcardViewBackgroundColor = "BackgroundColor"
    let flashcardViewMemorizingBackgroundColor = "LabelBackgroundBoldedColor"
    let topButtonColor = "TopButtonColor"
    let progressBarProgressTintColor = "ProgressBarTintColor"
//  flashcardView
    let headerTextSize = 28
    let bodyTextSize = 17
    let bodySpacing = 5
    var currSide: Bool = false  // false: front true: back
    var defaultSide: Bool = false  // false: front true: back
    var flag: Bool = false
    var full: Bool = false
//  page control
    var currentPage = 0
//  memorize time
    weak var memorizeHoldToCancelTimer: Timer?
    weak var memorizeHoldTimer: Timer?
    let memorizeHoldToCancelDuration = 1.5
//  seque variables
    var managedContext: NSManagedObjectContext?
    
    
    /*
     Sets tintColor of redo and add buttons to topButtonColor
     Rounds flashcardView's corner
     Sets up flashcardView's gesture recognizers
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        redoButton.tintColor = UIColor(named: topButtonColor)
        addButton.tintColor = UIColor(named: topButtonColor)
        removeButton.tintColor = UIColor(named: topButtonColor)
//        retainedButton.tintColor = UIColor(named: topButtonColor)
//        nextButton.tintColor = UIColor(named: topButtonColor)
        flashcardView.layer.cornerRadius = 10
        flashcardView.clipsToBounds = true
        setUpGestureRecognizers()
    }
    
    
    /*
     Centers flashcardView's text at view controller's activation
     */
    override func viewDidLayoutSubviews() {
        flashcardView.centerVertically()
    }
    
    /*
     Sets up flashcards at return to view controller
     */
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Flashcard")
        do {
            flashcardBrain.setFlashcards(try managedContext!.fetch(fetchRequest))
            resetFlashcardControl()
            updateFlashcardView()
//            updateProgressBar()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /*
     Initializes and adds gesture recognizers to flashcardView
     */
    func setUpGestureRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(heldToMemorize))
        longPressRecognizer.minimumPressDuration = 0.35
        flashcardView.addGestureRecognizer(longPressRecognizer)
        let downRecognizer = createDirectionFunction(selector: #selector(makeFull), direction: .up)
        flashcardView.addGestureRecognizer(downRecognizer)
        let upRecognizer = createDirectionFunction(selector: #selector(makeHalf), direction: .down)
        flashcardView.addGestureRecognizer(upRecognizer)
        let leftRecognizer = createDirectionFunction(selector: #selector(SwipeToNextFlashcard), direction: .left)
        flashcardView.addGestureRecognizer(leftRecognizer)
        let rightRecognizer = createDirectionFunction(selector: #selector(swipeToPreviousFlashcard), direction: .right)
        flashcardView.addGestureRecognizer(rightRecognizer)
        let tap = UITapGestureRecognizer(target: self, action: #selector(flip))
        flashcardView.addGestureRecognizer(tap)
    }
    
    /*
     Activates haptic feedback based on variable i
     parameters:
        i: Int
     */
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
    
    /*
     Flashcard control pressed
     */
    @IBAction func flashcardControlPressed(_ sender: UIPageControl) {
        let diff = sender.currentPage-currentPage
        if diff ==  0{
            return
        }
        
        let action: () -> Void
        if diff < 0 {
            action = previousFlashcard
        } else {
            action = nextFlashcard
        }
        for _ in 1...abs(diff) {
            action()
        }
        currentPage = sender.currentPage
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
         
    }
    /*
     Action button pressed
     */
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
                SwipeToNextFlashcard()
            }
        }
    }
    
    /*
     Add button pressed
     */
    @IBAction func addButtonPressed(_ sender: UIButton) {
        hapticFeedback(2)
         self.performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    /*
     Redo button pressed
     */
    func redoButtonPressed() {
        flashcardBrain.setupFlashcards()
        resetFlashcardControl()
        updateFlashcardView(flip: false)
//        updateProgressBar()

    }
    
    /*
     Removes current flashcard from linked list
     Removes a flashcard control node
     Updates flashcardView
     Updates progress Bar
     */
    func memorizedFlashcard() {
        flashcardBrain.memorizedFlashcard()
        removeFlashcardControlPage()
        updateFlashcardView(flip: false)
//        updateProgressBar()
    }
    
    
    /*
     Segue to other view controllers
     */
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        let s = seque
        if s.identifier == "goToCreate" {
            let destinationVC = seque.destination as! CreateFlashcardController
            destinationVC.flashcardBrain = flashcardBrain
            destinationVC.managedContext = managedContext
        }
    }
    
}
