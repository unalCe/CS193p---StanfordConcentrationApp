//
//  Card.swift
//  StanfordConcentrationApp
//
//  Created by Unal Celik on 11.03.2019.
//  Copyright © 2019 King Co. All rights reserved.
//

import Foundation

/// Card struct. Adopts Hashable protocol to be able to be a dictionary key.
struct Card: Hashable
{
    /// The hashvalue of the card
    var hashValue: Int { return identifier }
    
    
    /// Conforming the Equatable protocol.
    /// Which also allows us to describe what "equal" means for the struct instances. Returns true if both parameter's identifiers are equal.
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    /// Properties
    var isFaceUp = false
    var isMatched = false
    var isSeen = false
    private var identifier: Int
    
    private static var identifierCount = 0
    
    private static func getUniqueIdentifier() -> Int{
        identifierCount += 1
        return identifierCount
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
