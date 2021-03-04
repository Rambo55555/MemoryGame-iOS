//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
        get { return cards.indices.filter { cards[$0].isFaceUp }.only }
    }
    
    mutating func choose(card: Card) {
        print("card choosen \(card)")
        if let choosedIndex = cards.firstIndex(matching: card), !cards[choosedIndex].isFaceUp, !cards[choosedIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[choosedIndex].content == cards[potentialMatchIndex].content {
                    cards[choosedIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[choosedIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = choosedIndex
            }
            
        }

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
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        
        mutating func changeFace() -> Void {
            self.isFaceUp = !self.isFaceUp
        }
        
    }
}
