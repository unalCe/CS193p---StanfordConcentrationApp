//
//  ViewController.swift
//  StanfordConcentrationApp
//
//  Created by Unal Celik on 11.03.2019.
//  Copyright © 2019 King Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count + 1) / 2
        }
    }
    
    var themeAsEnum: EmojiTheme? {
        didSet {
            randomTheme = themeAsEnum?.rawValue ?? "DANGERSTOP"
        }
    }
    
    var cardBackgroundColor: UIColor?
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet weak var gamePointLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("The card you've tried to flip is not found.")
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        game.resetGame()
        emojiTheme = [:]
        themeAsEnum = game.randomTheme
        setThemeBackground(for: themeAsEnum ?? game.randomTheme)
        updateViewFromModel()
    }
    
    // MARK: - View Controller
    override func viewDidLoad() {
        themeAsEnum = game.randomTheme
        setThemeBackground(for: themeAsEnum ?? game.randomTheme)
        updateViewFromModel()
    }
    
    private func setThemeBackground(for theme: EmojiTheme) {
        switch theme {
        case .halloween:
            view.backgroundColor = .black
            gamePointLabel.textColor = .orange
            flipCountLabel.textColor = .orange
            cardBackgroundColor = .orange
            newGameButton.setTitleColor(.orange, for: .normal)
        case .faces:
            view.backgroundColor = .white
            gamePointLabel.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            cardBackgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            newGameButton.setTitleColor(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), for: .normal)
        case .animals:
            view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            gamePointLabel.textColor = .black
            flipCountLabel.textColor = .black
            cardBackgroundColor = .black
            newGameButton.setTitleColor(.black, for: .normal)
        case .sports:
            view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            gamePointLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            cardBackgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            newGameButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : cardBackgroundColor ?? .black
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        updateFlipCountLabel()
        
        gamePointLabel.text = "Points: \(game.gamePoint)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackgroundColor
                button.isEnabled = card.isMatched ? false : true
            }
        }
    }
    
    // MARK: - Handle Emoji Selection
    private var emojiTheme = [Card: String]()
    var randomTheme: String = ""
    
    private func emoji(for card: Card) -> String {
        if emojiTheme[card] == nil, randomTheme.count > 0 {
            
            let randomStringIndex = randomTheme.index(randomTheme.startIndex, offsetBy: randomTheme.count.arc4random)
            emojiTheme[card] = String(randomTheme.remove(at: randomStringIndex))
        }
        return emojiTheme[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
