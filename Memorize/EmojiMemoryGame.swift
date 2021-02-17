//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    //glass door 其他类可以看到
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🐶", "🐰", "🐷", "🐵", "🐤", "🐝", "🦋", "🐜"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
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
