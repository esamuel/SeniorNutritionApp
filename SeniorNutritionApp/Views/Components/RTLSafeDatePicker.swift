import SwiftUI

/// A DatePicker component that automatically applies RTL fixes to ensure
/// date and time pickers display correctly in all languages
struct RTLSafeDatePicker<Label: View>: View {
    var selection: Binding<Date>
    var displayedComponents: DatePickerComponents
    var label: Label
    
    init(selection: Binding<Date>, 
         displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
         @ViewBuilder label: () -> Label) {
        self.selection = selection
        self.displayedComponents = displayedComponents
        self.label = label()
    }
    
    var body: some View {
        DatePicker(
            selection: selection,
            displayedComponents: displayedComponents
        ) {
            label
        }
        .environment(\.layoutDirection, .leftToRight)
        .environment(\.locale, Locale(identifier: "en_US"))
    }
}

// Convenience initializer for string labels
extension RTLSafeDatePicker where Label == Text {
    init(_ titleKey: LocalizedStringKey, selection: Binding<Date>, displayedComponents: DatePickerComponents = [.date, .hourAndMinute]) {
        self.init(selection: selection, displayedComponents: displayedComponents) {
            Text(titleKey)
        }
    }
    
    init(_ title: String, selection: Binding<Date>, displayedComponents: DatePickerComponents = [.date, .hourAndMinute]) {
        self.init(selection: selection, displayedComponents: displayedComponents) {
            Text(title)
        }
    }
}

// Preview
#Preview {
    VStack {
        RTLSafeDatePicker("Date and Time", selection: .constant(Date()))
        
        RTLSafeDatePicker("Time Only", selection: .constant(Date()), displayedComponents: .hourAndMinute)
        
        RTLSafeDatePicker("Date Only", selection: .constant(Date()), displayedComponents: .date)
        
        RTLSafeDatePicker(selection: .constant(Date()), displayedComponents: .hourAndMinute) {
            Label("Custom Label", systemImage: "calendar")
        }
    }
    .padding()
} 