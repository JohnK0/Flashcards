//
//  ViewController.swift
//  Flashcards
//
//  Created by John Kim on 11/20/20.
//

import UIKit
import CoreData


extension UITextView {

   func centerVertically() {
       let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
       let size = sizeThatFits(fittingSize)
       let topOffset = (bounds.size.height - size.height * zoomScale) / 2
       let positiveTopOffset = max(1, topOffset)-10
       contentOffset.y = -positiveTopOffset
   }

}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var flashcardView: UITextView!
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
    var currentPage = 0
    let uiView = UIView()
    let memorizeHoldToCancelDuration = 1.5
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
        flashcardView.layer.cornerRadius = 10
        flashcardView.clipsToBounds = true
        setUpGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        flashcardView.centerVertically()
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
        longPressRecognizer.minimumPressDuration = 0.1
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
        hapticFeedback(2)
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
