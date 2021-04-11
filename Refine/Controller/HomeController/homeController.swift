//
//  HomeController.swift
//  Refine
//
//  Created by John Kim on 3/24/21.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var sets:[NSManagedObject]? = []
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let topButtonColor = "TopButtonColor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.tintColor = UIColor(named: topButtonColor)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        super.viewWillAppear(animated)
        do {
            self.sets = try managedContext.fetch(Set.fetchRequest()) as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
//        if sets == nil {
//            print("Empty")
//            sets = ["Add a New Set"]
//        }
    }
    
//    sends user to add set/flashcard page
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
//        make use the flashcard-set relationship
//        do {
//            let set = Set(context: managedContext)
//            set.name = "Nest"
//            let flashcards: [NSManagedObject] = try managedContext.fetch(Flashcard.fetchRequest()) as! [NSManagedObject]
//            for flashcard in flashcards {
//                flashcard.setValue(set, forKey: "set")
//            }
//
//            Save the data
//            do {
//                try  self.managedContext.save()
//            }
//            catch let error as NSError {
//                print("Could not fetch. \(error), \(error.userInfo)")
//            }
//
//            re-fetch data
//            fetchSets()
//        }
//        catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
    
//    fetches sets to update onto the tableview
    func fetchSets() {
        do {
            self.sets = try managedContext.fetch(Set.fetchRequest()) as? [NSManagedObject]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
}

extension HomeController: UITableViewDelegate {
    //    User taps cell
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("tapped cell")
        }
    //    returns number of sections
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
    
        func tableView(_ tableView: UITableView, titleForHeaderInSection
                                    section: Int) -> String? {
           return "Verses"
        }
}

extension HomeController: UITableViewDataSource {
    //    returns number of sets
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return sets!.count
        }
    //    Displays cells
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let set = sets![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as! SetCell

    //        print("\(#function) --- section = \(indexPath.section), row = \(indexPath.row)")

            cell.setTextLabel(text: set.value(forKey: "name") as! String)

            return cell
        }
}

