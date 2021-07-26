//
//  Collection+.swift
//  Concentration
//
//  Created by 이재은 on 2021/07/27.
//

import Foundation

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
