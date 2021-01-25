//
//  CreateFlashcardController.swift
//  Flashcards
//
//  Created by John Kim on 1/20/21.
//

import UIKit
import CoreData

class CreateFlashcardController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var flashcardBrain:FlashcardBrain?
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor : UIColor = .darkGray
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.cornerRadius = 5.0
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateFlashcardController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
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
                presenter.updateFlashcardLabel()
                presenter.updateProgressBar()
            }
            
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard !(textView.text == nil && sourceField.text == nil) else {
            return
        }
        self.addFlashcard()
        self.dismiss(animated: true, completion: nil)
    }
//    
    func addFlashcard() {
        let body = textView.text!
        let source = sourceField.text!
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
