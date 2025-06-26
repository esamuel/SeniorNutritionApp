import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIndex: Int
    let languages: [(locale: Locale, name: String)]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(languages.indices, id: \.self) { index in
                    Button(action: {
                        selectedIndex = index
                        dismiss()
                    }) {
                        HStack {
                            // Country flag emoji based on locale
                            Text(getFlagEmoji(for: languages[index].locale))
                                .font(.title2)
                                .frame(width: 30, height: 20)
                            
                            Text(languages[index].name)
                            
                            Spacer()
                            
                            if index == selectedIndex {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Helper function to get flag emoji for a locale
    private func getFlagEmoji(for locale: Locale) -> String {
        let languageCode = locale.languageCode ?? "en"
        let regionCode = locale.regionCode ?? "US"
        
        switch languageCode {
        case "en":
            return "🇺🇸"
        case "he":
            return "🇮🇱"
        case "es":
            return "🇪🇸"
        case "fr":
            return "🇫🇷"
        default:
            // Fallback: try to construct flag from region code
            let base: UInt32 = 127397
            let region = regionCode.uppercased()
            var flag = ""
            for scalar in region.unicodeScalars {
                flag.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
            }
            return flag
        }
    }
} 