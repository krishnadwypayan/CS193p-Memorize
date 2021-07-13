//
//  GameModel.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import Foundation

struct GameModel<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var numberOfCardsLeftToMatch: Int?
    private var score: Int
    
    private var oneAndOnlyFaceUpCardIndex: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    init(dataSize: Int, numberOfPairsOfCards: Int, createCard: (Int) -> CardContent) {
        let minNumberOfPairsOfCards = min(numberOfPairsOfCards, dataSize)
        cards = [Card]()
        let indices = (0..<dataSize).shuffled()
        for index in 0..<minNumberOfPairsOfCards {
            cards.append(Card(content: createCard(indices[index]), id: index*2))
            cards.append(Card(content: createCard(indices[index]), id: index*2 + 1))
        }
        cards.shuffle()
        
        self.numberOfCardsLeftToMatch = minNumberOfPairsOfCards
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
                
                cards[chosenCardIndex].isFaceUp = true
                cards[chosenCardIndex].isSeen = true
                cards[potentialCardIndex].isSeen = true
            } else {
                oneAndOnlyFaceUpCardIndex = chosenCardIndex
            }
        }
        
        return score
    }
    
    struct Card: Identifiable {
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let id: Int
    }
}

extension Array {
    var oneAndOnly: Element? { self.count == 1 ? self.first : nil }
}
