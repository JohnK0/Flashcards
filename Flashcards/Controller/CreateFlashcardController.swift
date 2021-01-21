//
//  CreateFlashcardController.swift
//  Flashcards
//
//  Created by John Kim on 1/20/21.
//

import UIKit

class CreateFlashcardController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var flashcardBrain:FlashcardBrain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
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
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard !(textView.text == nil && sourceField.text == nil) else {
            return
        }
        self.addFlashcard()
        self.performSegue(withIdentifier: "goToMain", sender: self)
    }
//    
    func addFlashcard() {
        let text = textView.text!
        let source = sourceField.text!
        if text != "" && source != "" {
            print("Hi")
            flashcardBrain!.addFlashcard(text: text, source: source)
        }
    }
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        if seque.identifier == "goToMain" {
            let destinationVC = seque.destination as! ViewController
            destinationVC.flashcardBrain = flashcardBrain!
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
