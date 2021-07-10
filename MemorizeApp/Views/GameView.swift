//
//  GameView.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import SwiftUI

struct GameView: View {
    
    private var themeContent: ThemeViewModel.ThemeContent
    @ObservedObject private var gameViewModel: GameViewModel
    
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
    @State var orientation = UIDeviceOrientation.unknown
    @ObservedObject var gameViewModel: GameViewModel
    var themeContent: ThemeViewModel.ThemeContent
    
    var body: some View {
        ScrollView {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let columns = Array<GridItem>(repeating: GridItem(.adaptive(minimum: screenHeight/4)), count: 4)
            let rows = Array<GridItem>(repeating: GridItem(.adaptive(minimum: screenWidth/2)), count: 8)
        
            if orientation.isPortrait || screenWidth < screenHeight {
                LazyVGrid(columns: columns, content: { content })
                    .foregroundColor(themeContent.themeColor)
            } else if orientation.isLandscape || screenWidth > screenHeight {
                LazyVGrid(columns: rows, content: { content })
                    .foregroundColor(themeContent.themeColor)
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    var content: some View {
        ForEach(gameViewModel.model.cards) { card in
            CardView(card: card)
                .aspectRatio(2/3, contentMode: .fit)
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
        }
    }
}

struct CardView: View {
    var card: GameModel<String>.Card
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 15.0)
        ZStack {
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0.3)
            } else {
                shape.fill()
            }
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct GameView_Previews: PreviewProvider {
    var gameViewModel: GameViewModel
    
    static var previews: some View {
        GameView(themeContent:
                    ThemeViewModel.ThemeContent(
                        themeName: "Vehicles", themeColor: .red,
                        themeIcon: Image(systemName: "car"),
                        emojis: ["🚗", "🚀", "🚲", "✈️", "🛵", "⛴", "🚚", "🚁"], numberOfPairsToShow: 8, id: 0
                    )
        )
        
        GameView(themeContent:
                    ThemeViewModel.ThemeContent(
                        themeName: "Vehicles", themeColor: .red,
                        themeIcon: Image(systemName: "car"),
                        emojis: ["🚗", "🚀", "🚲", "✈️", "🛵", "⛴", "🚚", "🚁"], numberOfPairsToShow: 8, id: 0
                    )
        ).preferredColorScheme(.dark)
    }
}
