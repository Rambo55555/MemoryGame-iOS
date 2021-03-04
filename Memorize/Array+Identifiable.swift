//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Rambo on 2021/2/17.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for i in 0..<self.count {
            if matching.id == self[i].id {
                return i
            }
        }
        return nil
    }
}
