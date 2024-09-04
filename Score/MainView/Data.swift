//
//  Data.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import Foundation


enum Languages {
    case fr, en
}


@Observable
class Data {
    var languages: Languages
    
    init(languages: Languages = .en) {
        self.languages = languages
    }
}


struct LanguagesText {
    func getText(for key: String, for language: Languages) -> String {
        return texts[key]?[language] ?? (language == .en ? "No key available" : "Data indisponible")
    }
    
    private let texts: [String: [Languages: String]] = [
        "settingsPicker": [
            .fr: "Choisissez votre langue",
            .en: "Choose your language"
        ]
    ]
}
