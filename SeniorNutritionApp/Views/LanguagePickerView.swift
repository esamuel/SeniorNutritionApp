import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIndex: Int
    let languages: [String]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<languages.count, id: \.self) { index in
                    Button(action: {
                        selectedIndex = index
                        dismiss()
                    }) {
                        HStack {
                            Text(languages[index])
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 