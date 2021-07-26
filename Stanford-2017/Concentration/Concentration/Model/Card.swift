//
//  Card.swift
//  Concentration
//
//  Created by 이재은 on 2021/07/05.
//

import Foundation

// Model
struct Card: Hashable {
    // MARK: - Property

    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    private static var identifierFactory = 0

    // MARK: - Initialize
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }

    // MARK: - Function
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1 // 정적 메소드 안에서는 정적 변수에 바로 접근 가능함
        return identifierFactory
    }
}
