//
//  CardViewController.swift
//  Concentration
//
//  Created by 이재은 on 2021/06/25.
//

import UIKit

final class CardViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!

    // MARK: - Property
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    private var emojiChoices = "🎃👻☠️🙀😱🍬🍭🦇💀😈"
    private var emoji = [Card: String]()

    // MARK: - IBAction
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }

    // MARK: - Function
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            }
        }
    }

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil,
           emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4random
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex,
                                                       offsetBy: randomIndex)

            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }

    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.orange,
            .strokeWidth: 5.0
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
}
