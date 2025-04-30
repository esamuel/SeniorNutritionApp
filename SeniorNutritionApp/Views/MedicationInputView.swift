import SwiftUI
import Foundation

struct MedicationInputView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var speechManager = SpeechRecognitionManager.shared
    
    @State private var medicationName = ""
    // New State Variables for Scheduling
    @State private var selectedFrequencyType: FrequencyType = .daily
    @State private var timesOfDay: [TimeOfDay] = [TimeOfDay(hour: 8, minute: 0)] // Default to one time
    @State private var weeklySelectedDays: Set<Weekday> = []
    @State private var intervalDays: Int = 2 // Default to every 2 days
    @State private var intervalStartDate: Date = Date()
    @State private var monthlySelectedDay: Int = 1 // Default to 1st of the month
    
    @State private var takeWithFood = false
    @State private var notes = ""
    @State private var showingLanguagePicker = false
    @State private var dosage = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedShape: PillShape = .capsule
    @State private var showingColorPicker = false
    @State private var showingShapePicker = false
    
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
                            // Frequency Type Picker
                            Picker("Frequency", selection: $selectedFrequencyType) {
                                ForEach(FrequencyType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.bottom, 5)
                            
                            // Conditional Inputs based on Frequency Type
                            switch selectedFrequencyType {
                            case .weekly:
                                WeekdayMultiSelector(selectedDays: $weeklySelectedDays)
                                    .padding(.vertical, 5)
                            case .interval:
                                Stepper("Every \(intervalDays) days", value: $intervalDays, in: 1...30)
                                DatePicker("Starting From", selection: $intervalStartDate, displayedComponents: .date)
                            case .monthly:
                                Picker("Day of the Month", selection: $monthlySelectedDay) {
                                    ForEach(1...31, id: \.self) { day in
                                        Text("\(day)").tag(day)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            case .daily:
                                // No specific controls for daily frequency itself
                                EmptyView()
                            }
                            
                            Divider().padding(.vertical, 5)
                            
                            Text("Time(s) to Take Medication")
                                .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            let times = timesOfDay
                            ForEach(times.indices, id: \.self) { index in
                                HStack {
                                    // Use DatePicker bound to a Date representation of TimeOfDay
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: { timesOfDay[index].dateRepresentation }, // Convert TimeOfDay to Date
                                            set: { date in
                                                // Convert Date back to TimeOfDay and update state
                                                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                                                if let hour = components.hour, let minute = components.minute {
                                                    timesOfDay[index] = TimeOfDay(hour: hour, minute: minute)
                                                    timesOfDay.sort() // Keep sorted after edit
                                                }
                                            }
                                        ),
                                        displayedComponents: .hourAndMinute
                                    )
                                    .labelsHidden() // Hide the default label
                                    .font(.system(size: userSettings.textSize.size))
                                    
                                    Spacer()
                                }
                            }
                            .onDelete(perform: deleteTime)
                            
                            Button(action: {
                                timesOfDay.append(TimeOfDay(hour: 8, minute: 0))
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
                    
                    // Take with Food Toggle and Appearance Settings
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Additional Settings")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            Toggle("Take with Food", isOn: $takeWithFood)
                                .font(.system(size: userSettings.textSize.size))
                            
                            Divider()
                            
                            // Pill Shape Selection
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Pill Shape")
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                
                                HStack {
                                    pillShapePreview(shape: selectedShape)
                                        .frame(width: 40, height: 40)
                                    
                                    Button("Select Shape") {
                                        showingShapePicker = true
                                    }
                                    .font(.system(size: userSettings.textSize.size))
                                    .padding(.leading, 8)
                                    
                                    Spacer()
                                }
                                .sheet(isPresented: $showingShapePicker) {
                                    PillShapeView(selectedShape: $selectedShape)
                                }
                            }
                            
                            Divider()
                            
                            // Pill Color Selection
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Pill Color")
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                
                                HStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedColor)
                                        .frame(width: 40, height: 40)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    
                                    Button("Select Color") {
                                        showingColorPicker = true
                                    }
                                    .font(.system(size: userSettings.textSize.size))
                                    .padding(.leading, 8)
                                    
                                    Spacer()
                                }
                                .sheet(isPresented: $showingColorPicker) {
                                    ColorPickerView(selectedColor: $selectedColor)
                                }
                            }
                        }
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
                        Text("Save Medication")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSaveButtonDisabled ? Color.gray : Color.blue)
                            .cornerRadius(16)
                    }
                    .disabled(isSaveButtonDisabled)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
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
        let medication = Medication(
            id: UUID(), // Ensure a new ID is generated
            name: medicationName,
            dosage: dosage,
            frequency: createScheduleDetails(), // Create ScheduleDetails
            timesOfDay: timesOfDay.sorted(), // Use the sorted times
            takeWithFood: takeWithFood,
            notes: notes.isEmpty ? nil : notes,
            color: selectedColor, // Already Codable via hex
            shape: selectedShape // Already Codable
        )
        userSettings.medications.append(medication)
        dismiss()
    }
    
    // Helper function to create ScheduleDetails
    private func createScheduleDetails() -> ScheduleDetails {
        switch selectedFrequencyType {
        case .daily:
            return .daily
        case .weekly:
            return .weekly(days: weeklySelectedDays) // Pass the Set directly
        case .interval:
            return .interval(days: intervalDays, startDate: intervalStartDate)
        case .monthly:
            return .monthly(day: monthlySelectedDay)
        }
    }
    
    // Computed property for save button disable state
    private var isSaveButtonDisabled: Bool {
        if medicationName.isEmpty || timesOfDay.isEmpty {
            return true
        }
        // Add specific validation for frequency types if needed
        if selectedFrequencyType == .weekly && weeklySelectedDays.isEmpty {
            return true // Must select at least one day for weekly
        }
        // Add other validation as necessary (e.g., interval days > 0)
        return false
    }
    
    private func deleteTime(at offsets: IndexSet) {
        // Ensure sorting after deletion if necessary, though indices should handle it
        timesOfDay.remove(atOffsets: offsets)
        timesOfDay.sort() // Re-sort after deletion
    }
    
    // Function to preview the pill shape
    private func pillShapePreview(shape: PillShape) -> some View {
        Group {
            switch shape {
            case .round:
                Circle()
                    .fill(selectedColor)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            case .oval:
                Capsule()
                    .fill(selectedColor)
                    .frame(width: 40, height: 25)
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            case .capsule:
                Capsule()
                    .fill(selectedColor)
                    .frame(width: 40, height: 20)
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            case .rectangle:
                RoundedRectangle(cornerRadius: 2)
                    .fill(selectedColor)
                    .frame(width: 35, height: 25)
                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 1))
            case .diamond:
                Diamond()
                    .fill(selectedColor)
                    .frame(width: 30, height: 30)
                    .overlay(Diamond().stroke(Color.gray, lineWidth: 1))
            case .triangle:
                Triangle()
                    .fill(selectedColor)
                    .frame(width: 35, height: 30)
                    .overlay(Triangle().stroke(Color.gray, lineWidth: 1))
            case .other:
                Text("?")
                    .font(.system(size: 25))
                    .foregroundColor(selectedColor)
            }
        }
    }
}

struct MedicationInputView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationInputView()
    }
}