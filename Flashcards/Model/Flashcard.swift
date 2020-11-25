//
//  Flashcard.swift
//  Flashcards
//
//  Created by John Kim on 11/24/20.
//

import Foundation

struct Flashcard {
    let text: String
    var memorized: Bool = false
    
    init(text userText: String) {
        text = userText
    }
}
