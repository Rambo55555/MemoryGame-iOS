//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(card: Card) {
        print("card choosen \(card)")
        let choosedIndex = cards.firstIndex(matching: card)
        self.cards[choosedIndex].isFaceUp = !self.cards[choosedIndex].isFaceUp
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
        cards = MemoryGame.shuffleCards(cards: cards)
    }
    
    static func shuffleCards(cards: Array<Card>) -> Array<Card> {
        var data: Array<Card> = cards
        for i in 1..<cards.count {
            let index:Int = Int(arc4random()) % i
            if index != i {
                data.swapAt(i, index)
            }
        }
        return data
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
