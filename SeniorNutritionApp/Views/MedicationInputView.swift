import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

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
                        Text(NSLocalizedString("Medication Details", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            // Name Input
                            HStack {
                                TextField(NSLocalizedString("Medication Name", comment: ""), text: $medicationName)
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
                            TextField(NSLocalizedString("Dosage", comment: ""), text: $dosage)
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
                        Text(NSLocalizedString("Schedule", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            // Frequency Type Picker
                            Picker(NSLocalizedString("Frequency", comment: ""), selection: $selectedFrequencyType) {
                                Text(NSLocalizedString("Daily", comment: "")).tag(FrequencyType.daily)
                                Text(NSLocalizedString("Weekly", comment: "")).tag(FrequencyType.weekly)
                                Text(NSLocalizedString("Interval (in days)", comment: "")).tag(FrequencyType.interval)
                                Text(NSLocalizedString("Monthly", comment: "")).tag(FrequencyType.monthly)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.bottom, 5)
                            
                            // Conditional Inputs based on Frequency Type
                            switch selectedFrequencyType {
                            case .weekly:
                                Text(NSLocalizedString("On these days:", comment: ""))
                                WeekdayMultiSelector(selectedDays: $weeklySelectedDays)
                                    .padding(.vertical, 5)
                            case .interval:
                                Stepper(String(format: NSLocalizedString("Every %d days", comment: "Stepper for interval days"), intervalDays), value: $intervalDays, in: 1...30)
                                DatePicker(NSLocalizedString("Starting From", comment: ""), selection: $intervalStartDate, displayedComponents: .date)
                            case .monthly:
                                Picker(NSLocalizedString("Day of the Month", comment: ""), selection: $monthlySelectedDay) {
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
                            
                            Text(NSLocalizedString("At these times:", comment: ""))
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
                                    Text(NSLocalizedString("Add Time", comment: ""))
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
                        Text(NSLocalizedString("Additional Details", comment: ""))
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
                        Text(NSLocalizedString("Save Medication", comment: ""))
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
            .navigationTitle(NSLocalizedString("Add Medication", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        saveMedication()
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
            Text(NSLocalizedString("Pill Appearance", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 20) {
                // Enhanced 3D Pill Preview
                VStack(spacing: 12) {
                    Text(NSLocalizedString("Preview", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .frame(height: 120)
                        
                        Enhanced3DPill(shape: mapToEnhanced3DShape(selectedShape), color: selectedColor)
                            .scaleEffect(1.2)
                    }
                    
                    Button(action: { showingShapePicker = true }) {
                        HStack {
                            Image(systemName: "pills.fill")
                            Text(NSLocalizedString("Change Shape", comment: ""))
                        }
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
                
                Divider()
                
                // Enhanced Color Selection
                VStack(spacing: 12) {
                    Text(NSLocalizedString("Color Selection", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    // Pharmaceutical color palette
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                        ForEach(pharmaceuticalColors, id: \.name) { colorInfo in
                            pharmaceuticalColorButton(color: colorInfo.color, name: colorInfo.name)
                        }
                    }
                    
                    // Custom color picker button
                    Button(action: { showingColorPicker = true }) {
                        HStack {
                            Image(systemName: "paintpalette.fill")
                            Text(NSLocalizedString("Custom Color", comment: ""))
                        }
                        .font(.system(size: userSettings.textSize.size - 1))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
        .sheet(isPresented: $showingShapePicker) {
            PillShapeView(selectedShape: $selectedShape)
                .environmentObject(userSettings)
        }
        .sheet(isPresented: $showingColorPicker) {
            EnhancedColorPickerView(selectedColor: $selectedColor)
                .environmentObject(userSettings)
        }
    }
    
    // Pharmaceutical-inspired color palette
    private let pharmaceuticalColors: [(name: String, color: Color)] = [
        ("White", Color(red: 0.98, green: 0.98, blue: 0.98)),
        ("Yellow", Color(red: 0.97, green: 0.85, blue: 0.3)),
        ("Orange", Color(red: 0.98, green: 0.6, blue: 0.3)),
        ("Pink", Color(red: 0.99, green: 0.75, blue: 0.8)),
        ("Red", Color(red: 0.95, green: 0.3, blue: 0.25)),
        ("Purple", Color(red: 0.6, green: 0.4, blue: 0.8)),
        ("Blue", Color(red: 0.35, green: 0.55, blue: 0.85)),
        ("Mint", Color(red: 0.75, green: 0.95, blue: 0.8)),
        ("Green", Color(red: 0.3, green: 0.75, blue: 0.4)),
        ("Brown", Color(red: 0.65, green: 0.45, blue: 0.25)),
        ("Gray", Color(red: 0.75, green: 0.75, blue: 0.75)),
        ("Cream", Color(red: 0.96, green: 0.93, blue: 0.86)),
        ("L.Blue", Color(red: 0.7, green: 0.85, blue: 0.98)),
        ("Black", Color(red: 0.25, green: 0.25, blue: 0.25))
    ]
    
    // Helper to map app PillShape to Enhanced3DPill.PillShape
    private func mapToEnhanced3DShape(_ shape: PillShape) -> Enhanced3DPill.PillShape {
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
    
    // Enhanced pharmaceutical color button
    private func pharmaceuticalColorButton(color: Color, name: String) -> some View {
        Button(action: {
            selectedColor = color
        }) {
            VStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(selectedColor.toHexString() == color.toHexString() ? Color.blue : Color.gray.opacity(0.3), lineWidth: selectedColor.toHexString() == color.toHexString() ? 3 : 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 1, y: 1)
                
                Text(name)
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

// Using ColorPickerView from ColorPickerView.swift
