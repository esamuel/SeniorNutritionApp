import Foundation
import SwiftUI

@MainActor
extension Meal {
    func localizedName() -> String {
        let langCode = Locale.current.languageCode ?? "en"
        switch langCode {
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