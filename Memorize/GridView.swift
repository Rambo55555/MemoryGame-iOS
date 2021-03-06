//
//  GridView.swift
//  Memorize
//
//  Created by Rambo on 2021/2/16.
//

import SwiftUI

struct GridView<Item, ItemView>: View where Item: Identifiable, ItemView: View{
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    //@escaping,逃逸闭包
    init(_ item: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = item
        self.viewForItem = viewForItem
    }
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
    
}



