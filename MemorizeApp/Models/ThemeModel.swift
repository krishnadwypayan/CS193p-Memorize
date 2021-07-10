//
//  ThemeModel.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import Foundation

struct ThemeModel {
    var themesList: [ThemeData] = [
        ThemeData(name: "Vehicles",
              emojis: ["✈️", "🚗", "🚀", "⛵️", "🛵", "🚓", "🏎", "🛴", "🚲", "🛺", "🚅", "🛶", "🛳", "⛴", "🚌", "🚛", "🚤", "🚑"],
              numberOfPairsToShow: 8, themeColor: "red"),
        ThemeData(name: "Smileys", emojis: ["😀", "😂", "🤩", "😇", "😍", "😘", "😴", "😡", "😜", "😭", "😎", "😑", "😒", "🥳", "😱", "🤮", "😈", "😬"],
              numberOfPairsToShow: 8, themeColor: "blue"),
        ThemeData(name: "Animals", emojis: ["🐶", "🐱", "🦊", "🐼", "🐯", "🐮", "🐒", "🐣", "🐴", "🐳", "🦕", "🦓", "🐊", "🐘", "🐢", "🦋", "🐟", "🦄"],
              numberOfPairsToShow: 8, themeColor: "green")
    ]
    
    struct ThemeData {
        var name: String
        var emojis: [String]
        var numberOfPairsToShow: Int
        var themeColor: String
    }
}
