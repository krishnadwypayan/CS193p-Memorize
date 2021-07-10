//
//  GameModel.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import Foundation

struct GameModel<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private var oneAndOnlyFaceUpCardIndex: Int?
    private(set) var numberOfCardsLeftToMatch: Int?
    private var score: Int
    
    init(dataSize: Int, numberOfPairsOfCards: Int, createCard: (Int) -> CardContent) {
        cards = [Card]()
        let indices = (0..<dataSize).shuffled()
        for index in 0..<numberOfPairsOfCards {
            cards.append(Card(content: createCard(indices[index]), id: index*2))
            cards.append(Card(content: createCard(indices[index]), id: index*2 + 1))
        }
        cards.shuffle()
        
        self.numberOfCardsLeftToMatch = numberOfPairsOfCards
        self.score = 0
    }
    
    /**
     ["😍", "🥰"] 0
     ["😎", "😂"] 0
     ["🥰", "🥰"] 2
     ["😍", "🤮"] 1
     ["😂", "😍"] -1
     */
    mutating func choose(_ card: Card) -> Int {
        if let chosenCardIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenCardIndex].isFaceUp, !cards[chosenCardIndex].isMatched {
            if let potentialCardIndex = oneAndOnlyFaceUpCardIndex {
                if cards[potentialCardIndex].content == cards[chosenCardIndex].content {
                    cards[chosenCardIndex].isMatched = true
                    cards[potentialCardIndex].isMatched = true
                    numberOfCardsLeftToMatch! -= 1
                    score += 2
                } else {
                    score -= cards[chosenCardIndex].isSeen ? 1 : 0
                    score -= cards[potentialCardIndex].isSeen ? 1 : 0
                }
                
                cards[chosenCardIndex].isSeen = true
                cards[potentialCardIndex].isSeen = true
                oneAndOnlyFaceUpCardIndex = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                oneAndOnlyFaceUpCardIndex = chosenCardIndex
            }
            
            cards[chosenCardIndex].isFaceUp.toggle()
        }
        
        return score
    }
    
    struct Card: Identifiable {
        var content: CardContent
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var id: Int
    }
}
