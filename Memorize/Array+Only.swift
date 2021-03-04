//
//  Array+Only.swift
//  Memorize
//
//  Created by Rambo on 2021/3/4.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
