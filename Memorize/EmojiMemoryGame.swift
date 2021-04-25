//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    //glass door 其他类可以看到，@Published 可以方便地为任何属性生成其对应类型的发布者。这个发布者会在属性值发生变化时发送消息。
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        //let emojis: Array<String> = ["🐶", "🐰", "🐷", "🐵", "🐤", "🐝", "🦋", "🐜"]
        let emojis: Array<String> = ["🐶", "🐰", "🐷", "🐵", "🐤", "🐝",]
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

    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
}
