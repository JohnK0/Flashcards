//
//  UILabel.swift
//  Flashcards
//
//  Created by John Kim on 1/23/21.
//

import Foundation
import UIKit

extension UILabel {

    func setLineSpacing(attributedText: NSMutableAttributedString, lineSpacing: CGFloat = 0.0) -> NSMutableAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        // Line spacing attribute
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))

       return attributedText
    }
//    0: left, 1: center, 2: right, 3: justified, default: natural
    func setAlignment(attributedText: NSMutableAttributedString, alignment: Int = 4) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        switch alignment {
        case 0:
            paragraphStyle.alignment = .left
        case 1:
            paragraphStyle.alignment = .center
        case 2:
            paragraphStyle.alignment = .right
        case 3:
            paragraphStyle.alignment = .justified
        default:
            paragraphStyle.alignment = .natural
        }
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))

       return attributedText
    }
}
