import Foundation
import SwiftUI

@MainActor
extension Meal {
    func localizedName() -> String {
        let lang: String
        if #available(iOS 16, *) {
            lang = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            lang = Locale.current.languageCode ?? "en"
        }
        switch lang {
        case "fr":
            return nameFr ?? name
        case "es":
            return nameEs ?? name
        case "he", "iw":
            return nameHe ?? name
        default:
            return name // English fallback
        }
    }
} 