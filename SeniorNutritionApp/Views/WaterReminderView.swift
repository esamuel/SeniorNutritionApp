import SwiftUI

struct WaterReminderView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var manager = WaterReminderManager()
    @State private var showingSettings = false
    @State private var showingCustomAmount = false
    @State private var customAmount: String = ""
    
    private let commonAmounts = [250, 500, 750, 1000]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.blue)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(manager.waterReminder.progressPercentage()))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: manager.waterReminder.progressPercentage())
                    
                    VStack {
                        Text("\(manager.waterReminder.totalIntake(for: Date()))ml")
                            .font(.title)
                            .bold()
                        Text("of \(manager.waterReminder.dailyGoal)ml")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 200, height: 200)
                .padding()
                
                // Quick Add Buttons
                HStack(spacing: 15) {
                    ForEach(commonAmounts, id: \.self) { amount in
                        Button(action: {
                            manager.addWaterIntake(amount)
                        }) {
                            Text("\(amount)ml")
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                
                // Custom Amount Button
                Button(action: {
                    showingCustomAmount = true
                }) {
                    Text(NSLocalizedString("Add Custom Amount", comment: ""))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Today's History
                List {
                    ForEach(manager.waterReminder.intakeHistory.filter {
                        Calendar.current.isDateInToday($0.timestamp)
                    }) { intake in
                        HStack {
                            Text("\(intake.amount)ml")
                            Spacer()
                            Text(intake.timestamp, style: .time)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        let todayIntakes = manager.waterReminder.intakeHistory.filter {
                            Calendar.current.isDateInToday($0.timestamp)
                        }
                        indexSet.forEach { index in
                            manager.removeWaterIntake(todayIntakes[index])
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Water Reminder", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                WaterReminderSettingsView(manager: manager)
            }
            .alert(NSLocalizedString("Add Custom Amount", comment: ""), isPresented: $showingCustomAmount) {
                TextField(NSLocalizedString("Amount in ml", comment: ""), text: $customAmount)
                    .keyboardType(.numberPad)
                Button(NSLocalizedString("Cancel", comment: ""), role: .cancel) { }
                Button(NSLocalizedString("Add", comment: "")) {
                    if let amount = Int(customAmount) {
                        manager.addWaterIntake(amount)
                    }
                    customAmount = ""
                }
            } message: {
                Text(NSLocalizedString("Enter the amount of water in milliliters", comment: ""))
            }
        }
    }
}

struct WaterReminderSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: WaterReminderManager
    @State private var dailyGoal: String
    @State private var selectedFrequency: ReminderFrequency
    @State private var customMinutes: String
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var isEnabled: Bool
    
    init(manager: WaterReminderManager) {
        self.manager = manager
        _dailyGoal = State(initialValue: String(manager.waterReminder.dailyGoal))
        _selectedFrequency = State(initialValue: manager.waterReminder.reminderFrequency)
        _customMinutes = State(initialValue: String(manager.waterReminder.customReminderMinutes ?? 60))
        _startTime = State(initialValue: manager.waterReminder.reminderStartTime.dateRepresentation)
        _endTime = State(initialValue: manager.waterReminder.reminderEndTime.dateRepresentation)
        _isEnabled = State(initialValue: manager.waterReminder.isEnabled)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Daily Goal", comment: ""))) {
                    TextField(NSLocalizedString("Daily Goal (ml)", comment: ""), text: $dailyGoal)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text(NSLocalizedString("Reminder Settings", comment: ""))) {
                    Toggle(NSLocalizedString("Enable Reminders", comment: ""), isOn: $isEnabled)
                    
                    Picker(NSLocalizedString("Frequency", comment: ""), selection: $selectedFrequency) {
                        ForEach(ReminderFrequency.allCases) { frequency in
                            Text(NSLocalizedString(frequency.rawValue, comment: "")).tag(frequency)
                        }
                    }
                    
                    if selectedFrequency == .custom {
                        TextField(NSLocalizedString("Custom Minutes", comment: ""), text: $customMinutes)
                            .keyboardType(.numberPad)
                    }
                    
                    DatePicker(NSLocalizedString("Start Time", comment: ""), selection: $startTime, displayedComponents: .hourAndMinute)
                        .datePickerLTR()
                    DatePicker(NSLocalizedString("End Time", comment: ""), selection: $endTime, displayedComponents: .hourAndMinute)
                        .datePickerLTR()
                }
            }
            .navigationTitle(NSLocalizedString("Settings", comment: ""))
            .navigationBarItems(
                leading: Button(NSLocalizedString("Cancel", comment: "")) {
                    dismiss()
                },
                trailing: Button(NSLocalizedString("Save", comment: "")) {
                    saveSettings()
                    dismiss()
                }
            )
        }
    }
    
    private func saveSettings() {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        manager.updateReminderSettings(
            dailyGoal: Int(dailyGoal),
            frequency: selectedFrequency,
            customMinutes: selectedFrequency == .custom ? Int(customMinutes) : nil,
            startTime: TimeOfDay(hour: startComponents.hour ?? 8, minute: startComponents.minute ?? 0),
            endTime: TimeOfDay(hour: endComponents.hour ?? 20, minute: endComponents.minute ?? 0),
            isEnabled: isEnabled
        )
    }
} 
