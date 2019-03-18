//
//  Concentration.swift
//  StanfordConcentrationApp
//
//  Created by Unal Celik on 11.03.2019.
//  Copyright © 2019 King Co. All rights reserved.
//

import Foundation

/// Theme options for the game.
enum EmojiTheme: String, CaseIterable {
    case halloween = "👻🎃💀🦇🕷🕸⚰️🧟‍♂️🧛🏼‍♂️"
    case sports = "⚽️🏀🎾🎱🏈🏓🏋🏻‍♀️🤼‍♂️🤺🏄🏻‍♂️🏊🏼‍♀️🏹"
    case faces = "😄😂😌😉🤪😘😎😫😱🤥🤮"
    case animals = "🐶🐭🦊🐻🦁🐺🐴🦆🐝🦍🐇🐫"
}

/// The class which stores game logic.
class Concentration
{
    /// The cards array which the game will be played on.
    private(set) var cards = [Card]()
    
    /// The count of flips made.
    private(set) var flipCount: Int = 0
    
    /// The game point
    private(set) var gamePoint = 0
    
    /// The random theme selected from the EmojiThemes
    var randomTheme: EmojiTheme {
        get {
            return EmojiTheme.allCases.randomElement() ?? EmojiTheme.halloween
        }
    }
    
    /// The index of only face up card
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set(newValue) {
            for qundex in cards.indices {
                cards[qundex].isFaceUp = (qundex == newValue)       // yeni değişkenin adı default olarak newValue.
            }
        }
    }
    
    /// The array that holds cards which are seen before
    private var seenCards: [Int: Card] {
        var seen = [Int: Card]()
        for index in cards.indices {
            if cards[index].isSeen {
                seen[index] = cards[index]
            }
        }
        return seen
    }
    
    /**
     Check if other pair seen before
     
     - parameter index: Card index in cards array
     
     - returns: Bool
     */
    private func otherPairSeenBefore(for index: Int) -> Bool {
        return seenCards.contains { $1 == cards[index] && $0 != index }
    }
    
    /**
     Handle card selection
     
     - parameter index: index of the selected card in cards array
     
     - returns: none
     */
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): The cards array does not contains given index.")
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard {
                // Exit the statement if the card is already selected
                if matchIndex == index {
                    return
                }
                
                // Check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    gamePoint += 2
                } else {
                    if otherPairSeenBefore(for: matchIndex) {
                        gamePoint -= 1
                    }
                    if cards[index].isSeen {
                        gamePoint -= 1
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isSeen = true
            flipCount += 1
        }
    }
    
    /**
     Resets the game logic by simply readjusting game variables to zero.
     
     - returns: none
     */
    func resetGame() {
        flipCount = 0
        gamePoint = 0
        
        cards = cards.indices.map {cards[$0].isFaceUp = false; cards[$0].isMatched = false; cards[$0].isSeen = false; return cards[$0] }
        
        cards.shuffle()
    }
    
    /**
     Initializer of the Concentration Class.
     Fills the cards array with desired amount of pairs and shuffles the deck.
     
     - parameter numberOfPairsOfCards: Number of pairs
     */
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): You must have at least one pair of cards.")
        
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    /// Returns the element in an array if it is the only element in array
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
