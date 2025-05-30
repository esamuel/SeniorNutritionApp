#if os(iOS)
import SwiftUI
import UserNotifications
#if canImport(UIKit)
import UIKit
#endif

struct HomeView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var mealManager: MealManager
    @StateObject private var fastingManager = FastingManager.shared
    @StateObject private var voiceManager = VoiceManager.shared
    @StateObject private var waterManager = WaterReminderManager()
    @EnvironmentObject private var appointmentManager: AppointmentManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingHelpSheet = false
    @State private var selectedMealType: MealType = .breakfast
    @State private var showingAddMeal = false
    @State private var showingWaterTracker = false
    @State private var showingEmergencyContacts = false
    @State private var showingHealthDashboard = false
    @State private var showingFastingTimer = false
    @State private var showingAddAppointment = false
    @State private var appointmentToEdit: Appointment?
    @State private var healthTips: [HealthTip] = []
    private let healthTipsService = HealthTipsService.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    welcomeSection
                    fastingStatusSection
                    quickActionsSection
                    todayScheduleSection
                    HealthTipsCarousel(
                        tips: healthTips,
                        onViewMoreTapped: {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                let healthTipsView = HealthTipsView()
                                let hostingController = UIHostingController(rootView: 
                                    NavigationView {
                                        healthTipsView
                                    }
                                    .environmentObject(userSettings)
                                    .environmentObject(languageManager)
                                )
                                window.rootViewController?.present(hostingController, animated: true)
                            }
                        }
                    )
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Home", comment: ""))
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
                        .accessibilityLabel(NSLocalizedString("Open Settings", comment: ""))
                        
                        // Help Button (Existing)
                        Button(action: {
                            showingHelpSheet = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .accessibilityLabel(NSLocalizedString("Get Help", comment: ""))
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
            // Get random health tips from multiple relevant categories for the home screen
            healthTips = healthTipsService.getRandomTips(
                count: 3,
                categories: [.general, .nutrition, .fasting]
            )
        }
    }
    
    // Welcome section with user name and current status
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(String(format: NSLocalizedString("%@, %@", comment: ""), timeOfDay, userSettings.userProfile?.firstName ?? userSettings.userName))
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    if voiceManager.isSpeaking {
                        voiceManager.stopSpeaking()
                    } else {
                        var speech = String(format: NSLocalizedString("%@, %@. ", comment: ""), timeOfDay, userSettings.userProfile?.firstName ?? userSettings.userName)
                        speech += NSLocalizedString("Medication Reminders.", comment: "")
                        if nextMedicationDoses.isEmpty {
                            speech += NSLocalizedString("No medications scheduled for today.", comment: "")
                        } else {
                            for pair in nextMedicationDoses.prefix(3) {
                                let medName = pair.medication.name
                                let timeString = timeUntil(pair.nextDose)
                                speech += String(format: NSLocalizedString("%@ in %@.", comment: ""), medName, timeString)
                            }
                        }
                        speech += String(format: NSLocalizedString("And your fasting status: %@. ", comment: ""), fastingManager.fastingState.title)
                        speech += String(format: NSLocalizedString("Time remaining: %@. ", comment: ""), formatRemainingTime())
                        speech += String(format: NSLocalizedString("%d percent remain.", comment: ""), calculatePercentageRemaining())
                        voiceManager.speak(speech, userSettings: userSettings)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            
                        if voiceManager.isSpeaking {
                            Text(NSLocalizedString("Stop", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        } else {
                            Text(NSLocalizedString("Read", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
                .accessibilityLabel(NSLocalizedString("Read Welcome Summary", comment: ""))
                .accessibilityHint(NSLocalizedString("Reads out your greeting and medication reminders", comment: ""))
            }
            
            if let profile = userSettings.userProfile {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                    if profile.age > 0 {
                        Text(String(format: NSLocalizedString("Age: %d years, %d months", comment: ""), profile.age, profile.ageMonths))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.green)
                    } else {
                        Text(String(format: NSLocalizedString("Age: %d months", comment: ""), profile.ageMonths))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.green)
                    }
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text(String(format: NSLocalizedString("Today is %@", comment: ""), formattedDate))
                .font(.system(size: userSettings.textSize.size))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("Medication Reminders", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.red)
                
                if nextMedicationDoses.isEmpty {
                    Text(NSLocalizedString("No medications scheduled for today", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(nextMedicationDoses.prefix(3))) { pair in
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.red)
                            Text(String(format: NSLocalizedString("%@ in %@", comment: ""), pair.medication.name, timeUntil(pair.nextDose)))
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
                    
                    Text(fastingManager.fastingState == .fasting ? NSLocalizedString("of fasting", comment: "") : NSLocalizedString("of eating window", comment: ""))
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
            Text(NSLocalizedString("Quick Actions", comment: ""))
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
                        
                        Text(NSLocalizedString("Add Medication", comment: ""))
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
                        
                        Text(NSLocalizedString("Track Water", comment: ""))
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
                        
                        Text(NSLocalizedString("Log Meal", comment: ""))
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
                        Text(NSLocalizedString("Fasting", comment: ""))
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
                        
                        Text(NSLocalizedString("Emergency", comment: ""))
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
                        
                        Text(NSLocalizedString("Health", comment: ""))
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
            HStack {
                Text(NSLocalizedString("Today's Schedule", comment: ""))
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Spacer()
                
                // Add voice reading button for Today's Schedule
                Button(action: {
                    readTodaysSchedule()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            
                        if voiceManager.isSpeaking {
                            Text(NSLocalizedString("Stop", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        } else {
                            Text(NSLocalizedString("Read", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
                .accessibilityLabel(NSLocalizedString("Read Today's Schedule", comment: ""))
                .accessibilityHint(NSLocalizedString("Reads out your appointments and medications for today", comment: ""))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Upcoming Appointments Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                    
                    Text(NSLocalizedString("Upcoming Appointments", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    
                    Spacer()
                    
                    NavigationLink(destination: AppointmentsView()) {
                        Text(NSLocalizedString("See All", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.blue)
                    }
                }
                
                if appointmentManager.upcomingAppointments.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Text(NSLocalizedString("No upcoming appointments", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.gray)
                            
                            Button(NSLocalizedString("Add Appointment", comment: "")) {
                                showingAddAppointment = true
                            }
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 15)
                        Spacer()
                    }
                } else {
                    ForEach(appointmentManager.upcomingAppointments.prefix(2)) { appointment in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appointment.title)
                                    .font(.system(size: userSettings.textSize.size))
                                    .lineLimit(1)
                                
                                Text(formatAppointmentDate(appointment.date))
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text(daysUntilAppointment(appointment.date))
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(action: {
                                appointmentToEdit = appointment
                            }) {
                                Label(NSLocalizedString("Edit", comment: ""), systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                if let index = appointmentManager.upcomingAppointments.firstIndex(where: { $0.id == appointment.id }) {
                                    appointmentManager.deleteAppointment(at: IndexSet([index]), from: appointmentManager.upcomingAppointments)
                                }
                            }) {
                                Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                            }
                        }
                        .onLongPressGesture {
                            appointmentToEdit = appointment
                        }
                    }
                    
                    // Add Appointment button
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddAppointment = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .semibold))
                                Text(NSLocalizedString("Add Appointment", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                            }
                            .foregroundColor(.blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.top, 5)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .sheet(isPresented: $showingAddAppointment) {
            AddAppointmentView { newAppointment in
                appointmentManager.addAppointment(newAppointment)
            }
        }
        .sheet(item: $appointmentToEdit) { appointment in
            EditAppointmentView(appointment: appointment) { updatedAppointment in
                appointmentManager.updateAppointment(updatedAppointment)
            }
        }
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
            return NSLocalizedString("Good morning", comment: "")
        } else if hour < 17 {
            return NSLocalizedString("Good afternoon", comment: "")
        } else {
            return NSLocalizedString("Good evening", comment: "")
        }
    }
    
    private var formattedDate: String {
        // Use our new Date extension for proper localized formatting
        // This will respect the app's language setting (Hebrew, Spanish, French, etc.)
        return Date().localizedFullDateString()
    }
    
    // Helper method to format time until an event
    private func timeUntil(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date)
        
        if let hour = components.hour, let minute = components.minute {
            if hour > 0 {
                return "\(hour) hour\(hour == 1 ? NSLocalizedString("s", comment: "") : "") \(minute) min"
            } else {
                return "\(minute) minute\(minute == 1 ? NSLocalizedString("s", comment: "") : "")"
            }
        }
        
        return NSLocalizedString("Now", comment: "")
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
        content.title = NSLocalizedString("Medication Reminder", comment: "")
        content.body = NSLocalizedString("Time to take your \(medication.name) (\(medication.dosage))", comment: "")
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
                            title: NSLocalizedString("Welcome to Senior Nutrition App", comment: ""),
                            icon: "app.fill",
                            content: NSLocalizedString("Your comprehensive health companion for managing nutrition, fasting, medications, and wellness tracking. This guide will help you navigate the app's features effectively.", comment: ""),
                            onSpeak: {
                                voiceManager.speak(NSLocalizedString("Welcome to Senior Nutrition App. Your comprehensive health companion for managing nutrition, fasting, medications, and wellness tracking. This guide will help you navigate the app's features effectively.", comment: ""), userSettings: userSettings)
                            }
                        )
                        
                        // Fasting Timer Section
                        InfoSection(
                            title: NSLocalizedString("Fasting Timer", comment: ""),
                            icon: "timer",
                            items: [
                                NSLocalizedString("Advanced fasting protocol options for seniors", comment: ""),
                                NSLocalizedString("Real-time tracking with health safety indicators", comment: ""),
                                NSLocalizedString("Customizable fasting and eating windows", comment: ""),
                                NSLocalizedString("Integration with medication and meal schedules", comment: "")
                            ],
                            onSpeak: {
                                voiceManager.speak(NSLocalizedString("Fasting Timer features: Advanced fasting protocol options for seniors, real-time tracking with health safety indicators, customizable fasting and eating windows, and integration with medication and meal schedules.", comment: ""), userSettings: userSettings)
                            }
                        )
                        
                        // Nutrition Section
                        InfoSection(
                            title: NSLocalizedString("Nutrition Tracking", comment: ""),
                            icon: "fork.knife",
                            items: [
                                NSLocalizedString("Simplified meal logging with photos or voice input", comment: ""),
                                NSLocalizedString("Nutritional analysis with senior-specific recommendations", comment: ""),
                                NSLocalizedString("Customizable meal reminders and hydration tracking", comment: ""),
                                NSLocalizedString("Food database with barcode scanning capability", comment: "")
                            ]
                        )
                        
                        // Appointment Section
                        InfoSection(
                            title: NSLocalizedString("Appointment Management", comment: ""),
                            icon: "calendar",
                            items: [
                                NSLocalizedString("Easy scheduling and tracking of medical appointments", comment: ""),
                                NSLocalizedString("Automatic reminders with customizable advance notice", comment: ""),
                                NSLocalizedString("Location and provider information storage", comment: ""),
                                NSLocalizedString("Calendar integration and sharing with caregivers", comment: "")
                            ],
                            onSpeak: {
                                voiceManager.speak(NSLocalizedString("Appointment Management features: Easy scheduling and tracking of medical appointments, automatic reminders with customizable advance notice, location and provider information storage, and calendar integration and sharing with caregivers.", comment: ""), userSettings: userSettings)
                            }
                        )
                        
                        // Health Tracking Section
                        InfoSection(
                            title: NSLocalizedString("Health Monitoring", comment: ""),
                            icon: "heart.fill",
                            items: [
                                NSLocalizedString("Track vital signs including blood pressure, heart rate, and weight", comment: ""),
                                NSLocalizedString("Blood sugar monitoring with customizable target ranges", comment: ""),
                                NSLocalizedString("Visual data trends with weekly and monthly analysis", comment: ""),
                                NSLocalizedString("Health data export for healthcare provider review", comment: "")
                            ],
                            onSpeak: {
                                voiceManager.speak(NSLocalizedString("Health Monitoring features: Track vital signs including blood pressure, heart rate, and weight, blood sugar monitoring with customizable target ranges, visual data trends with weekly and monthly analysis, and health data export for healthcare provider review.", comment: ""), userSettings: userSettings)
                            }
                        )
                        
                        // Medication Section
                        InfoSection(
                            title: NSLocalizedString("Medication Management", comment: ""),
                            icon: "pill.fill",
                            items: [
                                NSLocalizedString("Visual medication identification system", comment: ""),
                                NSLocalizedString("Smart scheduling with fasting compatibility alerts", comment: ""),
                                NSLocalizedString("Refill reminders and medication history tracking", comment: ""),
                                NSLocalizedString("Food and timing requirement notifications", comment: "")
                            ]
                        )
                        
                        // Quick Actions Section
                        InfoSection(
                            title: NSLocalizedString("Quick Actions", comment: ""),
                            icon: "bolt.fill",
                            items: [
                                NSLocalizedString("One-tap meal and medication logging", comment: ""),
                                NSLocalizedString("Voice-activated commands for hands-free operation", comment: ""),
                                NSLocalizedString("Emergency contact access with location sharing", comment: ""),
                                NSLocalizedString("Instant health data recording and visualization", comment: "")
                            ]
                        )
                        
                        // Tips Section
                        InfoSection(
                            title: NSLocalizedString("Important Tips", comment: ""),
                            icon: "lightbulb.fill",
                            items: [
                                NSLocalizedString("Always consult healthcare providers before changing medication routines", comment: ""),
                                NSLocalizedString("Stay hydrated with at least 8 glasses of water daily, especially during fasting", comment: ""),
                                NSLocalizedString("Monitor for dizziness, weakness, or discomfort during fasting periods", comment: ""),
                                NSLocalizedString("Use the emergency override feature if you experience any concerning symptoms", comment: "")
                            ]
                        )
                        
                        // Emergency Section
                        InfoSection(
                            title: NSLocalizedString("Emergency Information", comment: ""),
                            icon: "exclamationmark.triangle.fill",
                            content: NSLocalizedString("If you experience dizziness, weakness, confusion, or any unusual symptoms during fasting, stop immediately and eat something with protein and carbohydrates. Contact your healthcare provider or emergency services if symptoms persist or worsen.", comment: ""),
                            isWarning: true,
                            onSpeak: {
                                voiceManager.speak(NSLocalizedString("Emergency Information: If you experience dizziness, weakness, confusion, or any unusual symptoms during fasting, stop immediately and eat something with protein and carbohydrates. Contact your healthcare provider or emergency services if symptoms persist or worsen.", comment: ""), userSettings: userSettings)
                            }
                        )
                        
                        // Support Section
                        InfoSection(
                            title: NSLocalizedString("Need More Help?", comment: ""),
                            icon: "questionmark.circle.fill",
                            content: NSLocalizedString("Contact our support team via the Help & Support section in the More tab, or use the voice assistance feature for immediate guidance.", comment: "")
                        )
                    }
                    .padding()
                }
                .navigationTitle(NSLocalizedString("Help Guide", comment: ""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(NSLocalizedString("Done", comment: "")) {
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
    
    // Add a new helper method for formatting appointment dates
    private func formatAppointmentDate(_ date: Date) -> String {
        // Use our new localized date formatter for proper display in all languages
        return date.localizedString(dateStyle: .medium, timeStyle: .short)
    }
    
    // Add a new helper method for calculating days until appointment
    private func daysUntilAppointment(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return NSLocalizedString("Today", comment: "")
        }
        
        if calendar.isDateInTomorrow(date) {
            return NSLocalizedString("Tomorrow", comment: "")
        }
        
        let components = calendar.dateComponents([.day], from: now, to: date)
        if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? NSLocalizedString("s", comment: "") : "")"
        } else {
            return NSLocalizedString("Past", comment: "")
        }
    }
    
    // Add a new helper method for reading today's schedule
    private func readTodaysSchedule() {
        if voiceManager.isSpeaking {
            voiceManager.stopSpeaking()
            return
        }
        
        var speechText = NSLocalizedString("Today's schedule: ", comment: "")
        
        if appointmentManager.upcomingAppointments.isEmpty {
            speechText += NSLocalizedString("You have no upcoming appointments.", comment: "")
        } else {
            speechText += NSLocalizedString("Upcoming appointments: ", comment: "")
            for appointment in appointmentManager.upcomingAppointments.prefix(3) {
                let daysUntil = daysUntilAppointment(appointment.date)
                speechText += "\(appointment.title), \(daysUntil). "
            }
        }
        
        if !nextMedicationDoses.isEmpty {
            speechText += NSLocalizedString("Today's medications: ", comment: "")
            for dose in nextMedicationDoses.prefix(3) {
                speechText += "\(dose.medication.name), \(timeUntil(dose.nextDose)). "
            }
        } else {
            speechText += NSLocalizedString("No medications scheduled for today.", comment: "")
        }
        
        voiceManager.speak(speechText, userSettings: userSettings)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserSettings())
    }
}
#endif