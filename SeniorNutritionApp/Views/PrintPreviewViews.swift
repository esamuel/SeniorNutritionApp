import SwiftUI

// Print preview view for medication schedules
struct MedicationPrintPreview: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let userName = userSettings.userProfile?.firstName ?? userSettings.userName
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("medication_schedule_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(DateFormatter.localizedDateFormatter().string(from: Date()))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.black)
            
            // Content
            VStack(alignment: .leading, spacing: 15) {
                let medicationsToShow = userSettings.medications.isEmpty ? getSampleMedications() : userSettings.medications
                
                if userSettings.medications.isEmpty {
                    // Show note that this is sample data
                    Text(NSLocalizedString("Sample medication schedule for demonstration:", comment: ""))
                        .font(.system(size: 14))
                        .italic()
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }
                
                ForEach(medicationsToShow) { medication in
                    medicationCard(medication)
                }
            }
            
            Spacer()
            
            // Footer
            HStack {
                Spacer()
                Text(NSLocalizedString("printed_from_app", comment: ""))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 20)
        }
        .padding(20)
        .background(Color.white)
        .foregroundColor(.black)
    }
    
    // Provide sample medications for demonstration when user has no medications
    private func getSampleMedications() -> [Medication] {
        return [
            Medication(
                name: NSLocalizedString("Lisinopril", comment: "Sample medication name"),
                dosage: "10mg",
                frequency: .daily,
                timesOfDay: [TimeOfDay(hour: 8, minute: 0)],
                takeWithFood: true,
                notes: NSLocalizedString("Take with breakfast", comment: "Sample medication note"),
                color: .blue,
                shape: .capsule
            ),
            Medication(
                name: NSLocalizedString("Atorvastatin", comment: "Sample medication name"),
                dosage: "20mg",
                frequency: .daily,
                timesOfDay: [TimeOfDay(hour: 21, minute: 0)],
                takeWithFood: true,
                notes: NSLocalizedString("Take with dinner", comment: "Sample medication note"),
                color: .white,
                shape: .oval
            ),
            Medication(
                name: NSLocalizedString("Vitamin D3", comment: "Sample medication name"),
                dosage: "2000 IU",
                frequency: .daily,
                timesOfDay: [TimeOfDay(hour: 12, minute: 0)],
                takeWithFood: false,
                notes: NSLocalizedString("Take with lunch", comment: "Sample medication note"),
                color: .yellow,
                shape: .round
            )
        ]
    }
    
    private func medicationCard(_ medication: Medication) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Medication name and dosage
            HStack {
                Text(medication.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if !medication.dosage.isEmpty {
                    Text(medication.dosage)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
            }
            
            // Frequency
            HStack {
                Text(NSLocalizedString("frequency_label", comment: "") + ":")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                Text(localizedFrequency(medication.frequency))
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
            
            // Times
            if !medication.timesOfDay.isEmpty {
                HStack {
                    Text(NSLocalizedString("times_label", comment: "") + ":")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    Text(medication.timesOfDay.map { String(format: "%02d:%02d", $0.hour, $0.minute) }.joined(separator: ", "))
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
            
            // Notes
            if let notes = medication.notes, !notes.isEmpty {
                HStack(alignment: .top) {
                    Text(NSLocalizedString("notes_label", comment: "") + ":")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    Text(notes)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func localizedFrequency(_ frequency: ScheduleDetails) -> String {
        switch frequency {
        case .daily:
            return NSLocalizedString("Daily", comment: "")
        case .weekly(let days):
            if days.count == 7 {
                return NSLocalizedString("Daily", comment: "")
            } else if days.count == 1, let day = days.first {
                return String(format: NSLocalizedString("Weekly on %@", comment: ""), day.localizedName)
            } else {
                let dayNames = days.sorted { $0.rawValue < $1.rawValue }.map { $0.localizedName }
                return String(format: NSLocalizedString("Weekly on %@", comment: ""), dayNames.joined(separator: ", "))
            }
        case .interval(let days, _):
            return String(format: NSLocalizedString("Every %d days", comment: ""), days)
        case .monthly(let day):
            return String(format: NSLocalizedString("Monthly on day %d", comment: ""), day)
        }
    }
}

// Print preview view for fasting protocol
struct FastingProtocolPreview: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let userName = userSettings.userProfile?.firstName ?? userSettings.userName
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("fasting_guide_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(DateFormatter.localizedDateFormatter().string(from: Date()))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.black)
            
            // Protocol Info
            VStack(alignment: .leading, spacing: 15) {
                Text(NSLocalizedString("selected_protocol_label", comment: "") + ": " + userSettings.activeFastingProtocol.localizedTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(userSettings.activeFastingProtocol.localizedDescription)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(15)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
            
            // Benefits
            VStack(alignment: .leading, spacing: 10) {
                Text(NSLocalizedString("fasting_benefits_title", comment: ""))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                ForEach(userSettings.activeFastingProtocol.benefits, id: \.self) { benefit in
                    if !benefit.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Text(benefit)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(15)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
            
            // Guidelines
            VStack(alignment: .leading, spacing: 10) {
                Text(NSLocalizedString("fasting_guidelines_title", comment: ""))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                ForEach(userSettings.activeFastingProtocol.guidelines, id: \.self) { guideline in
                    if !guideline.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Text(guideline)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(15)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
            
            Spacer()
            
            // Footer
            HStack {
                Spacer()
                Text(NSLocalizedString("printed_from_app", comment: ""))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 20)
        }
        .padding(20)
        .background(Color.white)
        .foregroundColor(.black)
    }
}

// Print preview view for meal suggestions
struct MealSuggestionsPreview: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let userName = userSettings.userProfile?.firstName ?? userSettings.userName
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("meal_suggestions_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(DateFormatter.localizedDateFormatter().string(from: Date()))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.black)
            
            // Meal Categories
            VStack(alignment: .leading, spacing: 20) {
                mealCategory(
                    title: NSLocalizedString("breakfast_ideas_title", comment: ""),
                    items: [
                        NSLocalizedString("breakfast_suggestion_1", comment: ""),
                        NSLocalizedString("breakfast_suggestion_2", comment: ""),
                        NSLocalizedString("breakfast_suggestion_3", comment: ""),
                        NSLocalizedString("breakfast_suggestion_4", comment: "")
                    ]
                )
                
                mealCategory(
                    title: NSLocalizedString("lunch_ideas_title", comment: ""),
                    items: [
                        NSLocalizedString("lunch_suggestion_1", comment: ""),
                        NSLocalizedString("lunch_suggestion_2", comment: ""),
                        NSLocalizedString("lunch_suggestion_3", comment: ""),
                        NSLocalizedString("lunch_suggestion_4", comment: "")
                    ]
                )
                
                mealCategory(
                    title: NSLocalizedString("dinner_ideas_title", comment: ""),
                    items: [
                        NSLocalizedString("dinner_suggestion_1", comment: ""),
                        NSLocalizedString("dinner_suggestion_2", comment: ""),
                        NSLocalizedString("dinner_suggestion_3", comment: ""),
                        NSLocalizedString("dinner_suggestion_4", comment: "")
                    ]
                )
                
                mealCategory(
                    title: NSLocalizedString("snack_ideas_title", comment: ""),
                    items: [
                        NSLocalizedString("snack_suggestion_1", comment: ""),
                        NSLocalizedString("snack_suggestion_2", comment: ""),
                        NSLocalizedString("snack_suggestion_3", comment: ""),
                        NSLocalizedString("snack_suggestion_4", comment: "")
                    ]
                )
            }
            
            Spacer()
            
            // Footer
            HStack {
                Spacer()
                Text(NSLocalizedString("printed_from_app", comment: ""))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 20)
        }
        .padding(20)
        .background(Color.white)
        .foregroundColor(.black)
    }
    
    private func mealCategory(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            ForEach(items.filter { !$0.isEmpty }, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text(item)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
    }
}

// Print preview view for app instructions
struct AppInstructionsPreview: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let userName = userSettings.userProfile?.firstName ?? userSettings.userName
        
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("app_instructions_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(DateFormatter.localizedDateFormatter().string(from: Date()))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.black)
            
            // Instruction Categories
            VStack(alignment: .leading, spacing: 20) {
                instructionCategory(
                    title: NSLocalizedString("medication_management_title", comment: ""),
                    steps: [
                        NSLocalizedString("medication_step_1", comment: ""),
                        NSLocalizedString("medication_step_2", comment: ""),
                        NSLocalizedString("medication_step_3", comment: ""),
                        NSLocalizedString("medication_step_4", comment: ""),
                        NSLocalizedString("medication_step_5", comment: "")
                    ]
                )
                
                instructionCategory(
                    title: NSLocalizedString("fasting_timer_title", comment: ""),
                    steps: [
                        NSLocalizedString("fasting_step_1", comment: ""),
                        NSLocalizedString("fasting_step_2", comment: ""),
                        NSLocalizedString("fasting_step_3", comment: ""),
                        NSLocalizedString("fasting_step_4", comment: ""),
                        NSLocalizedString("fasting_step_5", comment: "")
                    ]
                )
                
                instructionCategory(
                    title: NSLocalizedString("nutrition_tracking_title", comment: ""),
                    steps: [
                        NSLocalizedString("nutrition_step_1", comment: ""),
                        NSLocalizedString("nutrition_step_2", comment: ""),
                        NSLocalizedString("nutrition_step_3", comment: ""),
                        NSLocalizedString("nutrition_step_4", comment: ""),
                        NSLocalizedString("nutrition_step_5", comment: "")
                    ]
                )
                
                instructionCategory(
                    title: NSLocalizedString("app_settings_title", comment: ""),
                    steps: [
                        NSLocalizedString("settings_step_1", comment: ""),
                        NSLocalizedString("settings_step_2", comment: ""),
                        NSLocalizedString("settings_step_3", comment: ""),
                        NSLocalizedString("settings_step_4", comment: ""),
                        NSLocalizedString("settings_step_5", comment: "")
                    ]
                )
            }
            
            Spacer()
            
            // Footer
            HStack {
                Spacer()
                Text(NSLocalizedString("printed_from_app", comment: ""))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 20)
        }
        .padding(20)
        .background(Color.white)
        .foregroundColor(.black)
    }
    
    private func instructionCategory(title: String, steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            ForEach(Array(steps.filter { !$0.isEmpty }.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(index + 1).")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 20, alignment: .leading)
                    Text(step)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
    }
}

#if DEBUG
struct PrintPreviewViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MedicationPrintPreview()
                .environmentObject(UserSettings())
            
            FastingProtocolPreview()
                .environmentObject(UserSettings())
            
            MealSuggestionsPreview()
                .environmentObject(UserSettings())
            
            AppInstructionsPreview()
                .environmentObject(UserSettings())
        }
    }
}
#endif 