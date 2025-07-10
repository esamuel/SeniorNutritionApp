import Foundation
import UserNotifications
import SwiftUI

@MainActor
class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func updateAllNotifications(userSettings: UserSettings) {
        // Cancel all relevant notifications first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if userSettings.medicationRemindersEnabled {
            scheduleMedicationReminders(userSettings: userSettings)
        }
        if userSettings.mealWindowRemindersEnabled {
            scheduleMealWindowReminders(userSettings: userSettings)
        }
        if userSettings.fastingRemindersEnabled {
            scheduleFastingReminders(userSettings: userSettings)
        }
        if userSettings.dailyTipsEnabled {
            scheduleDailyTips(userSettings: userSettings)
        }
    }
    
    // MARK: - Medication Reminders
    private func scheduleMedicationReminders(userSettings: UserSettings) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        let leadTime = userSettings.medicationReminderLeadTime
        let sound = notificationSound(for: userSettings.notificationStyle)
        
        for medication in userSettings.medications {
            for timeOfDay in medication.timesOfDay {
                // Find next dose date
                var nextDoseDate: Date? = nil
                if medication.isDue(on: now, calendar: calendar) {
                    if let potentialDose = calendar.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: 0, of: now),
                       potentialDose > now {
                        nextDoseDate = potentialDose
                    }
                }
                if nextDoseDate == nil {
                    var checkDate = calendar.date(byAdding: .day, value: 1, to: now)!
                    for _ in 0..<30 {
                        if medication.isDue(on: checkDate, calendar: calendar) {
                            if let firstTime = calendar.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: 0, of: checkDate) {
                                nextDoseDate = firstTime
                                break
                            }
                        }
                        checkDate = calendar.date(byAdding: .day, value: 1, to: checkDate)!
                    }
                }
                guard let actualNextDose = nextDoseDate else { continue }
                let notificationTime = calendar.date(byAdding: .minute, value: -leadTime, to: actualNextDose) ?? actualNextDose
                guard notificationTime > now else { continue }
                let content = UNMutableNotificationContent()
                content.title = "Medication Reminder"
                content.body = "Time to take your \(medication.name) (\(medication.dosage))"
                content.sound = sound
                content.categoryIdentifier = "MEDICATION_REMINDER"
                
                // Improve Apple Watch notification appearance
                if #available(iOS 15.0, *) {
                    content.interruptionLevel = .active
                }
                let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
                let requestIdentifier = medication.id.uuidString + "-" + String(timeOfDay.hour) + ":" + String(timeOfDay.minute)
                let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
    
    // MARK: - Meal Window Reminders
    private func scheduleMealWindowReminders(userSettings: UserSettings) {
        let fastingManager = FastingManager.shared
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        let sound = notificationSound(for: userSettings.notificationStyle)
        // Eating window start
        let eatingStart = fastingManager.lastMealTime
        let eatingEnd = fastingManager.nextMealTime
        // "You can eat now"
        if eatingStart > now {
            let content = UNMutableNotificationContent()
            content.title = "Meal Window"
            content.body = "You can eat now."
            content.sound = sound
            content.categoryIdentifier = "MEAL_WINDOW"
            
            // Improve Apple Watch notification appearance
            if #available(iOS 15.0, *) {
                content.interruptionLevel = .active
            }
            let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eatingStart)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "mealWindowStart", content: content, trigger: trigger)
            center.add(request)
        }
        // "It's time to stop eating"
        if eatingEnd > now {
            let content = UNMutableNotificationContent()
            content.title = "Meal Window"
            content.body = "It's time to stop eating."
            content.sound = sound
            content.categoryIdentifier = "MEAL_WINDOW"
            
            // Improve Apple Watch notification appearance
            if #available(iOS 15.0, *) {
                content.interruptionLevel = .active
            }
            let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eatingEnd)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "mealWindowEnd", content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    // MARK: - Fasting Reminders
    private func scheduleFastingReminders(userSettings: UserSettings) {
        let fastingManager = FastingManager.shared
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        let sound = notificationSound(for: userSettings.notificationStyle)
        // 10 min before fasting starts (eating end)
        let fastingStart = calendar.date(byAdding: .minute, value: -10, to: fastingManager.nextMealTime) ?? fastingManager.nextMealTime
        if fastingStart > now {
            let content = UNMutableNotificationContent()
            content.title = "Fasting Reminder"
            content.body = "Fasting will start in 10 minutes."
            content.sound = sound
            content.categoryIdentifier = "FASTING_REMINDER"
            
            // Improve Apple Watch notification appearance
            if #available(iOS 15.0, *) {
                content.interruptionLevel = .active
            }
            let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fastingStart)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "fastingStartReminder", content: content, trigger: trigger)
            center.add(request)
        }
        // 10 min before fasting ends (eating start)
        let fastingEnd = calendar.date(byAdding: .minute, value: -10, to: fastingManager.lastMealTime) ?? fastingManager.lastMealTime
        if fastingEnd > now {
            let content = UNMutableNotificationContent()
            content.title = "Fasting Reminder"
            content.body = "Fasting will end in 10 minutes."
            content.sound = sound
            content.categoryIdentifier = "FASTING_REMINDER"
            
            // Improve Apple Watch notification appearance
            if #available(iOS 15.0, *) {
                content.interruptionLevel = .active
            }
            let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fastingEnd)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "fastingEndReminder", content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    // MARK: - Daily Tips
    private func scheduleDailyTips(userSettings: UserSettings) {
        let center = UNUserNotificationCenter.current()
        let sound = notificationSound(for: userSettings.notificationStyle)
        let tips = [
            "Stay hydrated! Drink water throughout the day.",
            "Include fruits and vegetables in your meals.",
            "Take a short walk after meals for better digestion.",
            "Remember to take your medications on time.",
            "Get enough sleep for better health.",
            "Practice mindful eating."
        ]
        let randomTip = tips.randomElement() ?? "Stay healthy!"
        let content = UNMutableNotificationContent()
        content.title = "Daily Health Tip"
        content.body = randomTip
        content.sound = sound
        content.categoryIdentifier = "DAILY_TIP"
        
        // Improve Apple Watch notification appearance
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .active
        }
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyHealthTip", content: content, trigger: trigger)
        center.add(request)
    }
    
    // MARK: - Notification Sound
    private func notificationSound(for style: NotificationStyle) -> UNNotificationSound? {
        switch style {
        case .regular:
            return .default
        case .gentle:
            return nil // No sound
        case .urgent:
            return .defaultCritical
        }
    }
} 