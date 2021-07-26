//
//  Concentration.swift
//  Concentration
//
//  Created by 이재은 on 2021/07/05.
//

import Foundation

// Model
struct Concentration {
    // MARK: - Property
    private(set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    // MARK: - Initialize
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0,
               "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // TODO: - Shuffle the cards
    }

    // MARK: - Function
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index),
               "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard,
               matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}
