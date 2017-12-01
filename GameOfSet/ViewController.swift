//
//  ViewController.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 11/29/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var setGame = SetGame()
    lazy var allAvailableCardPosition = Array(0..<cardButtons.count)
    let colorPair = [Card.Color.one:#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), .two:#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), .three:#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
    let symbolPair = [Card.Symbol.one:"▲", .two:"●", .three:"■"]
    var cardPosition = [Int:Int]() // [cardButtonIndex:cardUniqueID]
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCard(_ sender: UIButton) {
        if let buttonIndex = cardButtons.index(of: sender), let cardID = cardPosition[buttonIndex] {
            setGame.selectCard(id: cardID)
            updateViewFromModel()
        } else {
            print("(1)This button is not in cardButtons or (2)No card at this button")
        }
    }
    @IBAction func dealThreeMoreCard(_ sender: UIButton) {
        setGame.dealCard(total: allAvailableCardPosition.count < 3 ? allAvailableCardPosition.count : 3)
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Deal 12 cards at game start
        setGame.dealCard(total: 12)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // Display deal card & hide the rest
        if setGame.currentDealCardNumber > 0 {
            // -- Make card visible on selected random positions
            for dealCardIndex in 0..<setGame.currentDealCardNumber {
                let randomCardButtonIndex = allAvailableCardPosition.remove(at: Int(arc4random_uniform(UInt32(allAvailableCardPosition.count))))
                drawCard(on: cardButtons[randomCardButtonIndex], dealCardIndex: setGame.dealCards.count - dealCardIndex - 1)
            }
            // -- Make card invisible on the rest of cardButtons positions
            for positionIndex in allAvailableCardPosition {
                cardButtons[positionIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardButtons[positionIndex].setTitle("", for: .normal)
                cardButtons[positionIndex].isEnabled = false
            }
            setGame.currentDealCardNumber = 0
        }
        // Select & Deselect cards
        for cardButtonIndex in cardButtons.indices {
            if let cardID = cardPosition[cardButtonIndex] {
                cardButtons[cardButtonIndex].layer.borderWidth = 0.0
                if setGame.selectedCards[cardID] != nil {
                    if setGame.selectedCards[cardID] == .undecided { // deciding
                        cardButtons[cardButtonIndex].layer.borderWidth = 5.0
                        cardButtons[cardButtonIndex].layer.borderColor = UIColor.green.cgColor
                    } else if setGame.selectedCards[cardID] == .matched { // already matched
                        cardButtons[cardButtonIndex].layer.borderWidth = 0.0
                        cardButtons[cardButtonIndex].backgroundColor = UIColor.yellow
                        cardButtons[cardButtonIndex].isEnabled = false
                    } else { // not matched
                        cardButtons[cardButtonIndex].layer.borderWidth = 5.0
                        cardButtons[cardButtonIndex].layer.borderColor = UIColor.red.cgColor
                    }
                } else { // Remove all special effects
                    cardButtons[cardButtonIndex].layer.borderWidth = 0.0
                    cardButtons[cardButtonIndex].backgroundColor = UIColor.white
                }
            }
        }
    }
    
    private func drawCard(on cardToDrawOn: UIButton, dealCardIndex associatedDealCardIndex: Int) {
        cardPosition[cardButtons.index(of: cardToDrawOn)!] = setGame.dealCards[associatedDealCardIndex].uniqueID
        let shadingOnCard = setGame.dealCards[associatedDealCardIndex].shading
        let titleColor = colorPair[setGame.dealCards[associatedDealCardIndex].color]!
        let titleContent = symbolPair[setGame.dealCards[associatedDealCardIndex].symbol]!.multiply(by: setGame.dealCards[associatedDealCardIndex].number.rawValue)
        cardToDrawOn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cardToDrawOn.isEnabled = true
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor : titleColor.withAlphaComponent(shadingOnCard == .two ? CGFloat(0.40) : CGFloat(1)),
            .strokeWidth : shadingOnCard == .three ? 15 : -1
        ]
        
        let attribtext = NSAttributedString(string: titleContent, attributes: attributes)
        cardToDrawOn.setAttributedTitle(attribtext, for: .normal)
    }
}
