//
//  CreateFlashcardController.swift
//  Flashcards
//
//  Created by John Kim on 1/20/21.
//

import UIKit
import CoreData

class CreateFlashcardController: UIViewController {
//  IBOutlets
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var headerField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var body: UILabel!
//  instances
    var flashcardBrain:FlashcardBrain?
//  seque variables
    var managedContext: NSManagedObjectContext?
//  colors
    let flashcardViewTextColor = "BodyTextColor"
    let flashcardViewBackgroundColor = "BackgroundColor"
    let flashcardViewMemorizingBackgroundColor = "LabelBackgroundBoldedColor"
    let topButtonColor = "TopButtonColor"
    let progressBarProgressTintColor = "ProgressBarTintColor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInterface()
        initializeGestureRecognizers()
    }
    
    func setInterface() {
        let label = UILabel()
        var headerText: NSMutableAttributedString = NSMutableAttributedString(string: header.text!)
        headerText = label.underlineAttributedText(headerText)
        header.attributedText = headerText
        var bodyText: NSMutableAttributedString = NSMutableAttributedString(string: body.text!)
        bodyText = label.underlineAttributedText(bodyText)
        body.attributedText = bodyText
        
        bodyView.layer.borderWidth = 0.1
        bodyView.layer.borderColor = UIColor(named: flashcardViewTextColor)?.cgColor
        bodyView.layer.cornerRadius = 5.0
//        bodyView.text = bodyPlaceholder
//        bodyView.textColor = UIColor.lightGray
        bodyView.backgroundColor = UIColor(named: flashcardViewBackgroundColor)
        createButton.tintColor = UIColor(named: topButtonColor)
        createButton.setTitleColor(UIColor(named: topButtonColor), for: UIControl.State.normal)
    }
    
    
    func initializeGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func save(_ body: String, _ source: String, _ memorized: Bool = false) {
        let entity = NSEntityDescription.entity(forEntityName: "Flashcard", in: managedContext!)!
        let flashcard = NSManagedObject(entity: entity, insertInto: managedContext!)
        flashcard.setValue(body, forKeyPath: "body")
        flashcard.setValue(source, forKeyPath: "source")
        flashcard.setValue(memorized, forKeyPath: "memorized")
        
        do {
            try managedContext!.save()
            if let presenter = presentingViewController as? ViewController {
                presenter.flashcardBrain.addFlashcard(flashcard)
                presenter.updateFlashcardView()
                presenter.updateProgressBar()
            }
            
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard !(bodyView.text == nil && headerField.text == nil) else {
            return
        }
        self.addFlashcard()
        self.dismiss(animated: true, completion: nil)
    }
//    
    func addFlashcard() {
        let body = bodyView.text!
        let source = headerField.text!
        if body != "" && source != "" {
            save(body, source)
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
