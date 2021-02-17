//
//  GridView.swift
//  Memorize
//
//  Created by Rambo on 2021/2/16.
//

import SwiftUI

struct GridView<Item, ItemView>: View where Item: Identifiable, ItemView: View{
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init(_ item: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = item
        self.viewForItem = viewForItem
    }
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
    
    func index(of item: Item) -> Int {
        for i in 0..<items.count {
            if item.id == items[i].id {
                return i
            }
        }
        return 0 // TODO: bogus
    }
}



