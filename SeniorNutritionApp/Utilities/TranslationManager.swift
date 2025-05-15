import Foundation
import Combine
#if canImport(Translate)
import Translate
#endif

@MainActor
final class TranslationManager: ObservableObject {
    static let shared = TranslationManager()
    @Published var cache: [String: String] = [:] // key: "enText_langCode"
    private init() {}
    
    func translated(_ text: String, target language: String) async -> String {
        guard language != "en" else { return text }
        let key = "\(text)_\(language)"
        if let cached = cache[key] {
            return cached
        }
        #if canImport(Translate)
        if #available(iOS 15.0, *) {
            do {
                let from = Locale.Language(identifier: "en")
                let to = Locale.Language(identifier: language)
                let translator = Translator(from: from, to: to)
                try await translator.downloadIfNeeded()
                let output = try await translator.translate(text)
                cache[key] = output
                return output
            } catch {
                // fallthrough to original
            }
        }
        #endif
        return text
    }
} 