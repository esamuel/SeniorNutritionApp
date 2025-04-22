import SwiftUI

struct EditMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var speechManager = SpeechRecognitionManager.shared
    
    let medication: Medication
    @State private var medicationName: String
    @State private var schedule: [Date]
    @State private var takeWithFood: Bool
    @State private var notes: String
    @State private var showingTimePicker = false
    @State private var selectedTimeIndex = 0
    @State private var showingLanguagePicker = false
    @State private var dosage: String
    
    init(medication: Medication) {
        self.medication = medication
        _medicationName = State(initialValue: medication.name)
        _schedule = State(initialValue: medication.schedule)
        _takeWithFood = State(initialValue: medication.takeWithFood)
        _notes = State(initialValue: medication.notes ?? "")
        _dosage = State(initialValue: medication.dosage)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    HStack {
                        TextField("Medication Name", text: $medicationName)
                        
                        Button(action: {
                            if speechManager.isRecording {
                                speechManager.stopRecording()
                            } else {
                                speechManager.startRecording()
                            }
                        }) {
                            Image(systemName: speechManager.isRecording ? "mic.fill" : "mic")
                                .foregroundColor(speechManager.isRecording ? .red : .blue)
                        }
                        
                        Button(action: {
                            showingLanguagePicker = true
                        }) {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if !speechManager.transcribedText.isEmpty {
                        Text(speechManager.transcribedText)
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                medicationName = speechManager.transcribedText
                                speechManager.transcribedText = ""
                            }
                    }
                    
                    if let error = speechManager.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    TextField("Dosage", text: $dosage)
                }
                
                Section(header: Text("Schedule")) {
                    ForEach(schedule.indices, id: \.self) { index in
                        HStack {
                            Text(timeFormatter.string(from: schedule[index]))
                            Spacer()
                            Button("Edit") {
                                selectedTimeIndex = index
                                showingTimePicker = true
                            }
                        }
                    }
                    .onDelete(perform: deleteTime)
                    
                    Button("Add Time") {
                        schedule.append(Date())
                    }
                }
                
                Section {
                    Toggle("Take with Food", isOn: $takeWithFood)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Edit Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMedication()
                    }
                    .disabled(medicationName.isEmpty || schedule.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingTimePicker) {
                TimePickerView(time: Binding(
                    get: { schedule[selectedTimeIndex] },
                    set: { schedule[selectedTimeIndex] = $0 }
                )) {
                    showingTimePicker = false
                }
            }
            .sheet(isPresented: $showingLanguagePicker) {
                LanguagePickerView(
                    selectedIndex: $speechManager.selectedLanguageIndex,
                    languages: speechManager.availableLanguages
                )
            }
        }
    }
    
    private func saveMedication() {
        if let index = userSettings.medications.firstIndex(where: { $0.id == medication.id }) {
            userSettings.medications[index] = Medication(
                id: medication.id,
                name: medicationName,
                dosage: dosage,
                schedule: schedule,
                takeWithFood: takeWithFood,
                notes: notes
            )
        }
        dismiss()
    }
    
    private func deleteTime(at offsets: IndexSet) {
        schedule.remove(atOffsets: offsets)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct EditMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        EditMedicationView(
            medication: Medication(
                name: "Sample Medication",
                dosage: "10mg",
                schedule: [Date()],
                takeWithFood: true
            )
        )
        .environmentObject(UserSettings())
    }
} 