//
//  ContentView.swift
//  Memorize
//
//  Created by Rambo on 2021/2/2.
//

import SwiftUI

struct ContentView: View {
    //被观察的对象，订阅一个可观察对象，并在可观察对象发生变化时使视图失效。
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        
        VStack {
            GridView(viewModel.cards) { card in
                CardView(card: card)
                .onTapGesture {
                    withAnimation(.linear){
                        viewModel.choose(card: card)
                    }
                    
                }
                .padding(5)
            }
            .foregroundColor(.blue)
            Button(
                action: {
                    withAnimation(.easeInOut) {
                        viewModel.resetGame()
                    }
                },
                label: { Text("New Game") }
            )
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
    //通过使用@State，我们可以在未使用mutating的情况下修改结构中的值
    //当状态值发生变化后，视图会自动重绘以反应状态的变化。
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        //指定动画时间为几秒
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                                .onAppear() {
                                    startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(-90), endAngle: Angle.degrees(card.bonusRemaining*360-90), clockwise: true)
                        }
                    }
                    .padding(circlePadding).opacity(circleOpacity)
                    .transition(.scale)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
                }
                //.modifier(Cardify(isFaceUp: card.isFaceUp))
                .cardify(isFaceUp: card.isFaceUp)
                .transition(.scale)
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
