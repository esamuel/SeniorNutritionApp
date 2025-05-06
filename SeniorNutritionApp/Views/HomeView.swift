#if os(iOS)
import SwiftUI
import UserNotifications

struct HomeView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var mealManager: MealManager
    @StateObject private var fastingManager = FastingManager.shared
    @StateObject private var voiceManager = VoiceManager.shared
    @StateObject private var waterManager = WaterReminderManager()
    @State private var showingHelpSheet = false
    @State private var selectedMealType: MealType = .breakfast
    @State private var showingAddMeal = false
    @State private var showingWaterTracker = false
    @State private var showingEmergencyContacts = false
    @State private var showingHealthDashboard = false
    @State private var showingFastingTimer = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    welcomeSection
                    fastingStatusSection
                    quickActionsSection
                    todayScheduleSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        // Settings Button
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .accessibilityLabel("Open Settings")
                        
                        // Help Button (Existing)
                        Button(action: {
                            showingHelpSheet = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .accessibilityLabel("Get Help")
                    }
                }
            }
            .sheet(isPresented: $showingHelpSheet) {
                HelpGuideView()
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView(selectedMealType: $selectedMealType) { newMeal in
                    mealManager.addMeal(newMeal)
                    showingAddMeal = false
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fastingManager.setUserSettings(userSettings)
            scheduleMedicationNotifications()
        }
    }
    
    // Welcome section with user name and current status
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Good \(timeOfDay), \(userSettings.userProfile?.firstName ?? userSettings.userName)")
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    if voiceManager.isSpeaking {
                        voiceManager.stopSpeaking()
                    } else {
                        var speech = "Good \(timeOfDay), \(userSettings.userProfile?.firstName ?? userSettings.userName). "
                        speech += "Medication Reminders. "
                        if nextMedicationDoses.isEmpty {
                            speech += "No medications scheduled for today."
                        } else {
                            for pair in nextMedicationDoses.prefix(3) {
                                let medName = pair.medication.name
                                let timeString = timeUntil(pair.nextDose)
                                speech += "\(medName) in \(timeString). "
                            }
                        }
                        // Add fasting status (from the fasting circle)
                        speech += " And your fasting status: \(fastingManager.fastingState.title). "
                        speech += "Time remaining: \(formatRemainingTime()). "
                        speech += "\(calculatePercentageRemaining()) percent remain."
                        voiceManager.speak(speech, userSettings: userSettings)
                    }
                }) {
                    Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(.blue)
                }
            }
            
            if let profile = userSettings.userProfile {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                    if profile.age > 0 {
                        Text("Age: \(profile.age) years, \(profile.ageMonths) months")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.green)
                    } else {
                        Text("Age: \(profile.ageMonths) months")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.green)
                    }
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text("Today is \(formattedDate)")
                .font(.system(size: userSettings.textSize.size))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Medication Reminders")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.red)
                
                if nextMedicationDoses.isEmpty {
                    Text("No medications scheduled for today")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(nextMedicationDoses.prefix(3))) { pair in
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.red)
                            Text("\(pair.medication.name) in \(timeUntil(pair.nextDose))")
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Fasting status section
    private var fastingStatusSection: some View {
        VStack(spacing: 15) {
            // Timer Circle
            ZStack {
                // Complete background circle in gray
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20))
                    .foregroundColor(Color(.systemGray5))
                
                // Fasting period (red)
                Circle()
                    .trim(from: 0, to: calculateFastingPortion())
                    .stroke(fastingManager.fastingState == .fasting ? Color.red : Color.red.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                // Eating period (green)
                Circle()
                    .trim(from: calculateFastingPortion(), to: 1)
                    .stroke(fastingManager.fastingState == .eating ? Color.green : Color.green.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                // Center content
                VStack(spacing: 5) {
                    Text(fastingManager.fastingState.title)
                        .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                        .foregroundColor(fastingManager.fastingState.color)
                    
                    Text(formatRemainingTime())
                        .font(.system(size: userSettings.textSize.size + 12, weight: .bold))
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.5), value: fastingManager.currentTime)
                    
                    Text("\(calculatePercentageRemaining())% remain")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                    
                    Text(fastingManager.fastingState == .fasting ? "of fasting" : "of eating window")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
            }
            .frame(height: 250)
            .padding(.vertical)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Quick actions section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                // Add Medication button
                Button(action: {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        let medicationInputView = MedicationInputView()
                        let hostingController = UIHostingController(rootView: medicationInputView.environmentObject(userSettings))
                        window.rootViewController?.present(hostingController, animated: true)
                    }
                }) {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.55, green: 0.27, blue: 0.68))
                            .frame(width: 110, height: 110)
                            .overlay(
                                ZStack {
                                    // First pill - capsule at an angle
                                    Capsule()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 40)
                                        .rotationEffect(.degrees(30))
                                        .offset(x: -10, y: -5)
                                    
                                    // Second pill - round tablet
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 30)
                                        .offset(x: 12, y: 8)
                                }
                                .scaleEffect(1.4) // Scale up to match other icons
                            )
                        
                        Text("Add Medication")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(Color(red: 0.55, green: 0.27, blue: 0.68))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Track Water button
                Button(action: {
                    showingWaterTracker = true
                }) {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.0, green: 0.45, blue: 0.9))
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Track Water")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.9))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Log Meal button
                Button(action: {
                    showingAddMeal = true
                }) {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.25, green: 0.65, blue: 0.25))
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 42))
                                    .foregroundColor(.white)
                                    .offset(y: -3)
                            )
                        
                        Text("Log Meal")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(Color(red: 0.25, green: 0.65, blue: 0.25))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Fasting quick access button
                Button(action: {
                    showingFastingTimer = true
                }) {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.orange)
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "timer")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white)
                            )
                        Text("Fasting")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(Color.orange)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Emergency button
                Button(action: {
                    showingEmergencyContacts = true
                }) {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.9, green: 0.15, blue: 0.15))
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Emergency")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(Color(red: 0.9, green: 0.15, blue: 0.15))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Health quick access button
                Button(action: {
                    showingHealthDashboard = true
                }) {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.95, green: 0.45, blue: 0.15))
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "heart.text.square")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Health")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(Color(red: 0.95, green: 0.45, blue: 0.15))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .sheet(isPresented: $showingWaterTracker) {
            WaterReminderView()
                .environmentObject(userSettings)
        }
        .sheet(isPresented: $showingEmergencyContacts) {
            EmergencyContactsView()
                .environmentObject(userSettings)
        }
        .sheet(isPresented: $showingHealthDashboard) {
            HealthDataTabView()
        }
        .sheet(isPresented: $showingFastingTimer) {
            FastingTimerView()
                .environmentObject(userSettings)
        }
    }
    
    // Today's Schedule Section
    private var todayScheduleSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Today's Schedule")
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 15) {
                // Water reminder
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "drop.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        )
                    
                    VStack(alignment: .leading) {
                        Text("Drink Water")
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        
                        Text("7:00 PM")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .background(Circle().fill(Color.blue.opacity(0.1)))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                        )
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 1)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper for quick action buttons
    private func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 90, height: 90)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 38))
                            .foregroundColor(.white)
                    )
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // Helper computed properties
    private var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Morning"
        } else if hour < 17 {
            return "Afternoon"
        } else {
            return "Evening"
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
    
    // Helper method to format time until an event
    private func timeUntil(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date)
        
        if let hour = components.hour, let minute = components.minute {
            if hour > 0 {
                return "\(hour) hour\(hour == 1 ? "" : "s") \(minute) min"
            } else {
                return "\(minute) minute\(minute == 1 ? "" : "s")"
            }
        }
        
        return "Now"
    }
    
    private struct NextMedicationDose: Identifiable {
        let medication: Medication
        let nextDose: Date
        var id: UUID { medication.id }
    }
    
    private var nextMedicationDoses: [NextMedicationDose] {
        let calendar = Calendar.current
        let today = Date()
        
        // Get doses for today that are still upcoming
        let todayDoses = userSettings.medications.flatMap { med -> [NextMedicationDose] in
            // Check if due today
            guard med.isDue(on: today, calendar: calendar) else { return [] }
            
            // Find times today that are after 'now'
            return med.timesOfDay.compactMap { timeOfDay in
                if let potentialDose = calendar.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: 0, of: today),
                   potentialDose > today {
                    return NextMedicationDose(medication: med, nextDose: potentialDose)
                }
                return nil
            }
        }.sorted { $0.nextDose < $1.nextDose } // Sort today's upcoming doses
        
        if !todayDoses.isEmpty {
            return todayDoses
        } else {
            // If no more doses today, show the first dose for each medication for *tomorrow*
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            // Find the first dose time for each med scheduled for tomorrow
            return userSettings.medications.compactMap { med -> NextMedicationDose? in
                guard med.isDue(on: tomorrow, calendar: calendar), let firstTime = med.timesOfDay.first else {
                    return nil // Not due tomorrow or no times scheduled
                }
                
                // Construct the date for tomorrow's first dose
                if let doseDate = calendar.date(bySettingHour: firstTime.hour, minute: firstTime.minute, second: 0, of: tomorrow) {
                    return NextMedicationDose(medication: med, nextDose: doseDate)
                }
                return nil
            }.sorted { $0.nextDose < $1.nextDose } // Sort tomorrow's first doses
        }
    }
    
    // Helper methods
    private func calculateFastingPortion() -> Double {
        Double(userSettings.activeFastingProtocol.fastingHours) / 24.0
    }
    
    private func calculateRemainingTime() -> (hours: Int, minutes: Int, totalMinutes: Int) {
        let now = Date()
        let calendar = Calendar.current
        
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let lastMealMinutes = calendar.component(.hour, from: fastingManager.lastMealTime) * 60 + calendar.component(.minute, from: fastingManager.lastMealTime)
        
        // Calculate elapsed minutes since last meal
        var elapsedMinutes: Int
        if currentMinutes >= lastMealMinutes {
            elapsedMinutes = currentMinutes - lastMealMinutes
        } else {
            elapsedMinutes = (currentMinutes + 24 * 60) - lastMealMinutes
        }
        
        let fastingMinutes = userSettings.activeFastingProtocol.fastingHours * 60
        let eatingMinutes = userSettings.activeFastingProtocol.eatingHours * 60
        let totalCycleMinutes = fastingMinutes + eatingMinutes
        
        // Ensure totalCycleMinutes is not zero before modulo operation
        guard totalCycleMinutes > 0 else {
            print("Error: totalCycleMinutes is zero in HomeView, cannot calculate remaining time.")
            return (hours: 0, minutes: 0, totalMinutes: 0) // Return zero time
        }
        
        // Normalize elapsed minutes to current cycle
        elapsedMinutes = elapsedMinutes % totalCycleMinutes
        
        var remainingMinutes: Int
        if elapsedMinutes < fastingMinutes {
            // In fasting window
            remainingMinutes = fastingMinutes - elapsedMinutes
        } else {
            // In eating window
            remainingMinutes = totalCycleMinutes - elapsedMinutes
        }
        
        let hours = remainingMinutes / 60
        let minutes = remainingMinutes % 60
        
        return (hours, minutes, remainingMinutes)
    }
    
    private func formatRemainingTime() -> String {
        let remaining = calculateRemainingTime()
        return String(format: "%02d:%02d", remaining.hours, remaining.minutes)
    }
    
    private func calculatePercentageRemaining() -> Int {
        let remaining = calculateRemainingTime()
        let totalMinutes = fastingManager.fastingState == .fasting ? 
            userSettings.activeFastingProtocol.fastingHours * 60 : 
            userSettings.activeFastingProtocol.eatingHours * 60
        let percentageRemaining = (Double(remaining.totalMinutes) / Double(totalMinutes)) * 100
        return min(100, max(0, Int(round(percentageRemaining))))
    }
    
    private func calculateProgressDegrees() -> Double {
        let remaining = calculateRemainingTime()
        let totalMinutes = fastingManager.fastingState == .fasting ? 
            Double(userSettings.activeFastingProtocol.fastingHours * 60) : 
            Double(userSettings.activeFastingProtocol.eatingHours * 60)
        let progress = 1.0 - (Double(remaining.totalMinutes) / totalMinutes)
        
        let fastingPortion = Double(userSettings.activeFastingProtocol.fastingHours) / 24.0
        let fastingDegrees = 360.0 * fastingPortion
        let eatingDegrees = 360.0 - fastingDegrees
        
        let startAngle = -90.0
        let sweepAngle = fastingManager.fastingState == .fasting ? fastingDegrees : eatingDegrees
        
        return startAngle + (sweepAngle * progress)
    }
    
    private func scheduleMedicationNotifications() {
        print("Scheduling notifications for all medications...")
        // Clear potentially outdated UI state (if checkMedicationNotifications relies on it)
        // self.medicationNotifications = [:] // Consider if needed
        
        // Iterate through all medications and schedule the *next* notification for each
        for medication in userSettings.medications {
            scheduleNextNotification(for: medication) // Call the new helper function
        }
        print("Notification scheduling complete.")
    }
    
    // MARK: - Notification Scheduling
    
    /// Schedules the single, next upcoming notification for a given medication.
    /// Note: This cancels any previous notifications for the same medication ID.
    private func scheduleNextNotification(for medication: Medication) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        
        // 1. Find the absolute next due date/time for this medication
        var nextDoseDate: Date? = nil
        
        // Check today first
        if medication.isDue(on: now, calendar: calendar) {
            for timeOfDay in medication.timesOfDay {
                if let potentialDose = calendar.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: 0, of: now),
                   potentialDose > now {
                    nextDoseDate = potentialDose // Found the next dose today
                    break
                }
            }
        }
        
        // If no dose found for later today, check subsequent days
        if nextDoseDate == nil {
            var checkDate = calendar.date(byAdding: .day, value: 1, to: now)!
            for _ in 0..<30 { // Check up to 30 days ahead (adjust as needed)
                if medication.isDue(on: checkDate, calendar: calendar) {
                    if let firstTime = medication.timesOfDay.first,
                       let potentialDose = calendar.date(bySettingHour: firstTime.hour, minute: firstTime.minute, second: 0, of: checkDate) {
                        nextDoseDate = potentialDose // Found the next dose on a future day
                        break
                    }
                }
                checkDate = calendar.date(byAdding: .day, value: 1, to: checkDate)!
            }
        }
        
        // 2. If a next dose was found, schedule the notification (30 mins prior)
        guard let actualNextDose = nextDoseDate else {
            // No upcoming dose found within the check range, maybe remove existing notification?
            // Or handle based on specific app logic (e.g., log, do nothing)
            center.removePendingNotificationRequests(withIdentifiers: [medication.id.uuidString]) // Remove any old ones
            print("No upcoming dose found for \(medication.name) to schedule notification.")
            return
        }
        
        let notificationTime = calendar.date(byAdding: .minute, value: -30, to: actualNextDose) ?? actualNextDose
        
        // Ensure notification time is in the future
        guard notificationTime > now else {
            print("Calculated notification time for \(medication.name) is in the past.")
            // Maybe remove pending notification if it's now definitely passed
            center.removePendingNotificationRequests(withIdentifiers: [medication.id.uuidString])
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your \(medication.name) (\(medication.dosage))"
        content.sound = .default
        
        let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false) // Schedule only the single next dose
        
        // Use a consistent identifier for the medication's *next* notification
        let requestIdentifier = medication.id.uuidString
        
        // Add the request, overwriting any previous one with the same identifier
        center.add(UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)) { error in
            if let error = error {
                print("Error scheduling notification for \(medication.name): \(error.localizedDescription)")
            } else {
                print("Successfully scheduled next notification for \(medication.name) at \(notificationTime)")
            }
        }
    }
    
    // MARK: - Fasting Calculations
    @State private var fastingStartTime: Date?
    @State private var fastingEndTime: Date?
    
    // Help Guide View
    private struct HelpGuideView: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var userSettings: UserSettings
        @StateObject private var voiceManager = VoiceManager.shared
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 25) {
                        // App Overview Section
                        InfoSection(
                            title: "Welcome to Senior Nutrition App",
                            icon: "app.fill",
                            content: "Your personal assistant for managing fasting, nutrition, and medications. This guide will help you understand the main features of the app.",
                            onSpeak: {
                                voiceManager.speak("Welcome to Senior Nutrition App. Your personal assistant for managing fasting, nutrition, and medications. This guide will help you understand the main features of the app.")
                            }
                        )
                        
                        // Fasting Timer Section
                        InfoSection(
                            title: "Fasting Timer",
                            icon: "timer",
                            items: [
                                "Track your fasting and eating windows",
                                "Choose from different fasting protocols",
                                "View your progress in real-time",
                                "Get notifications when it's time to eat or fast"
                            ],
                            onSpeak: {
                                voiceManager.speak("Fasting Timer features: Track your fasting and eating windows, choose from different fasting protocols, view your progress in real-time, and get notifications when it's time to eat or fast.")
                            }
                        )
                        
                        // Nutrition Section
                        InfoSection(
                            title: "Nutrition Tracking",
                            icon: "fork.knife",
                            items: [
                                "Log your meals easily",
                                "Track your eating patterns",
                                "Get reminders for meal times",
                                "View nutrition history"
                            ]
                        )
                        
                        // Medication Section
                        InfoSection(
                            title: "Medication Management",
                            icon: "pill.fill",
                            items: [
                                "Set up medication schedules",
                                "Get timely reminders",
                                "Track medication compliance",
                                "Notes for food requirements"
                            ]
                        )
                        
                        // Quick Actions Section
                        InfoSection(
                            title: "Quick Actions",
                            icon: "bolt.fill",
                            items: [
                                "Add meals with one tap",
                                "Log medications quickly",
                                "Get immediate help when needed",
                                "Access emergency contacts"
                            ]
                        )
                        
                        // Tips Section
                        InfoSection(
                            title: "Important Tips",
                            icon: "lightbulb.fill",
                            items: [
                                "Always take medications as prescribed",
                                "Stay hydrated during fasting",
                                "Listen to your body's signals",
                                "Contact healthcare provider if unsure"
                            ]
                        )
                        
                        // Emergency Section
                        InfoSection(
                            title: "Emergency Information",
                            icon: "exclamationmark.triangle.fill",
                            content: "If you feel unwell during fasting, stop immediately and eat something. Contact your healthcare provider or emergency services if symptoms persist.",
                            isWarning: true,
                            onSpeak: {
                                voiceManager.speak("Emergency Information: If you feel unwell during fasting, stop immediately and eat something. Contact your healthcare provider or emergency services if symptoms persist.")
                            }
                        )
                        
                        // Support Section
                        InfoSection(
                            title: "Need More Help?",
                            icon: "questionmark.circle.fill",
                            content: "Contact our support team or your healthcare provider for personalized assistance."
                        )
                    }
                    .padding()
                }
                .navigationTitle("Help Guide")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            voiceManager.stopSpeaking()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    // Info Section Component
    private struct InfoSection: View {
        let title: String
        let icon: String
        var content: String? = nil
        var items: [String]? = nil
        var isWarning: Bool = false
        var onSpeak: (() -> Void)? = nil
        @EnvironmentObject private var userSettings: UserSettings
        @StateObject private var voiceManager = VoiceManager.shared
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(isWarning ? .red : .blue)
                    
                    Text(title)
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                    
                    Spacer()
                    
                    if let onSpeak = onSpeak {
                        Button(action: {
                            if voiceManager.isSpeaking {
                                voiceManager.stopSpeaking()
                            } else {
                                onSpeak()
                            }
                        }) {
                            Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if let content = content {
                    Text(content)
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(isWarning ? .red : .secondary)
                }
                
                if let items = items {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.blue)
                                    .padding(.top, 8)
                                
                                Text(item)
                                    .font(.system(size: userSettings.textSize.size - 2))
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 2)
        }
    }
    
    // Add this helper function for formatting time
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserSettings())
    }
}
#endif