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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth).foregroundColor(.orange)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill(Color.orange)
                    }
                }
            }
            .font(Font.system(size: fontSize(for: geometry.size)))
        }
        
    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.75
    
    private func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
    }
}
