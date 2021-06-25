//
//  ViewController.swift
//  Concentration
//
//  Created by 이재은 on 2021/06/25.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!

    // MARK: - Property
    private var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    private var emojiChoices = ["🎃", "👻", "🎃", "👻"]

    // MARK: - IBAction
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        } else {
            print("chosen card was not in cardButtons")
        }
    }

    // MARK: - Function
    private func flipCard(withEmoji emoji: String,
                          on button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        } else {
            button.setTitle(emoji, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}

