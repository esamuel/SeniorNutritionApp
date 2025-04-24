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
            ScrollView {
                VStack(spacing: 20) {
                    // Medication Details Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Medication Details")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            // Name Input
                            HStack {
                                TextField("Medication Name", text: $medicationName)
                                    .font(.system(size: userSettings.textSize.size))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button(action: {
                                    if speechManager.isRecording {
                                        speechManager.stopRecording()
                                    } else {
                                        speechManager.startRecording()
                                    }
                                }) {
                                    Image(systemName: speechManager.isRecording ? "mic.fill" : "mic")
                                        .foregroundColor(speechManager.isRecording ? .red : .blue)
                                        .font(.system(size: userSettings.textSize.size))
                                }
                                
                                Button(action: {
                                    showingLanguagePicker = true
                                }) {
                                    Image(systemName: "globe")
                                        .foregroundColor(.blue)
                                        .font(.system(size: userSettings.textSize.size))
                                }
                            }
                            
                            if !speechManager.transcribedText.isEmpty {
                                Text(speechManager.transcribedText)
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.secondary)
                                    .onTapGesture {
                                        medicationName = speechManager.transcribedText
                                        speechManager.transcribedText = ""
                                    }
                            }
                            
                            if let error = speechManager.errorMessage {
                                Text(error)
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.red)
                            }
                            
                            // Dosage Input
                            TextField("Dosage", text: $dosage)
                                .font(.system(size: userSettings.textSize.size))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // Schedule Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Schedule")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            ForEach(schedule.indices, id: \.self) { index in
                                HStack {
                                    Text(timeFormatter.string(from: schedule[index]))
                                        .font(.system(size: userSettings.textSize.size))
                                    
                                    Spacer()
                                    
                                    Button("Edit") {
                                        selectedTimeIndex = index
                                        showingTimePicker = true
                                    }
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.blue)
                                }
                            }
                            .onDelete(perform: deleteTime)
                            
                            Button(action: {
                                schedule.append(Date())
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Time")
                                }
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // Take with Food Toggle
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Additional Settings")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        Toggle("Take with Food", isOn: $takeWithFood)
                            .font(.system(size: userSettings.textSize.size))
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Notes")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        TextEditor(text: $notes)
                            .font(.system(size: userSettings.textSize.size))
                            .frame(height: 100)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: saveMedication) {
                        Text("Save Changes")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(medicationName.isEmpty || schedule.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(16)
                    }
                    .disabled(medicationName.isEmpty || schedule.isEmpty)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Edit Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
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
                notes: notes.isEmpty ? nil : notes
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