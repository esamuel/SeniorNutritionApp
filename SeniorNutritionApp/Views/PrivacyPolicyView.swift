import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Privacy Policy", comment: ""))
                    .font(.largeTitle)
                    .padding(.bottom)

                Text("""
Effective Date: June 15, 2023

This Privacy Policy describes how SeniorNutritionApp ("we," "us," or "our") collects, uses, and discloses your information when you use our mobile application (the "App").

1. Information We Collect

We may collect the following types of information:
*   Personal Information: Information you provide directly, such as your name, date of birth, gender, height, weight, health goals, medical conditions, dietary restrictions, medication details (name, dosage, schedule), emergency contact details, and any other information you enter into the App.
*   Usage Information: Information about how you interact with the App, such as features used, time spent in the App, fasting protocol settings, meal logs, and general usage patterns. This may be collected automatically.
*   Device Information: Information about the device you use to access the App, such as device model, operating system version, and unique device identifiers (where permitted).
*   Voice Input Data: If you enable voice input features, we may process voice commands temporarily to execute actions within the App. We do not typically store raw voice recordings long-term unless necessary for feature improvement with your explicit consent.
*   Health Data: With your permission, we may collect health-related data from your device's health apps, including step count, heart rate, blood pressure, and other available metrics.
*   Location Data: With your permission, we may collect and process information about your location for emergency contact features.

2. How We Use Your Information

We use the information we collect for purposes including:
*   Providing and improving the App's features and functionality (e.g., medication reminders, fasting tracking, meal logging).
*   Personalizing your experience within the App with recommendations tailored to your health profile.
*   Communicating with you, including sending notifications, alerts, and responding to inquiries.
*   Analyzing usage patterns to understand how the App is used and to improve our services.
*   Ensuring the security and integrity of our App.
*   Complying with legal obligations.
*   Emergency contact functionality, when explicitly activated by you.

3. Information Sharing and Disclosure

We do not sell your personal information. We may share your information only in the following circumstances:
*   With Your Consent: We may share information if you give us explicit permission.
*   Service Providers: We may share information with third-party vendors and service providers who perform services on our behalf (e.g., data hosting, analytics). These providers are obligated to protect your information.
*   Emergency Contacts: If you have set up emergency contacts and activated an emergency alert, your designated contacts may receive your location and relevant health information.
*   Legal Requirements: We may disclose information if required by law, subpoena, or other legal process, or if we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request.
*   Business Transfers: In the event of a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred as part of that transaction.

4. Data Security

We implement reasonable administrative, technical, and physical security measures designed to protect your information from unauthorized access, use, or disclosure. However, no internet or electronic transmission is completely secure, and we cannot guarantee absolute security. We employ industry-standard encryption for data in transit and at rest.

5. Your Rights and Choices

Depending on applicable law (including Israeli Privacy Protection Law), you may have rights regarding your personal information, such as the right to access, correct, update, or request deletion of your data. You can typically manage some information directly within the App's settings or profile sections. For other requests, please contact us. You may also have the right to object to or restrict certain processing.

6. Data Retention

We retain your personal information for as long as necessary to provide the App's services, fulfill the purposes outlined in this policy, comply with our legal obligations, resolve disputes, and enforce our agreements. You may request deletion of your account and associated data at any time through the App settings.

7. Children's Privacy

The App is not intended for individuals under the age of 18 (or the relevant age of majority). We do not knowingly collect personal information from children.

8. International Data Transfers

Your information may be transferred to — and maintained on — computers located outside of your state, province, country, or other governmental jurisdiction where the data protection laws may differ. If you are located outside Israel and choose to provide information to us, please note that we transfer the information to Israel and process it there.

9. Changes to This Privacy Policy

We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy within the App or through other communication channels. Your continued use of the App after the effective date constitutes your acceptance of the revised policy.

10. Contact Us

If you have any questions about this Privacy Policy, please contact us at:
support@seniornutritionapp.com
Based in Tel Aviv, Israel.

11. Governing Law

This Privacy Policy shall be governed by and construed in accordance with the laws of the State of Israel, without regard to its conflict of law principles.
""")
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Privacy Policy", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
}
