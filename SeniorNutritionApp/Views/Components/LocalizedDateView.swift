import SwiftUI

/// A view component that displays dates in the current app language and automatically updates when the language changes.
struct LocalizedDateView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var date: Date
    var showTime: Bool = true
    var showDate: Bool = true
    var dateStyle: DateFormatter.Style = .medium
    var timeStyle: DateFormatter.Style = .short
    
    var body: some View {
        Group {
            if showDate && showTime {
                Text(date.localizedString(dateStyle: dateStyle, timeStyle: timeStyle))
            } else if showDate {
                Text(date.localizedDateString(style: dateStyle))
            } else if showTime {
                Text(date.localizedTimeString())
            }
        }
        .id(languageManager.currentLanguage) // Force refresh on language change
    }
}

/// A view component that displays the current date in the app language and updates on language change.
struct CurrentDateView: View {
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        Text(String.currentLocalizedDate)
            .id(languageManager.currentLanguage) // Force refresh on language change
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Date Examples")
            .font(.headline)
        
        LocalizedDateView(date: Date(), showTime: true, showDate: true)
        LocalizedDateView(date: Date(), showTime: false, showDate: true, dateStyle: .full)
        LocalizedDateView(date: Date(), showTime: true, showDate: false)
        
        Text("Current Date")
            .font(.headline)
        CurrentDateView()
    }
    .padding()
    .environmentObject(LanguageManager.shared) // For preview
}
