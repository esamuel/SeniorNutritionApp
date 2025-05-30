import SwiftUI

struct TimePickerView: View {
    @Binding var time: Date
    let onSave: () -> Void
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    NSLocalizedString("Select Time", comment: ""),
                    selection: $time,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                // Apply RTL fix only for the picker UI, but keep the locale based on app language
                .environment(\.layoutDirection, .leftToRight) // Always LTR for the picker UI
                .environment(\.locale, getLocaleForLanguage(languageManager.currentLanguage))
                .padding()
                .onChange(of: time) { oldValue, newValue in
                    // Ensure the time is set for today
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: newValue)
                    let today = calendar.startOfDay(for: Date())
                    if let updatedTime = calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: today) {
                        time = updatedTime
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Select Time", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        onSave()
                    }
                }
            }
        }
    }
    
    // Helper function to get the appropriate locale for the current language
    private func getLocaleForLanguage(_ language: String) -> Locale {
        switch language {
        case "he":
            return Locale(identifier: "he_IL")
        case "es":
            return Locale(identifier: "es_ES")
        case "fr":
            return Locale(identifier: "fr_FR")
        default:
            return Locale(identifier: "en_US")
        }
    }
} 