//
//  MemoryGame.swift
//  Memorize
//
//  Created by Rambo on 2021/2/15.
//
//一个基础包
import Foundation
//CardContent为范型，即卡片的内容，如String类型或图片类型，实现了比较协议
struct MemoryGame<CardContent> where CardContent: Equatable{
    //setter为私有，getter为公有
    private(set) var cards: Array<Card>
    //计算属性，存放唯一朝上的卡片的索引
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        //setter方法，newValue为设置的新值，使得对应下标的卡片朝上
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
        //getter方法，返回唯一朝上的卡片
        get { return cards.indices.filter { cards[$0].isFaceUp }.only }
    }
    //在Swift中，structure和enumeration是值类型(value type)
    //class是引用类型(reference type)。
    //默认情况下，实例方法中是不可以修改值类型的属性，使用mutating后可修改属性的值
    mutating func choose(card: Card) {
        print("card choosen \(card)")
        //如果选中的卡片在卡片数组中有索引，并且不朝上，并且还未匹配
        if let choosedIndex = cards.firstIndex(matching: card), !cards[choosedIndex].isFaceUp, !cards[choosedIndex].isMatched {
            //如果存在已有的朝上的卡片
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                //如果两张卡片内容相同则匹配
                if cards[choosedIndex].content == cards[potentialMatchIndex].content {
                    cards[choosedIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                //不管匹配不匹配，当前卡片都要翻上去
                self.cards[choosedIndex].isFaceUp = true
            } else {
                //不存在已有朝上的卡片，就将唯一朝上卡片索引设置为当前索引，就会调用setter方法使其朝上
                indexOfTheOneAndOnlyFaceUpCard = choosedIndex
            }
            
        }

    }
    //模型初始化代码，传入卡片对个数，以及根据一个整数返回卡片内容的函数作为参数
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            //卡片内容，通过调用工厂模式返回卡片内容
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
        //打乱卡片顺序
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
    //实现Identifiable协议，就可以使用foreach进行遍历
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = false {
            //在调用setter方法之后执行，如果朝上就开始计时，否则停止计时
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            //设值之后就停止计时
            didSet {
                stopUsingBonusTime()
            }
        }
        //卡片内容
        var content: CardContent
        //改变卡片朝向，mutating的原因是struct是值类型，里面不能修改属性，必须用该关键字
        mutating func changeFace() -> Void {
            self.isFaceUp = !self.isFaceUp
        }
        
        // MARK: - Bouns Tims
        // this could give matcing bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        //can be zero which means "no bonus available" for this card
        //剩余时间，以秒为单位
        var bonusTimeLimit: TimeInterval = 6

        //how long this card has ever been face up
        //卡片朝上的时间
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up(and is still face up)
        //最后一次面朝上的时间
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in past
        // (i.e not including the current time it's been face up if it is currently so)
        //过去累积朝上的时间
        var pastFaceUpTime: TimeInterval = 0

        // how much time left befor the bonus opportunity runs out
        //还剩多少时间
        var bonusTimeRemaining: TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        //剩余百分比
        var bonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        //是否赚了积分
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        //是否正在消耗积分时间
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
    
            
}
