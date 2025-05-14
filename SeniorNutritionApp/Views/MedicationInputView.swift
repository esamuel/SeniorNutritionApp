import SwiftUI

struct MedicationInputView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var speechManager = SpeechRecognitionManager.shared
    
    // State variables for medication input
    @State private var medicationName = ""
    @State private var selectedFrequencyType: FrequencyType = .daily
    @State private var timesOfDay: [TimeOfDay] = [TimeOfDay(hour: 8, minute: 0)]
    @State private var weeklySelectedDays: Set<Weekday> = []
    @State private var intervalDays: Int = 2
    @State private var intervalStartDate: Date = Date()
    @State private var monthlySelectedDay: Int = 1
    @State private var takeWithFood = false
    @State private var notes = ""
    @State private var showingLanguagePicker = false
    @State private var dosage = ""
    
    // Pill appearance variables
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
                                    Image(systemName: speechManager.isRecording ? "stop.circle.fill" : "mic.circle.fill")
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
                                Stepper("Every " + String(intervalDays) + " days", value: $intervalDays, in: 1...30)
                                DatePicker("Starting From", selection: $intervalStartDate, displayedComponents: .date)
                            case .monthly:
                                Picker("Day of the Month", selection: $monthlySelectedDay) {
                                    ForEach(1...31, id: \.self) { day in
                                        Text(String(day)).tag(day)
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
                                            get: { timesOfDay[index].dateRepresentation },
                                            set: { date in
                                                // Convert Date back to TimeOfDay and update state
                                                let calendar = Calendar.current
                                                let components = calendar.dateComponents([.hour, .minute], from: date)
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
                                    .datePickerLTR() // Fix RTL layout issues
                                    
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
                    
                    // Additional Settings Section
                    pillAppearanceSection
                    
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
                SpeechLanguagePickerView(
                    selectedIndex: $speechManager.selectedLanguageIndex,
                    languages: speechManager.availableLanguages
                )
            }
        }
    }
    
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
    
    private func saveMedication() {
        let medication = Medication(
            id: UUID(), // Ensure a new ID is generated
            name: medicationName,
            dosage: dosage,
            frequency: createScheduleDetails(), // Create ScheduleDetails
            timesOfDay: timesOfDay.sorted(), // Use the sorted times
            takeWithFood: takeWithFood,
            notes: notes.isEmpty ? nil : notes,
            color: selectedColor, // Use the selected color
            shape: selectedShape // Use the selected shape
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
    
    private func deleteTime(at offsets: IndexSet) {
        // Ensure sorting after deletion if necessary, though indices should handle it
        timesOfDay.remove(atOffsets: offsets)
        timesOfDay.sort() // Re-sort after deletion
    }
    
    // MARK: - Pill Appearance Section
    private var pillAppearanceSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pill Appearance")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .padding(.horizontal)
            VStack(spacing: 15) {
                // 3D Pill Preview
                HStack(spacing: 20) {
                    Pill3DView(shape: mapToPill3DShape(selectedShape), color: selectedColor)
                        .frame(width: 80, height: 40)
                        .padding(.vertical, 8)
                    Button("Select Shape") {
                        showingShapePicker = true
                    }
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.leading, 8)
                    Spacer()
                }
                .sheet(isPresented: $showingShapePicker) {
                    PillShapeView(selectedShape: $selectedShape)
                        .environmentObject(userSettings)
                }
                // Color Picker
                HStack {
                    Text("Pill Color")
                        .font(.system(size: userSettings.textSize.size))
                    Spacer()
                    Button(action: { showingColorPicker = true }) {
                        Circle()
                            .fill(selectedColor)
                            .frame(width: 30, height: 30)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
                .sheet(isPresented: $showingColorPicker) {
                    ColorPicker("Select Pill Color", selection: $selectedColor)
                        .padding()
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
    
    // Helper to map app PillShape to Pill3DView.PillShape
    private func mapToPill3DShape(_ shape: PillShape) -> Pill3DView.PillShape {
        switch shape {
        case .round: return .round
        case .oval: return .oval
        case .capsule: return .capsule
        case .rectangle: return .rectangle
        case .diamond: return .diamond
        case .triangle: return .triangle
        case .other: return .capsule // fallback
        }
    }
}

// Using ColorPickerView from ColorPickerView.swift
