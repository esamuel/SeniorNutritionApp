import SwiftUI
import Foundation
import UserNotifications

struct EditMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var speechManager = SpeechRecognitionManager.shared
    
    let medication: Medication
    @State private var medicationName: String
    @State private var selectedFrequencyType: FrequencyType
    @State private var timesOfDay: [TimeOfDay]
    @State private var weeklySelectedDays: Set<Weekday>
    @State private var intervalDays: Int
    @State private var intervalStartDate: Date
    @State private var monthlySelectedDay: Int
    @State private var takeWithFood: Bool
    @State private var notes: String
    @State private var showingLanguagePicker = false
    @State private var dosage: String
    @State private var selectedColor: Color
    @State private var selectedShape: PillShape
    @State private var showingColorPicker = false
    @State private var showingShapePicker = false
    
    init(medication: Medication) {
        self.medication = medication
        
        // Initialize common properties
        _medicationName = State(initialValue: medication.name)
        _timesOfDay = State(initialValue: medication.timesOfDay.sorted()) // Initialize and sort
        _takeWithFood = State(initialValue: medication.takeWithFood)
        _notes = State(initialValue: medication.notes ?? "")
        _dosage = State(initialValue: medication.dosage)
        _selectedColor = State(initialValue: medication.color ?? .blue)
        _selectedShape = State(initialValue: medication.shape ?? .capsule)
        
        // Initialize frequency-specific state based on medication.frequency
        switch medication.frequency {
        case .daily:
            _selectedFrequencyType = State(initialValue: .daily)
            _weeklySelectedDays = State(initialValue: [])
            _intervalDays = State(initialValue: 1) // Default
            _intervalStartDate = State(initialValue: Date())
            _monthlySelectedDay = State(initialValue: 1)
        case .weekly(let days):
            _selectedFrequencyType = State(initialValue: .weekly)
            _weeklySelectedDays = State(initialValue: Set(days))
            _intervalDays = State(initialValue: 1)
            _intervalStartDate = State(initialValue: Date())
            _monthlySelectedDay = State(initialValue: 1)
        case .interval(let days, let startDate):
            _selectedFrequencyType = State(initialValue: .interval)
            _weeklySelectedDays = State(initialValue: [])
            _intervalDays = State(initialValue: days)
            _intervalStartDate = State(initialValue: startDate)
            _monthlySelectedDay = State(initialValue: 1)
        case .monthly(let day):
            _selectedFrequencyType = State(initialValue: .monthly)
            _weeklySelectedDays = State(initialValue: [])
            _intervalDays = State(initialValue: 1)
            _intervalStartDate = State(initialValue: Date())
            _monthlySelectedDay = State(initialValue: day)
        }
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
                                EmptyView()
                            }
                            
                            Divider().padding(.vertical, 5)
                            
                            Text("Time(s) to Take Medication")
                                .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            // Time of Day Pickers
                            let times = timesOfDay // Use non-mutating collection
                            ForEach(times.indices, id: \.self) { index in
                                HStack {
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: { timesOfDay[index].dateRepresentation },
                                            set: { date in
                                                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                                                if let hour = components.hour, let minute = components.minute {
                                                    timesOfDay[index] = TimeOfDay(hour: hour, minute: minute)
                                                    timesOfDay.sort()
                                                }
                                            }
                                        ),
                                        displayedComponents: .hourAndMinute
                                    )
                                    .labelsHidden()
                                    .font(.system(size: userSettings.textSize.size))
                                    
                                    Spacer()
                                    
                                    Button("Edit") {
                                        // Edit time of day
                                    }
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.blue)
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
                    }
                    .padding(.horizontal)
                    
                    // Frequency Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Frequency")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            Picker("Frequency", selection: $selectedFrequencyType) {
                                Text("Daily").tag(FrequencyType.daily)
                                Text("Weekly").tag(FrequencyType.weekly)
                                Text("Interval").tag(FrequencyType.interval)
                                Text("Monthly").tag(FrequencyType.monthly)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 2)
                            
                            if selectedFrequencyType == .weekly {
                                WeekdayMultiSelector(selectedDays: $weeklySelectedDays)
                            } else if selectedFrequencyType == .interval {
                                HStack {
                                    Text("Every")
                                        .font(.system(size: userSettings.textSize.size))
                                    
                                    TextField("Interval Days", value: $intervalDays, formatter: NumberFormatter())
                                        .font(.system(size: userSettings.textSize.size))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Text("days")
                                        .font(.system(size: userSettings.textSize.size))
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(radius: 2)
                            } else if selectedFrequencyType == .monthly {
                                HStack {
                                    Text("On the")
                                        .font(.system(size: userSettings.textSize.size))
                                    
                                    TextField("Monthly Day", value: $monthlySelectedDay, formatter: NumberFormatter())
                                        .font(.system(size: userSettings.textSize.size))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Text("day of the month")
                                        .font(.system(size: userSettings.textSize.size))
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(radius: 2)
                            }
                        }
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
                                    // Direct shape rendering 
                                    Group {
                                        switch selectedShape {
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
                                            PillDiamondShape()
                                                .fill(selectedColor)
                                                .frame(width: 30, height: 30)
                                                .overlay(PillDiamondShape().stroke(Color.gray, lineWidth: 1))
                                        case .triangle:
                                            PillTriangleShape()
                                                .fill(selectedColor)
                                                .frame(width: 35, height: 30)
                                                .overlay(PillTriangleShape().stroke(Color.gray, lineWidth: 1))
                                        case .other:
                                            Text("?")
                                                .font(.system(size: 25))
                                                .foregroundColor(selectedColor)
                                        }
                                    }
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
                                        .environmentObject(userSettings)
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
                        Text("Save Changes")
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
                frequency: createScheduleDetails(),
                timesOfDay: timesOfDay.sorted(),
                takeWithFood: takeWithFood,
                notes: notes.isEmpty ? nil : notes,
                color: selectedColor,
                shape: selectedShape
            )
            
            // --- Add Notification Scheduling Logic --- 
            // TODO: Refactor this logic into a shared NotificationManager
            let updatedMedication = userSettings.medications[index]
            let center = UNUserNotificationCenter.current()
            let calendar = Calendar.current
            let now = Date()
            var nextDoseDate: Date? = nil
            
            // Find next dose date (simplified logic from HomeView.scheduleNextNotification)
            // Check today
            if updatedMedication.isDue(on: now, calendar: calendar) {
                for timeOfDay in updatedMedication.timesOfDay {
                    if let potentialDose = calendar.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: 0, of: now),
                       potentialDose > now {
                        nextDoseDate = potentialDose
                        break
                    }
                }
            }
            // Check future days if needed
            if nextDoseDate == nil {
                var checkDate = calendar.date(byAdding: .day, value: 1, to: now)!
                for _ in 0..<30 { // Look ahead 30 days
                    if updatedMedication.isDue(on: checkDate, calendar: calendar) {
                        if let firstTime = updatedMedication.timesOfDay.first,
                           let potentialDose = calendar.date(bySettingHour: firstTime.hour, minute: firstTime.minute, second: 0, of: checkDate) {
                            nextDoseDate = potentialDose
                            break
                        }
                    }
                    checkDate = calendar.date(byAdding: .day, value: 1, to: checkDate)!
                }
            }
            
            // Remove potentially old notification first
            center.removePendingNotificationRequests(withIdentifiers: [updatedMedication.id.uuidString])
            
            // Schedule the new notification if a date was found
            if let actualNextDose = nextDoseDate {
                let notificationTime = calendar.date(byAdding: .minute, value: -30, to: actualNextDose) ?? actualNextDose
                if notificationTime > now {
                    let content = UNMutableNotificationContent()
                    content.title = "Medication Reminder"
                    content.body = "Time to take your \(updatedMedication.name) (\(updatedMedication.dosage))"
                    content.sound = .default
                    
                    let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationTime)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
                    let requestIdentifier = updatedMedication.id.uuidString
                    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                    
                    center.add(request) { error in
                        if let error = error {
                            print("Error scheduling notification from Edit view for \(updatedMedication.name): \(error.localizedDescription)")
                        } else {
                            print("Successfully scheduled next notification from Edit view for \(updatedMedication.name) at \(notificationTime)")
                        }
                    }
                } else {
                    print("Calculated notification time from Edit view for \(updatedMedication.name) is in the past.")
                }
            } else {
                print("No upcoming dose found for \(updatedMedication.name) from Edit view to schedule notification.")
            }
            // --- End Notification Scheduling Logic ---
        }
        dismiss()
    }
    
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
    
    private var isSaveButtonDisabled: Bool {
        if medicationName.isEmpty || timesOfDay.isEmpty {
            return true
        }
        if selectedFrequencyType == .weekly && weeklySelectedDays.isEmpty {
            return true // Must select at least one day for weekly
        }
        // Add other validation as necessary (e.g., interval days > 0)
        return false
    }
    
    private func deleteTime(at offsets: IndexSet) {
        timesOfDay.remove(atOffsets: offsets)
        timesOfDay.sort()
    }
}

struct EditMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditMedicationView(medication: sampleMedication)
                .environmentObject(UserSettings())
        }
    }
    
    // Sample data for preview
    static var sampleMedication = Medication(
        name: "Sample Pill",
        dosage: "100mg",
        frequency: .weekly(days: [.monday, .wednesday, .friday]),
        timesOfDay: [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 20, minute: 0)],
        takeWithFood: true,
        notes: "Take with a full glass of water.",
        color: .blue,
        shape: .capsule
    )
}

// MARK: - Helper Views

/// A view for selecting multiple weekdays.
struct WeekdayMultiSelector: View {
    @Binding var selectedDays: Set<Weekday>
    let allDays = Weekday.allCases.sorted()
    @EnvironmentObject private var userSettings: UserSettings // Access text size

    var body: some View {
        HStack(spacing: 10) {
            ForEach(allDays) { day in
                Text(day.shortName)
                    .font(.system(size: userSettings.textSize.size - 4))
                    .padding(8)
                    .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                    .clipShape(Circle())
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
            }
        }
    }
}