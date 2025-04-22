#if os(iOS)
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var fastingManager = FastingManager.shared
    @StateObject private var voiceManager = VoiceManager.shared
    @State private var showingHelpSheet = false
    
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fastingManager.setUserSettings(userSettings)
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
                    voiceManager.speak("Good \(timeOfDay), \(userSettings.userProfile?.firstName ?? userSettings.userName)")
                }) {
                    Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(.blue)
                }
            }
            
            if let profile = userSettings.userProfile {
                Text("Age: \(profile.age)")
                    .font(.system(size: userSettings.textSize.size))
            }
            
            Text("Today is \(formattedDate)")
                .font(.system(size: userSettings.textSize.size))
            
            if !upcomingMedications.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Upcoming Medications")
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .foregroundColor(.red)
                    
                    ForEach(upcomingMedications.prefix(3)) { medication in
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.red)
                            Text("\(medication.name) in \(timeUntil(medication.schedule[0]))")
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
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
            HStack {
                Text("Fasting Status")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    let status = "Current status: \(fastingManager.fastingState.title). \(formatRemainingTime()) remaining. \(calculatePercentageRemaining())% complete."
                    voiceManager.speak(status)
                }) {
                    Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(.blue)
                }
            }
            
            ZStack {
                // Complete background circle in gray
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 15))
                    .foregroundColor(Color(.systemGray5))
                
                // Fasting period (red)
                Circle()
                    .trim(from: 0, to: calculateFastingPortion())
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .butt))
                    .foregroundColor(fastingManager.fastingState == .fasting ? .red : .red.opacity(0.3))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut, value: fastingManager.fastingState)
                
                // Eating period (green)
                Circle()
                    .trim(from: calculateFastingPortion(), to: 1)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .butt))
                    .foregroundColor(fastingManager.fastingState == .eating ? .green : .green.opacity(0.3))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut, value: fastingManager.fastingState)
                
                // Progress indicator
                Circle()
                    .trim(from: 0, to: 0.03)
                    .stroke(style: StrokeStyle(lineWidth: 3))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: calculateProgressDegrees()))
                    .animation(.easeInOut, value: fastingManager.currentTime)
                
                VStack {
                    Text(fastingManager.fastingState.title)
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .foregroundColor(fastingManager.fastingState.color)
                    
                    Text(formatRemainingTime())
                        .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                    
                    Text("\(calculatePercentageRemaining())% Complete")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
            }
            .frame(height: 200)
            .padding()
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
                quickActionButton(icon: "plus.circle.fill", title: "Add Meal", action: {})
                quickActionButton(icon: "pill.fill", title: "Log Medicine", action: {})
                quickActionButton(icon: "phone.fill", title: "Get Help", action: {})
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
                
                ForEach(upcomingMedications) { medication in
                    upcomingItem(
                        icon: "pill.fill",
                        title: medication.name,
                        time: medication.schedule[0],
                        color: .blue,
                        subtitle: medication.takeWithFood ? "Take with food" : nil
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
    
    private var upcomingMedications: [Medication] {
        let now = Date()
        return userSettings.medications
            .filter { medication in
                medication.schedule.contains { $0 > now }
            }
            .sorted { medication1, medication2 in
                let nextDose1 = medication1.schedule.first { $0 > now } ?? medication1.schedule[0]
                let nextDose2 = medication2.schedule.first { $0 > now } ?? medication2.schedule[0]
                return nextDose1 < nextDose2
            }
    }
    
    private var nextMedication: Medication? {
        upcomingMedications.first
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
        let nextMealMinutes = calendar.component(.hour, from: fastingManager.nextMealTime) * 60 + calendar.component(.minute, from: fastingManager.nextMealTime)
        
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserSettings())
    }
}
#endif 