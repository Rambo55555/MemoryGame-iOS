//
//  ContentView.swift
//  Memorize
//
//  Created by Rambo on 2021/2/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            ForEach(0..<4) { index in
                CardView(isFaceUp: true)
            }
        }
        .foregroundColor(.blue)
        .padding()
        .font(Font.largeTitle)
    }
}

struct CardView: View {
    var isFaceUp: Bool
    
    var body: some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke().foregroundColor(.orange)
                Text("👻X")
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.orange)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
