//
//  setCell.swift
//  Refine
///Users/john/App Dev/Flashcards/Refine/Controller/HomeController/SetCell.swift
//  Created by John Kim on 3/25/21.
//

import UIKit

class SetCell: UITableViewCell {

    @IBOutlet weak var setLabel: UILabel!
    let setBodyTxtColor = "BodyTextColor"
    let setBackgroundColor = "LabelBackgroundBoldedColor"
    
    func setTextLabel(text: String) {
        setLabel.text = text
        setLabel.textColor = UIColor(named: setBodyTxtColor)
    }
}


