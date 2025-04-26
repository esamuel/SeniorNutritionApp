#if os(iOS)
import SwiftUI
import UserNotifications

struct HomeView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var mealManager: MealManager
    @StateObject private var fastingManager = FastingManager.shared
    @StateObject private var voiceManager = VoiceManager.shared
    @State private var showingHelpSheet = false
    @State private var medicationNotifications: [UUID: Date] = [:]
    @State private var selectedMealType: MealType = .breakfast
    @State private var showingAddMeal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    welcomeSection
                    fastingStatusSection
                    quickActionsSection
                    upcomingSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            checkMedicationNotifications()
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
                    voiceManager.speak(speech)
                }) {
                    Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(.blue)
                }
            }
            
            if let profile = userSettings.userProfile {
                Text("Age: \(profile.age) years")
                    .font(.system(size: userSettings.textSize.size))
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
                // Background circle
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 20)
                
                // Progress circle (completed portion in mint green)
                Circle()
                    .trim(from: 0, to: 1 - calculateFastingPortion())
                    .stroke(Color.mint, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                // Progress circle (remaining portion in red)
                Circle()
                    .trim(from: 1 - calculateFastingPortion(), to: 1)
                    .stroke(Color.red, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                // Center content
                VStack(spacing: 5) {
                    Text("Fasting")
                        .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text(formatRemainingTime())
                        .font(.system(size: userSettings.textSize.size + 12, weight: .bold))
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.5), value: fastingManager.currentTime)
                    
                    Text("\(calculatePercentageRemaining())% remain")
                        .font(.system(size: userSettings.textSize.size))
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
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                quickActionButton(
                    icon: "plus.circle.fill",
                    title: "Add Meal",
                    action: {
                        showingAddMeal = true
                    }
                )
                
                quickActionButton(
                    icon: "pill.fill",
                    title: "Log Medicine",
                    action: {
                        // Navigate to MedicationInputView
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let medicationInputView = MedicationInputView()
                            let hostingController = UIHostingController(rootView: medicationInputView.environmentObject(userSettings))
                            window.rootViewController?.present(hostingController, animated: true)
                        }
                    }
                )
                
                quickActionButton(
                    icon: "phone.fill",
                    title: "Get Help",
                    action: {
                        // Show help sheet
                        showingHelpSheet = true
                    }
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Upcoming section for meals and medications
    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Coming Up Next")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 15) {
                upcomingItem(
                    icon: "fork.knife",
                    title: "Next Meal Window",
                    time: fastingManager.nextMealTime,
                    color: .green
                )
                
                ForEach(nextMedicationDoses) { pair in
                    upcomingItem(
                        icon: "pill.fill",
                        title: pair.medication.name,
                        time: pair.nextDose,
                        color: .blue,
                        subtitle: pair.medication.takeWithFood ? "Take with food" : nil
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper for quick action buttons
    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100) // Fixed height for all buttons
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // Helper for upcoming items
    private func upcomingItem(icon: String, title: String, time: Date, color: Color, subtitle: String? = nil) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                
                Text(timeUntil(time))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
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
    
    private func nextOccurrencesToday(for medication: Medication) -> [NextMedicationDose] {
        let calendar = Calendar.current
        let now = Date()
        let midnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
        return medication.schedule.compactMap { time in
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
            if let todayDose = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: now),
               todayDose > now, todayDose < midnight {
                return NextMedicationDose(medication: medication, nextDose: todayDose)
            }
            return nil
        }
    }
    
    private func firstOccurrenceTomorrow(for medication: Medication) -> NextMedicationDose? {
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let tomorrowStart = calendar.startOfDay(for: tomorrow)
        return medication.schedule.compactMap { time in
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
            if let tomorrowDose = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: tomorrow) {
                return NextMedicationDose(medication: medication, nextDose: tomorrowDose)
            }
            return nil
        }.sorted { $0.nextDose < $1.nextDose }.first
    }
    
    private var nextMedicationDoses: [NextMedicationDose] {
        let todayDoses = userSettings.medications.flatMap { nextOccurrencesToday(for: $0) }
        if !todayDoses.isEmpty {
            return todayDoses.sorted { $0.nextDose < $1.nextDose }
        } else {
            // If no more doses today, show the first dose for each medication for tomorrow
            return userSettings.medications.compactMap { firstOccurrenceTomorrow(for: $0) }
                .sorted { $0.nextDose < $1.nextDose }
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
        let now = Date()
        let calendar = Calendar.current
        
        for medication in userSettings.medications {
            for scheduleTime in medication.schedule {
                if scheduleTime > now {
                    // Schedule notification 30 minutes before
                    let notificationTime = calendar.date(byAdding: .minute, value: -30, to: scheduleTime) ?? scheduleTime
                    
                    if notificationTime > now {
                        medicationNotifications[medication.id] = notificationTime
                        
                        // Schedule local notification
                        let content = UNMutableNotificationContent()
                        content.title = "Medication Reminder"
                        content.body = "Time to take \(medication.name) in 30 minutes"
                        content.sound = .default
                        
                        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: medication.id.uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("Error scheduling notification: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func checkMedicationNotifications() {
        let now = Date()
        for (id, notificationTime) in medicationNotifications {
            if now >= notificationTime {
                // Show alert or update UI
                medicationNotifications.removeValue(forKey: id)
            }
        }
    }
    
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