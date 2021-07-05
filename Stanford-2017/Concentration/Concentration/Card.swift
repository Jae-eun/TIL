//
//  Card.swift
//  Concentration
//
//  Created by 이재은 on 2021/07/05.
//

import Foundation

// Model
struct Card {
    // MARK: - Property
    var isFaceUp = false
    var isMatched = false
    var identifier: Int

    // MARK: - Static
    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1 // 정적 메소드 안에서는 정적 변수에 바로 접근 가능함
        return identifierFactory
    }

    // MARK: - Initialize
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
