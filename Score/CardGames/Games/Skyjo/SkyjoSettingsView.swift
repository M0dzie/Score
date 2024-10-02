//
//  SkyjoSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI


struct SkyjoSettingsView: View {
    @Environment(Data.self) var data
    @State private var numberOfPlayer = 2
    @State private var maxScore: Double = 100
    @State private var names: [String] = Array(repeating: "", count: 2)
    @State private var isShowingAlert = false
    @State private var isPartyOngoing = UserDefaults.standard.bool(forKey: "partyOngoing")
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(getText(forKey: "players", forLanguage: data.languages)) {
                        Picker(getText(forKey: "numberOfPlayers", forLanguage: data.languages), selection: $numberOfPlayer) {
                            ForEach(2..<9, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .onChange(of: numberOfPlayer) { oldValue, newValue in
                            if names.count < newValue {
                                names.append(contentsOf: Array(repeating: "", count: newValue - names.count))
                            } else if names.count > newValue {
                                names.removeLast(names.count - newValue)
                            }
                        }
                        
                        ForEach(0..<numberOfPlayer, id: \.self) { index in
                            TextField(getText(forKey: "pseudo", forLanguage: data.languages), text: $names[index])
                        }
                    }
                    
                    Section(getText(forKey: "maxScore", forLanguage: data.languages)) {
                        HStack {
                            Text(String(Int(maxScore)))
                            Slider(value: $maxScore, in: 80...120, step: 1)
                        }
                    }
                    
                    Section(getText(forKey: "rules", forLanguage: data.languages)) {
                        RulesText(text: getRules(forKey: "skyjo", forLanguage: data.languages), language: data.languages)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius:40)
                        .fill(Color.secondary.opacity(0.1))
                )
                
                loadButtons()
            }
            .onAppear {
                resetData()
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(getText(forKey: "alertTitle", forLanguage: data.languages)),
                    message: Text(getText(forKey: "alertMessage", forLanguage: data.languages)),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle(getText(forKey: "settings", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadButtons() -> some View {
        HStack {
            if isPartyOngoing {
                Spacer()
                NavigationLink(getText(forKey: "continue", forLanguage: data.languages)) {
                    SkyjoView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names)
                }
                .padding()
                .foregroundStyle(.white)
                .background(.green)
                .cornerRadius(10)
            }
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                SkyjoView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names)
            }
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(10)
            .disabled(names.contains(where: { $0.isEmpty }) || names.count != Set(names).count)
            .onTapGesture {
                if (names.count != Set(names).count) && !names.contains(where: { $0.isEmpty }) {
                    isShowingAlert = true
                }
            }
            Spacer()
        }
        .padding()
    }
    
    func resetData() {
        isPartyOngoing = UserDefaults.standard.bool(forKey: "partyOngoing")
        numberOfPlayer = 2
        maxScore = 100
        names = Array(repeating: "", count: 2)
    }
}

#Preview {
    SkyjoSettingsView()
        .environment(Data())
}
