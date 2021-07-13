//
//  GameView.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import SwiftUI

struct GameView: View {
    
    private var themeContent: ThemeViewModel.ThemeContent
    @ObservedObject var gameViewModel: GameViewModel
    
    init(themeContent: ThemeViewModel.ThemeContent) {
        self.themeContent = themeContent
        self.gameViewModel = GameViewModel(themeContent: themeContent)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Text("\(gameViewModel.score)")
                    .bold()
                    .font(.largeTitle)
                    .padding(.top)
            }.padding(.horizontal)
            
            CardsListView(gameViewModel: gameViewModel, themeContent: themeContent)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(themeContent.themeName)
                            .font(.headline)
                            .bold()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            gameViewModel.loadNewGame(themeContent: themeContent)
                        }) {
                            Image(systemName: "arrow.clockwise.circle")
                                .font(.largeTitle)
                                .padding()
                        }
                    }
                }.padding()
        }
    }
}

struct CardsListView: View {
    @ObservedObject var gameViewModel: GameViewModel
    var themeContent: ThemeViewModel.ThemeContent
    
    var body: some View {
        AspectVGrid(items: gameViewModel.model.cards, aspectRatio: 2/3, content: { card in
            CardView(card: card)
                .padding(GameViewConstants.padding4)
                .onTapGesture {
                    gameViewModel.choose(card)
                }
                .alert(isPresented: $gameViewModel.shouldShowAlert) {
                    Alert(title: Text("Game Over!"),
                          message: Text("You scored \(gameViewModel.score). \nDo you wish to play a new game?"),
                          primaryButton: .default(Text("Yes")) {
                            gameViewModel.loadNewGame(themeContent: themeContent)
                            gameViewModel.shouldShowAlert = false
                          },
                          secondaryButton: .cancel({}))
                }
        })
        .foregroundColor(themeContent.themeColor)
    }
}

struct CardView: View {
    var card: GameModel<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            let shape = RoundedRectangle(cornerRadius: GameViewConstants.cardCornerRadius)
            ZStack {
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: GameViewConstants.cardLineWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 300-90))
                        .padding(GameViewConstants.padding4)
                        .opacity(GameViewConstants.cardBackgroundCircleOpacity)
                    Text(card.content)
                        .font(Font.system(size: cardContentSize(size: geometry.size)))
                } else if card.isMatched {
                    shape.opacity(GameViewConstants.cardMatchedOpacity)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func cardContentSize(size: CGSize) -> CGFloat {
        return min(size.width, size.height) * GameViewConstants.cardContentAspectRatio
    }
}

struct GameViewConstants {
    static var cardCornerRadius: CGFloat = 15
    static var cardContentAspectRatio: CGFloat = 0.7
    static var cardLineWidth: CGFloat = 3
    static var cardBackgroundCircleOpacity: Double = 0.45
    static var cardMatchedOpacity: Double = 0.3
    static var padding4: CGFloat = 4
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        
        GameView(themeContent:
                    ThemeViewModel.ThemeContent(
                        themeName: "Vehicles", themeColor: .red,
                        themeIcon: Image(systemName: "car"),
                        emojis: ["🚗", "🚀", "🚲", "✈️", "🛵", "⛴", "🚚", "🚁"],
                        numberOfPairsToShow: 4, id: 0)
        )
    }
}
