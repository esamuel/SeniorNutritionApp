import SwiftUI

struct LanguageSelectorView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.presentationMode) var presentationMode
    
    let languages = [
        ("English", "en", "🇺🇸"),
        ("עברית", "he", "🇮🇱"),
        ("Español", "es", "🇪🇸"),
        ("Français", "fr", "🇫🇷")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(languages, id: \.1) { language in
                    Button(action: {
                        languageManager.setLanguage(language.1)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            // Country flag emoji
                            Text(language.2)
                                .font(.title2)
                                .frame(width: 30, height: 20)
                            
                            Text(language.0)
                                .foregroundColor(.primary)
                                .environment(\.layoutDirection, language.1 == "he" ? .rightToLeft : .leftToRight)
                            
                            Spacer()
                            
                            if languageManager.currentLanguage == language.1 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text(NSLocalizedString("Language", comment: "Language selection screen title")))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "Done button in language selector")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .environment(\.layoutDirection, languageManager.layoutDirection)
        .onAppear {
            if languageManager.currentLanguage.isEmpty {
                languageManager.setLanguage("en")
            }
        }
    }
}

#Preview {
    LanguageSelectorView()
        .environmentObject(LanguageManager.shared)
} 