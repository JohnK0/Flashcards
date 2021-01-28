//
//  UILabel.swift
//  Flashcards
//
//  Created by John Kim on 1/23/21.
//

import Foundation
import UIKit

extension UILabel {

    func setLineSpacing(_ paragraphStyle: NSMutableParagraphStyle, attributedText: NSMutableAttributedString, lineSpacing: CGFloat = 0.0){
        paragraphStyle.lineSpacing = lineSpacing
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
    }
    
    func setAlignment(_ paragraphStyle: NSMutableParagraphStyle, attributedText: NSMutableAttributedString, alignment: NSTextAlignment = .left) {
        paragraphStyle.alignment = alignment
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
    }
    
    func underlineAttributedText(_ attributedText: NSMutableAttributedString, color: String = "BodyTextColor") -> NSMutableAttributedString {
        attributedText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor(named: color)!], range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
    
    func createAttributedText(text: String, font: String = "Lora-Regular", textSize: Int = 17, alignment: NSTextAlignment = .left, spacing: Int = 0, textColor: String = "BodyTextColor", underline: Bool = false, underlineColor: String = "BodyTextColor") -> NSMutableAttributedString {
        
        var attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: font, size: CGFloat(textSize))!, NSAttributedString.Key.foregroundColor: UIColor(named: textColor)!])
        let paragraphStyle = NSMutableParagraphStyle()
        setAlignment(paragraphStyle, attributedText: attributedText, alignment: alignment)
        setLineSpacing(paragraphStyle, attributedText: attributedText, lineSpacing: CGFloat(spacing))
        if underline {
            attributedText = underlineAttributedText(attributedText)
        }
        return attributedText
    }
}
