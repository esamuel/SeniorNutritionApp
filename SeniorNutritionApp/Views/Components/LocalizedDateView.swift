import SwiftUI

/// A view component that displays dates in the current app language
struct LocalizedDateView: View {
    var date: Date
    var showTime: Bool = true
    var showDate: Bool = true
    var dateStyle: DateFormatter.Style = .medium
    var timeStyle: DateFormatter.Style = .short
    
    var body: some View {
        if showDate && showTime {
            Text(date.localizedString(dateStyle: dateStyle, timeStyle: timeStyle))
        } else if showDate {
            Text(date.localizedDateString(style: dateStyle))
        } else if showTime {
            Text(date.localizedTimeString())
        }
    }
}

/// A view component that displays the current date in the app language
struct CurrentDateView: View {
    var body: some View {
        Text(String.currentLocalizedDate)
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
}
