import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Terms of Use")
                    .font(.largeTitle)
                    .padding(.bottom)

                Text("""
Effective Date: June 15, 2023

Please read these Terms of Use ("Terms") carefully before using the SeniorNutritionApp mobile application (the "App") operated by us ("us," "we," or "our").

Your access to and use of the App is conditioned upon your acceptance of and compliance with these Terms. These Terms apply to all visitors, users, and others who wish to access or use the App. By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of the terms, then you do not have permission to access the App.

1. Use of the App

SeniorNutritionApp provides tools and information related to nutrition tracking, meal planning, medication reminders, and intermittent fasting management, primarily aimed at seniors. You agree to use the App only for its intended purposes and in accordance with all applicable laws and regulations.

**IMPORTANT MEDICAL DISCLAIMER:** The App is intended for informational and organizational purposes only. It does not provide medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition or treatment and before undertaking a new health care regimen. Never disregard professional medical advice or delay in seeking it because of something you have read or tracked on this App. Reliance on any information provided by the App is solely at your own risk.

2. Accounts

When you create an account with us (if applicable), you guarantee that the information you provide is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account. You are responsible for maintaining the confidentiality of your account and password, including restricting access to your device.

3. Intellectual Property

The App and its original content, features, and functionality are and will remain the exclusive property of SeniorNutritionApp and its licensors. The App is protected by copyright, trademark, and other laws of both Israel and foreign countries. Our trademarks may not be used in connection with any product or service without our prior written consent.

4. User Conduct

You agree not to use the App:
*   In any way that violates any applicable local, national, or international law or regulation.
*   To transmit, or procure the sending of, any advertising or promotional material, including any "junk mail," "chain letter," "spam," or any other similar solicitation.
*   To impersonate or attempt to impersonate us, our employees, another user, or any other person or entity.
*   To engage in any other conduct that restricts or inhibits anyone's use or enjoyment of the App, or which, as determined by us, may harm us or users of the App or expose them to liability.

5. Data Privacy

Your privacy is important to us. Our Privacy Policy, accessible in the App, describes how we handle the information you provide to us when you use our App. By using the App, you agree that we can collect, use, and share your information in accordance with our Privacy Policy.

6. Health Data

The App may collect and store health-related data, including but not limited to nutrition information, fasting schedules, medication details, and other health metrics. You maintain ownership of your health data. We implement appropriate security measures to protect your data, but we cannot guarantee absolute security. You are responsible for maintaining the security of your device and account credentials.

7. Disclaimers

Your use of the App is at your sole risk. The App is provided on an "AS IS" and "AS AVAILABLE" basis. The App is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement, or course of performance.

We do not warrant that a) the App will function uninterrupted, secure, or available at any particular time or location; b) any errors or defects will be corrected; c) the App is free of viruses or other harmful components; or d) the results of using the App will meet your requirements or provide accurate health outcomes.

8. Limitation of Liability

In no event shall SeniorNutritionApp, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your access to or use of or inability to access or use the App; (ii) any conduct or content of any third party on the App; (iii) any content obtained from the App; and (iv) unauthorized access, use, or alteration of your transmissions or content, whether based on warranty, contract, tort (including negligence), or any other legal theory, whether or not we have been informed of the possibility of such damage, and even if a remedy set forth herein is found to have failed of its essential purpose.

9. Indemnification

You agree to defend, indemnify, and hold harmless SeniorNutritionApp and its licensee and licensors, and their employees, contractors, agents, officers, and directors, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney's fees), resulting from or arising out of a) your use and access of the App, or b) a breach of these Terms.

10. Third-Party Links and Services

The App may contain links to third-party websites or services that are not owned or controlled by SeniorNutritionApp. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You acknowledge and agree that SeniorNutritionApp shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services.

11. Governing Law

These Terms shall be governed and construed in accordance with the laws of the State of Israel, without regard to its conflict of law provisions. Any disputes arising under or in connection with these Terms shall be subject to the exclusive jurisdiction of the competent courts located in Tel Aviv, Israel.

12. Changes

We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion. By continuing to access or use our App after any revisions become effective, you agree to be bound by the revised terms.

13. Contact Us

If you have any questions about these Terms, please contact us at:
support@seniornutritionapp.com
Based in Tel Aviv, Israel.
""")
                    .font(.body)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TermsOfUseView()
    }
}
