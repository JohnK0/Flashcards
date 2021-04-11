//
//  CreateSetController.swift
//  Refine
//
//  Created by John Kim on 4/10/21.
//

import UIKit
import CoreData

class CreateSetController: UIViewController {
    
    @IBOutlet weak var setTextLabel: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let setName = setTextLabel.text
        if setName == nil { return } // create popup to tell user to put a value in the text label
        if !setExists(setName!) {
            // create the set
            let set = Set(context: managedContext!)
            set.name = setTextLabel.text
            
//               save the data
            do {
                try managedContext!.save()
//                 re-fetch the sets in HomeController and update the table
                if let presenter = presentingViewController as? HomeController {
                    presenter.fetchSets()
                }
//                dismiss the view
                self.dismiss(animated: true, completion: nil)
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
//    checks if set exists in CoreData based on its unique name
    func setExists(_ setName: String) -> Bool {
        do {
            let sets = try managedContext!.fetch(Set.fetchRequest()) as? [NSManagedObject]
            if sets != nil {
                for set in sets! {
                    if (set.value(forKey: "name") as! String) == setName { return true }
                }
            }
            else { return true }
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }
}

