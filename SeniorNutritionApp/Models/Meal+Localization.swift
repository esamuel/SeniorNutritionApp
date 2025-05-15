import Foundation
import SwiftUI

@MainActor
extension Meal {
    func localizedName() -> String {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        let key = "\(name)_\(lang)"
        if let cached = TranslationManager.shared.cache[key] {
            return cached
        }
        // Return original name until translation is fetched
        // Fire-and-forget translation task
        Task { @MainActor in
            let translated = await TranslationManager.shared.translated(name, target: lang)
            // Trigger published update
            TranslationManager.shared.cache[key] = translated
        }
        return name
    }
} 