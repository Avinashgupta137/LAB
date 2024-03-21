//
//  Language.swift
//  X-Lab
//
//  Created by Nirav Patel on 15/02/24.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()

    private var observers: [LanguageObserver] = []

    private init() {}

    func addObserver(_ observer: LanguageObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: LanguageObserver) {
        observers.removeAll(where: { $0 === observer })
    }

    func notifyLanguageChange() {
        observers.forEach { $0.languageDidChange() }
    }

    func setAppLanguage(languageCode: String) {
        guard Bundle.main.localizations.contains(languageCode) else {
            // Handle unsupported language code
            return
        }

        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        notifyLanguageChange()
    }


    func getCurrentLanguageCode() -> String {
        guard let languages = UserDefaults.standard.stringArray(forKey: "AppleLanguages"),
              let currentLanguageCode = languages.first else {
            return "en"
        }

        return currentLanguageCode
    }

}

protocol LanguageObserver: AnyObject {
    func languageDidChange()
}

extension String {
    func localizableString(loc: String) -> String {
        guard let path = Bundle.main.path(forResource: loc, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

