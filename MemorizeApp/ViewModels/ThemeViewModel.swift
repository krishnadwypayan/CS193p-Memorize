//
//  ThemeViewModal.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import SwiftUI

class ThemeViewModel: ObservableObject {
    
    let themeModel = ThemeModel()
    @Published var themeContents: [ThemeContent]
    
    init() {
        themeContents = [ThemeContent]()
        for (index, theme) in themeModel.themesList.enumerated() {
            themeContents.append(
                ThemeContent(themeName: theme.name,
                             themeColor: getThemeColor(colorStr: theme.themeColor),
                             themeIcon: getThemeIcon(themeName: theme.name),
                             emojis: theme.emojis,
                             numberOfPairsToShow: theme.numberOfPairsToShow,
                             id: index)
            )
        }
    }

    func getThemeColor(colorStr: String) -> Color {
        switch colorStr {
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        default:
            return .purple
        }
    }
    
    func getThemeIcon(themeName: String) -> Image {
        switch themeName {
        case "Vehicles":
            return Image(systemName: "car.fill")
        case "Smileys":
            return Image(systemName: "face.smiling")
        case "Animals":
            return Image(systemName: "hare")
        default:
            return Image(systemName: "gamecontroller")
        }
    }
    
    func addTheme(themeName: String, themeColor: Color, emojis: [String], numberOfPairsToShow: Int) {
        themeContents.append(ThemeContent(themeName: themeName, themeColor: themeColor, themeIcon: Image(systemName: "gear"), emojis: emojis, numberOfPairsToShow: numberOfPairsToShow, id: themeContents.count))
    }
    
    struct ThemeContent: Identifiable {
        var themeName: String
        var themeColor: Color
        var themeIcon: Image
        var emojis: [String]
        var numberOfPairsToShow: Int
        var id: Int
    }
}
