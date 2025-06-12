import SwiftUI

/// A view to test RTL and localization support
struct LocalizationTestView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var selectedDate = Date()
    @State private var numberValue: Double = 1234.56
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Language Selection
                VStack(alignment: .leading) {
                    Text("Current Language:")
                        .font(.headline)
                    
                    Picker("Language", selection: $languageManager.currentLanguage) {
                        Text("English").tag("en")
                        Text("עברית").tag("he")
                        Text("Français").tag("fr")
                        Text("Español").tag("es")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical)
                    
                    Toggle("Follow System Language", isOn: $languageManager.followSystemLanguage)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Text Samples
                VStack(alignment: .leading) {
                    Text("Text Samples")
                        .font(.headline)
                    
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Hello, World!").alignedToLanguage()
                            Text("This is a test message.").alignedToLanguage()
                            Text("The quick brown fox jumps over the lazy dog.").alignedToLanguage()
                            Text("Today is \(Date().localizedDateView(dateStyle: .full, timeStyle: .none))").alignedToLanguage()
                            Text("The number is: \(numberValue, specifier: "%.2f") (localized: \(NumberFormatter.localizedNumberFormatter().string(from: NSNumber(value: numberValue)) ?? ""))").alignedToLanguage()
                        }
                        .padding()
                    }
                }
                
                // Form Elements
                VStack(alignment: .leading) {
                    Text("Form Elements")
                        .font(.headline)
                    
                    GroupBox {
                        VStack(spacing: 15) {
                            TextField("Enter your name", text: .constant(""))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                            
                            Stepper("Value: \(Int(numberValue))", value: $numberValue, in: 0...10000, step: 1)
                            
                            Button(action: {}) {
                                Text("Tap me!")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding()
                    }
                }
                
                // RTL Test
                VStack(alignment: .leading) {
                    Text("RTL Test")
                        .font(.headline)
                    
                    HStack {
                        Text("←")
                        Text("Direction")
                        Text("→")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .rtlAware()
                }
                
                // System Info
                VStack(alignment: .leading) {
                    Text("System Info")
                        .font(.headline)
                    
                    GroupBox {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Language: \(languageManager.currentLanguage)")
                            Text("Is RTL: \(languageManager.isRTL ? "Yes" : "No")")
                            Text("Layout Direction: \(languageManager.layoutDirection == .rightToLeft ? "RTL" : "LTR")")
                            Text("Locale: \(Locale.current.identifier)")
                            Text("Calendar: \(Calendar.current.identifier)")
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Localization Test")
        .environment(\.layoutDirection, languageManager.layoutDirection)
        .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
        .onAppear {
            // Force update layout when view appears
            LocalizationUtils.updateLayoutDirection()
        }
    }
}

struct LocalizationTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocalizationTestView()
                .environmentObject(LanguageManager.shared)
        }
    }
}
