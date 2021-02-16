//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//

import SwiftUI


class EmojiMemoryGame {
    //glass door 其他类可以看到
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🐶", "🐰", "🐷", "🐵"]
        return MemoryGame<String>(numberOfPairsOfCards: 3) { pairIndex in
            return emojis[pairIndex % emojis.count]
        }
    }
        
    
    //MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards;
    }
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func faceUp(card: inout MemoryGame<String>.Card) {
        model.faceUp(card: &card)
    }
    
}
