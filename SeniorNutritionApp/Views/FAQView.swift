import SwiftUI

struct FAQView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var searchText = ""
    @State private var expandedQuestionID: UUID? = nil

    private let allFaqItems: [FAQItem] = [
        // General App Questions
        FAQItem(questionKey: "faq_general_what_is_app", answerKey: "faq_general_what_is_app_answer"),
        FAQItem(questionKey: "faq_general_who_is_for", answerKey: "faq_general_who_is_for_answer"),
        FAQItem(questionKey: "faq_general_is_free", answerKey: "faq_general_is_free_answer"),
        FAQItem(questionKey: "faq_general_data_privacy", answerKey: "faq_general_data_privacy_answer"),
        
        // Getting Started
        FAQItem(questionKey: "faq_startup_how_begin", answerKey: "faq_startup_how_begin_answer"),
        FAQItem(questionKey: "faq_startup_profile_setup", answerKey: "faq_startup_profile_setup_answer"),
        FAQItem(questionKey: "faq_startup_language_change", answerKey: "faq_startup_language_change_answer"),
        FAQItem(questionKey: "faq_startup_data_backup", answerKey: "faq_startup_data_backup_answer"),
        
        // Nutrition Tracking
        FAQItem(questionKey: "faq_nutrition_how_track", answerKey: "faq_nutrition_how_track_answer"),
        FAQItem(questionKey: "faq_nutrition_food_database", answerKey: "faq_nutrition_food_database_answer"),
        FAQItem(questionKey: "faq_nutrition_custom_foods", answerKey: "faq_nutrition_custom_foods_answer"),
        FAQItem(questionKey: "faq_nutrition_portion_sizes", answerKey: "faq_nutrition_portion_sizes_answer"),
        FAQItem(questionKey: "faq_nutrition_goals_setting", answerKey: "faq_nutrition_goals_setting_answer"),
        
        // Fasting Timer
        FAQItem(questionKey: "faq_fasting_what_is", answerKey: "faq_fasting_what_is_answer"),
        FAQItem(questionKey: "faq_fasting_safe", answerKey: "faq_fasting_safe_answer"),
        FAQItem(questionKey: "faq_fasting_protocols", answerKey: "faq_fasting_protocols_answer"),
        FAQItem(questionKey: "faq_fasting_medications", answerKey: "faq_fasting_medications_answer"),
        FAQItem(questionKey: "faq_fasting_emergency_stop", answerKey: "faq_fasting_emergency_stop_answer"),
        
        // Water Tracking
        FAQItem(questionKey: "faq_water_how_much", answerKey: "faq_water_how_much_answer"),
        FAQItem(questionKey: "faq_water_reminders", answerKey: "faq_water_reminders_answer"),
        FAQItem(questionKey: "faq_water_other_drinks", answerKey: "faq_water_other_drinks_answer"),
        
        // Medication Management
        FAQItem(questionKey: "faq_medication_add", answerKey: "faq_medication_add_answer"),
        FAQItem(questionKey: "faq_medication_reminders", answerKey: "faq_medication_reminders_answer"),
        FAQItem(questionKey: "faq_medication_missed", answerKey: "faq_medication_missed_answer"),
        FAQItem(questionKey: "faq_medication_refills", answerKey: "faq_medication_refills_answer"),
        FAQItem(questionKey: "faq_medication_share", answerKey: "faq_medication_share_answer"),
        
        // Health Data
        FAQItem(questionKey: "faq_health_what_track", answerKey: "faq_health_what_track_answer"),
        FAQItem(questionKey: "faq_health_accuracy", answerKey: "faq_health_accuracy_answer"),
        FAQItem(questionKey: "faq_health_export", answerKey: "faq_health_export_answer"),
        FAQItem(questionKey: "faq_health_doctor_share", answerKey: "faq_health_doctor_share_answer"),
        
        // Appointments
        FAQItem(questionKey: "faq_appointments_add", answerKey: "faq_appointments_add_answer"),
        FAQItem(questionKey: "faq_appointments_reminders", answerKey: "faq_appointments_reminders_answer"),
        FAQItem(questionKey: "faq_appointments_notes", answerKey: "faq_appointments_notes_answer"),
        
        // Accessibility
        FAQItem(questionKey: "faq_accessibility_text_size", answerKey: "faq_accessibility_text_size_answer"),
        FAQItem(questionKey: "faq_accessibility_voice", answerKey: "faq_accessibility_voice_answer"),
        FAQItem(questionKey: "faq_accessibility_contrast", answerKey: "faq_accessibility_contrast_answer"),
        
        // Technical Issues
        FAQItem(questionKey: "faq_technical_notifications", answerKey: "faq_technical_notifications_answer"),
        FAQItem(questionKey: "faq_technical_data_loss", answerKey: "faq_technical_data_loss_answer"),
        FAQItem(questionKey: "faq_technical_app_crash", answerKey: "faq_technical_app_crash_answer"),
        FAQItem(questionKey: "faq_technical_sync_issues", answerKey: "faq_technical_sync_issues_answer"),
        
        // Support
        FAQItem(questionKey: "faq_support_contact", answerKey: "faq_support_contact_answer"),
        FAQItem(questionKey: "faq_support_video_chat", answerKey: "faq_support_video_chat_answer"),
        FAQItem(questionKey: "faq_support_feature_request", answerKey: "faq_support_feature_request_answer"),
        
        // Emergency
        FAQItem(questionKey: "faq_emergency_number", answerKey: "faq_emergency_number_answer"),
        FAQItem(questionKey: "faq_emergency_contacts", answerKey: "faq_emergency_contacts_answer"),
        FAQItem(questionKey: "faq_emergency_medical", answerKey: "faq_emergency_medical_answer")
    ]
    
    private var filteredFaqItems: [FAQItem] {
        if searchText.isEmpty {
            return allFaqItems
        }
        return allFaqItems.filter { item in
            let question = NSLocalizedString(item.questionKey, comment: "").lowercased()
            let answer = NSLocalizedString(item.answerKey, comment: "").lowercased()
            return question.contains(searchText.lowercased()) || answer.contains(searchText.lowercased())
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: NSLocalizedString("Search FAQs...", comment: "Search FAQs"))
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredFaqItems) { item in
                        faqItemView(item)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            contactSupportSection
        }
        .navigationTitle(NSLocalizedString("Frequently Asked Questions", comment: "FAQ"))
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func faqItemView(_ item: FAQItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeInOut) {
                    expandedQuestionID = (expandedQuestionID == item.id) ? nil : item.id
                }
            }) {
                HStack {
                    Text(NSLocalizedString(item.questionKey, comment: ""))
                        .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: expandedQuestionID == item.id ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            if expandedQuestionID == item.id {
                Text(NSLocalizedString(item.answerKey, comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var contactSupportSection: some View {
        VStack {
            Text(NSLocalizedString("Can't find an answer?", comment: "Can't find an answer?"))
                .font(.system(size: userSettings.textSize.size - 1))
            if let url = URL(string: "mailto:\(AppConfig.Support.email)") {
                Link(NSLocalizedString("Contact Support", comment: "Contact Support"), destination: url)
                    .font(.system(size: userSettings.textSize.size - 1, weight: .bold))
            }
        }
        .padding()
    }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let questionKey: String
    let answerKey: String
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FAQView()
                .environmentObject(UserSettings())
        }
    }
}
