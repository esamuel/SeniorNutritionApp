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
} 