//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card) {
        print("card choosen \(card)")
    }
    
    func faceUp(card: inout Card) {
        card.isFaceUp = !card.isFaceUp
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
    }
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        
        mutating func changeFace() -> Void {
            self.isFaceUp = !self.isFaceUp
        }
        
    }
}
