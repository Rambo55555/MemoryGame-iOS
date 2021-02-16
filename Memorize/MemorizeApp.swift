//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rambo on 2021/2/2.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let game = EmojiMemoryGame()
            ContentView(viewModel: game)
        }
    }
}
