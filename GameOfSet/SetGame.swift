//
//  SetGame.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 11/29/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import Foundation

class SetGame {
    var cards = [Card]()
    var dealCards = [Card]()
    var currentDealCardNumber = 0
    
    init() {
        // Add 81 cards in the deck
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        cards.append(Card(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    // Public function
    func dealCard(total numberOfDealCard: Int) {
        currentDealCardNumber = numberOfDealCard
        for _ in 0..<numberOfDealCard {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            dealCards.append(cards.remove(at: randomIndex))
        }
    }
}

extension String {
    func multiply(by numberOfRepeats: Int) -> String {
        var newString = ""
        for _ in 0...numberOfRepeats {
            newString += self
        }
        return newString
    }
}
