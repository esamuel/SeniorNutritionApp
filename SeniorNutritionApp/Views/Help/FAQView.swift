import SwiftUI
import Foundation

struct FAQView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var expandedQuestions = Set<Int>()
    
    // FAQ items
    private let faqItems = [
        FAQItem(
            question: "How do I track my water intake?",
            answer: "To track your water intake, go to the Water tab at the bottom of the screen. Tap the '+' button to add water. You can select different amounts and the app will track your progress toward your daily goal."
        ),
        FAQItem(
            question: "How do I set up medication reminders?",
            answer: "Go to the More tab, then select Medications. Tap the '+' button to add a new medication. Enter the details including name, dosage, and schedule. Make sure to enable notifications in your device settings to receive reminders."
        ),
        FAQItem(
            question: "Can I customize my nutrition goals?",
            answer: "Yes! Go to the Nutrition tab, then tap the settings icon in the top corner. Select 'Nutrition Goals' to customize your calorie, protein, carbohydrate, and fat targets based on your specific needs."
        ),
        FAQItem(
            question: "How do I start a fasting timer?",
            answer: "Navigate to the Fast tab, select your preferred fasting protocol (like 16:8 or 18:6), and tap 'Start Fast'. The timer will begin counting down until your eating window. You'll receive notifications at key milestones during your fast."
        ),
        FAQItem(
            question: "How can I change the text size in the app?",
            answer: "Go to the More tab, then select Settings. Under the Accessibility section, you'll find a Text Size option where you can adjust the size to make reading easier."
        ),
        FAQItem(
            question: "Can I print my medication schedule?",
            answer: "Yes. Go to the Medications screen, tap the menu icon (three dots) in the top corner, and select 'Print Schedule'. You can choose your preferred format and print it or save as a PDF."
        ),
        FAQItem(
            question: "How do I add a new food item that's not in the database?",
            answer: "In the Nutrition tab, when adding a meal, tap 'Add Food'. If you can't find your item, scroll to the bottom and select 'Create Custom Food'. Enter the nutritional information and save it for future use."
        ),
        FAQItem(
            question: "How do I set up emergency contacts?",
            answer: "Go to the More tab and select Emergency Contacts. Tap the '+' button to add a new contact. You can enter their name, relationship, phone number, and set whether they should be contacted in case of emergency."
        ),
        FAQItem(
            question: "Can I export my nutrition data?",
            answer: "Yes. In the Nutrition tab, tap Reports, then select the date range you want to export. Tap the share icon in the top corner and choose how you want to share your data (email, message, save as PDF, etc.)."
        ),
        FAQItem(
            question: "How do I use voice commands?",
            answer: "Tap the microphone icon in the top right corner of any screen. When you see 'Listening...', speak your command clearly. For example, say 'Add water' to log water intake or 'Start fast' to begin a fasting timer."
        ),
        FAQItem(
            question: "Is my data secure?",
            answer: "Yes. We take data security seriously. All your personal and health information is encrypted and stored securely. We never share your data with third parties without your explicit consent. You can review our privacy policy in the app settings."
        ),
        FAQItem(
            question: "How do I get help if I'm having technical issues?",
            answer: "Go to Help & Support in the More tab, then select 'Contact Support'. You can send us an email describing your issue, call our support line, or check our video tutorials for guidance."
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Frequently Asked Questions", comment: ""),
                    description: NSLocalizedString("Find answers to common questions", comment: ""),
                    content: ""
                )
                
                // Search field placeholder (non-functional in this version)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    Text(NSLocalizedString("Search FAQs", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 10)
                
                // FAQ List
                VStack(spacing: 10) {
                    ForEach(Array(faqItems.enumerated()), id: \.offset) { index, item in
                        faqItemView(index: index, item: item)
                    }
                }
                
                // Still have questions section
                VStack(alignment: .leading, spacing: 15) {
                    Text(NSLocalizedString("Still Have Questions?", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        .padding(.top, 10)
                    
                    Text(NSLocalizedString("If you couldn't find the answer you're looking for, please contact our support team.", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    NavigationLink(destination: ContactSupportView()) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                            Text(NSLocalizedString("Contact Support", comment: ""))
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("FAQ", comment: ""))
    }
    
    private func faqItemView(index: Int, item: FAQItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Question header
            Button(action: {
                withAnimation {
                    if expandedQuestions.contains(index) {
                        expandedQuestions.remove(index)
                    } else {
                        expandedQuestions.insert(index)
                    }
                }
            }) {
                HStack {
                    Text(NSLocalizedString(item.question, comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: expandedQuestions.contains(index) ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(expandedQuestions.contains(index) ? 10 : 10)
            }
            
            // Answer content
            if expandedQuestions.contains(index) {
                Text(NSLocalizedString(item.answer, comment: ""))
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
            }
        }
    }
}

// FAQ item model
struct FAQItem {
    let question: String
    let answer: String
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FAQView()
                .environmentObject(UserSettings())
        }
    }
}
