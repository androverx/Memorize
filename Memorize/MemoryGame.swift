//
//  MemoryGame.swift
//  Memorize
//
//  Created by Andrey Mosolov on 12.09.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

// MODEL file //
import Foundation

//define independent from card content Game Backend
struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        //computed properties
        get {
            cards.indices.filter {index in cards[index].isFaceUp}.only
            
            //let faceUpCardIndicies = cards.indices.filter {index in cards[index].isFaceUp}.only
            
            
            /*
            for index in cards.indices {
                if cards[index].isFaceUp {
                    faceUpCardIndicies.append(index)
                }
            }
            
             Make extension
            if faceUpCardIndicies.count == 1 {
                return faceUpCardIndicies.first
            } else {
                return nil
            }*/
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    
    //MARK: initialize game
    init (numberOfPairsOfCards: Int, cardContentFactory: (Int)->CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content,id: pairIndex*2))
            cards.append(Card(content: content,id: pairIndex*2+1))
        }
        
        cards.shuffle()
    }
    
    
    //MARK: register chosen card and flip it
    mutating func Choose (card: Card){
        print("card choosen: \(card)")
        //let chosenIndex: Int = self.index(of: card)
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            //if two cards face up
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                //indexOfOneAndOnlyFaceUpCard = nil
                cards[chosenIndex].isFaceUp = true
            //one card face up
            } else {
                /*
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }*/
                indexOfOneAndOnlyFaceUpCard = chosenIndex
            }
            
            //cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
            //cards[chosenIndex].isFaceUp = true
        }
    }
    
    /* move to Array+Identifiable file
     
    func index (of card: Card) -> Int {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        return 0 //TODO: bogus
    }*/
    
    
    //MARK: single Card description
    struct Card: Identifiable {
        var isFaceUp:Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched:Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        
        
        // MARK: Bonus time
        //give matching bonus points if the user matches the card
        //before certain amount of time passes during which the card is face up

        //no bonus time
        var bonusTimeLimit: TimeInterval = 6

        //how long this card ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        //the last time this card was turned face up (and still face up)
        var lastFaceUpDate: Date?
        
        //the accumulated time this card has been face up in the past
        //i.e. not including the current time it's been face up if it is currently so
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left  before  the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        //percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        //whether the card  was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        //whether  we are currently face up, unmatched and have not  yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusRemaining > 0
        }
        
        //called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        //called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}


