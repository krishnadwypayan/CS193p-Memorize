//
//  ThemeView.swift
//  MemorizeApp
//
//  Created by krkota on 10/07/21.
//

import SwiftUI

struct ThemeView: View {
    
    private var themeViewModal = ThemeViewModel()
    @State private var showAddThemeModal = false
    
    var body: some View {
        NavigationView {
            ThemeItemsListView(themeViewModel: themeViewModal)
                .navigationBarTitle(Text("Memorize"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.showAddThemeModal = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .padding()
                        }
                        .sheet(isPresented: $showAddThemeModal) {
                            AddThemeModalView(themeViewModal: themeViewModal)
                        }
                    }
                }
        }
    }
}

struct ThemeItemsListView: View {
    @ObservedObject var themeViewModel: ThemeViewModel
    
    var body: some View {
        List(themeViewModel.themeContents) { themeContent in
            NavigationLink(destination: GameView(themeContent: themeContent)) {
                HStack {
                    themeContent.themeIcon
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24.0, height: 24.0)
                        .foregroundColor(themeContent.themeColor)
                        .padding(.horizontal)

                    Text(themeContent.themeName)
                        .font(.headline)
                        .padding()
                    
                    Spacer()
                }
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

struct AddThemeModalView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var themeName = ""
    @State private var themeColor = Color.red
    @State private var numberOfPairsToShow = 0
    @State private var emojis = ""
    var themeViewModal: ThemeViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create Your Theme")) {
                    TextField("Theme Name", text: $themeName)
                    ColorPicker("Theme Color", selection: $themeColor)
                    Picker(selection: $numberOfPairsToShow, label: Text("Pairs to Show")) {
                        ForEach(1...20, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    TextField("Add Emojis", text: $emojis)
                }
                
                Section {
                    Button(action: {
                        var emojisArr = emojis.map { String($0) }
                        emojisArr = Array(Set(emojisArr))
                        themeViewModal.addTheme(themeName: themeName, themeColor: themeColor, emojis: emojisArr, numberOfPairsToShow: min(emojisArr.count, numberOfPairsToShow))
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Done")
                            Spacer()
                        }
                    })
                }
            }
            .navigationBarTitle(Text("Add Theme"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }.padding()
                }
            }
        }
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView().preferredColorScheme(.dark)
        ThemeView()
    }
}
