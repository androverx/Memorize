//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Andrey Mosolov on 12.09.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

// VIEW-MODEL file
import SwiftUI

//MARK: create a concrete Game
class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    //MARK: create Game with content we prefer. String in this case
    private static func createMemoryGame () -> MemoryGame<String>{
        let emojis: Array<String>  = ["🦉","🐥","🦆"]
        
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) {pairIndex in
            return emojis[pairIndex]
            
        }
    }
    
    //var objectWillChange: ObservableObjectPublisher
    
    //MARK: - Access to data
    var cards:Array<MemoryGame<String>.Card> {
        return model.cards
    }
    //MARK: - intents
    func choose (card: MemoryGame<String>.Card){
        //instead objectWillChange varible we use @Published on var model
        //objectWillChange.send()
        model.Choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
        print("newgame")
    }
}
