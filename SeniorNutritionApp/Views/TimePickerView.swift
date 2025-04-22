import SwiftUI

struct TimePickerView: View {
    @Binding var time: Date
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Time",
                    selection: $time,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
            }
            .navigationTitle("Select Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                }
            }
        }
    }
} 