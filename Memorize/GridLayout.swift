//
//  GridLayout.swift
//  Memorize
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct GridLayout {
    private(set) var size: CGSize
    private(set) var rowCount: Int = 0
    private(set) var columnCount: Int = 0
    
    init(itemCount: Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose aspectRatio
        // has the smallestVariance from desiredAspectRatio
        // not necessarily most optimal code to do this, but easy to follow (hopefully)
        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
        var smallestVariance: Double?
        let sizeAspectRatio = abs(Double(size.width/size.height))
        for rows in 1...itemCount {
            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0)
            if (rows - 1) * columns < itemCount {
                let itemAspectRatio = sizeAspectRatio * (Double(rows)/Double(columns))
                let variance = abs(itemAspectRatio - desiredAspectRatio)
                if smallestVariance == nil || variance < smallestVariance! {
                    smallestVariance = variance
                    bestLayout = (rowCount: rows, columnCount: columns)
                }
            }
        }
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            return CGSize(
                width: size.width / CGFloat(columnCount),
                height: size.height / CGFloat(rowCount)
            )
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height
            )
        }
    }
}

//自己实现的GridView
extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

struct RowView: View {
    var itemPerRow: Int
    var views: [AnyView] = []
    var itemWidth: CGFloat {
        UIScreen.main.bounds.width / CGFloat(itemPerRow)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<views.count) { index in
                views[index]
                    .frame(width: itemWidth, height: itemWidth)
            }
        }
    }
}

struct GridContentView: View {
    var itemPerRow = 4
    var contentView: [AnyView] = []
    
    init() {
        for _ in 0..<16 {
            contentView.append(AnyView(Color.random))
        }
    }
    
    func rowCount() -> Int {
        if contentView.count % itemPerRow == 0 {
            return contentView.count / itemPerRow
        }
        return contentView.count / itemPerRow + 1
    }
    
    func rowViews(rowIndex: Int) -> [AnyView] {
        var views = [AnyView]()
        
        for i in 0..<itemPerRow {
            let index = i + rowIndex * itemPerRow
            if index < contentView.count {
                views.append(contentView[index])
            }
        }
        return views
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<rowCount()) { i in
                RowView(itemPerRow: itemPerRow, views: rowViews(rowIndex: i))
            }
        }
    }
}
