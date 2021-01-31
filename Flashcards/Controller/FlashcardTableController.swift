//
//  FlashcardTableController.swift
//  Flashcards
//
//  Created by John Kim on 1/24/21.
//

import UIKit

class FlashcardTableController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
            recognizer.direction = .right
            self.view.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func swipeRight(recognizer : UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
         
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
