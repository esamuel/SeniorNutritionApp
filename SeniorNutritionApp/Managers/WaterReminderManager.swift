import Foundation
import UserNotifications
import SwiftUI

class WaterReminderManager: ObservableObject {
    @Published var waterReminder: WaterReminder {
        didSet {
            saveWaterReminder()
            updateReminders()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let waterReminderKey = "waterReminder"
    
    init() {
        if let data = userDefaults.data(forKey: waterReminderKey),
           let reminder = try? JSONDecoder().decode(WaterReminder.self, from: data) {
            self.waterReminder = reminder
        } else {
            self.waterReminder = WaterReminder()
        }
    }
    
    private func saveWaterReminder() {
        if let encoded = try? JSONEncoder().encode(waterReminder) {
            userDefaults.set(encoded, forKey: waterReminderKey)
        }
    }
    
    func addWaterIntake(_ amount: Int) {
        let intake = WaterIntake(amount: amount)
        waterReminder.intakeHistory.append(intake)
    }
    
    func removeWaterIntake(_ intake: WaterIntake) {
        waterReminder.intakeHistory.removeAll { $0.id == intake.id }
    }
    
    func updateReminderSettings(
        dailyGoal: Int? = nil,
        frequency: ReminderFrequency? = nil,
        customMinutes: Int? = nil,
        startTime: TimeOfDay? = nil,
        endTime: TimeOfDay? = nil,
        isEnabled: Bool? = nil
    ) {
        var updatedReminder = waterReminder
        
        if let dailyGoal = dailyGoal {
            updatedReminder.dailyGoal = dailyGoal
        }
        if let frequency = frequency {
            updatedReminder.reminderFrequency = frequency
        }
        if let customMinutes = customMinutes {
            updatedReminder.customReminderMinutes = customMinutes
        }
        if let startTime = startTime {
            updatedReminder.reminderStartTime = startTime
        }
        if let endTime = endTime {
            updatedReminder.reminderEndTime = endTime
        }
        if let isEnabled = isEnabled {
            updatedReminder.isEnabled = isEnabled
        }
        
        waterReminder = updatedReminder
    }
    
    private func updateReminders() {
        // Remove existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard waterReminder.isEnabled else { return }
        
        // Request notification permission if not already granted
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else { return }
            
            // Schedule new notifications
            self.scheduleReminders()
        }
    }
    
    private func scheduleReminders() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Time to Hydrate!", comment: "Water reminder notification title")
        content.body = NSLocalizedString("Don't forget to drink some water", comment: "Water reminder notification body")
        content.sound = .default
        content.categoryIdentifier = "WATER_REMINDER"
        
        // Improve Apple Watch notification appearance
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .active
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Create date components for start time
        var startComponents = DateComponents()
        startComponents.hour = waterReminder.reminderStartTime.hour
        startComponents.minute = waterReminder.reminderStartTime.minute
        
        // Create date components for end time
        var endComponents = DateComponents()
        endComponents.hour = waterReminder.reminderEndTime.hour
        endComponents.minute = waterReminder.reminderEndTime.minute
        
        // Calculate number of reminders needed
        let minutesBetweenReminders = waterReminder.reminderFrequency.minutes
        let startDate = calendar.date(from: startComponents) ?? now
        let endDate = calendar.date(from: endComponents) ?? now
        
        var currentDate = startDate
        var reminderCount = 0
        
        while currentDate <= endDate && reminderCount < 20 { // Limit to 20 reminders per day
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: calendar.dateComponents([.hour, .minute], from: currentDate),
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "waterReminder-\(reminderCount)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
            
            currentDate = calendar.date(byAdding: .minute, value: minutesBetweenReminders, to: currentDate) ?? currentDate
            reminderCount += 1
        }
    }
} 