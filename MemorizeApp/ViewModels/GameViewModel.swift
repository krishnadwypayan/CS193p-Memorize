//
//  GameViewModel.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import SwiftUI

class GameViewModel: ObservableObject {
    
    typealias Card = GameModel<String>
    @Published private(set) var model: Card
    @Published var shouldShowAlert: Bool = false
    @Published private(set) var score: Int = 0
    private var themeContent: ThemeViewModel.ThemeContent
    
    init(themeContent: ThemeViewModel.ThemeContent) {
        self.themeContent = themeContent
        self.model = GameModel(dataSize: themeContent.emojis.count, numberOfPairsOfCards: themeContent.numberOfPairsToShow, createCard: { index in
            themeContent.emojis[index]
        })
    }
    
    func choose(_ card: Card.Card) {
        score = model.choose(card)
        if let cardsLeft = model.numberOfCardsLeftToMatch, cardsLeft == 0 {
            shouldShowAlert = true
        }
    }
    
    func loadNewGame(themeContent: ThemeViewModel.ThemeContent) {
        self.score = 0
        self.model = GameModel(
            dataSize: themeContent.emojis.count,
            numberOfPairsOfCards: themeContent.numberOfPairsToShow) { index in themeContent.emojis[index] }
    }
}
