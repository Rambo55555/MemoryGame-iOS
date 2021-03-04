//
//  ContentView.swift
//  Memorize
//
//  Created by Rambo on 2021/2/2.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        GridView(viewModel.cards) { card in
            CardView(card: card)
            .onTapGesture {
                viewModel.choose(card: card)
            }
            .padding(5)
        }
        
 //       GridContentView()
//        GridView(colorViews()) { color in
//            color
//        }
    }
    func colorViews() -> [Color] {
        var contentView = [Color]()
        for _ in 0..<16 {
            contentView.append(Color.random)
        }
        return contentView
    }
}

extension Color: Identifiable {
    public var id: Int {
        return self.hashValue
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: Angle.degrees(-90), endAngle: Angle.degrees(20), clockwise: true)
                        .fill(Color.orange).padding(circlePadding).opacity(circleOpacity)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                }
                //.modifier(Cardify(isFaceUp: card.isFaceUp))
                .cardify(isFaceUp: card.isFaceUp)
            }
            
        }
        
    }
    
    // MARK: - Drawing Constants

    private let fontScaleFactor: CGFloat = 0.7
    private let circlePadding: CGFloat = 5
    private let circleOpacity: Double = 0.4
    
    private func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[2])
        return ContentView(viewModel: game)
    }
}
