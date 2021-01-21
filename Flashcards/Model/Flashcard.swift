//
//  Flashcard.swift
//  Flashcards
//
//  Created by John Kim on 11/24/20.
//

import Foundation

struct Flashcard {
    let text: String
    let source: String
    var memorized: Bool = false
    
    init(text userText: String, source userSource: String) {
        text = userText
        source = userSource
    }
}
