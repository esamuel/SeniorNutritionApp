import SwiftUI
import Foundation
import MessageUI

struct ContactSupportView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var isShowingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, NSError>? = nil
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var subject = ""
    @State private var messageBody = ""
    @State private var selectedIssueType = "General Question"
    
    private let issueTypes = [
        "General Question",
        "Technical Problem",
        "Feature Request",
        "Account Issue",
        "Billing Question",
        "Other"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Contact Support", comment: ""),
                    description: NSLocalizedString("Get help from our support team", comment: ""),
                    content: ""
                )
                
                // Support Info Section
                VStack(alignment: .leading, spacing: 15) {
                    Text(NSLocalizedString("Support Information", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    infoRow(icon: "envelope.fill", title: NSLocalizedString("Email", comment: ""), value: AppConfig.Support.email)
                    infoRow(icon: "phone.fill", title: NSLocalizedString("Phone", comment: ""), value: AppConfig.Support.phone)
                    infoRow(icon: "clock.fill", title: NSLocalizedString("Hours", comment: ""), value: AppConfig.Support.hours)
                    infoRow(icon: "mappin.and.ellipse", title: NSLocalizedString("Location", comment: ""), value: AppConfig.Support.location)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Contact Form Section
                VStack(alignment: .leading, spacing: 15) {
                    Text(NSLocalizedString("Contact Form", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    // Issue Type Picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text(NSLocalizedString("Issue Type", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        
                        Picker("", selection: $selectedIssueType) {
                            ForEach(issueTypes, id: \.self) { issue in
                                Text(NSLocalizedString(issue, comment: ""))
                                    .font(.system(size: userSettings.textSize.size))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Subject Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text(NSLocalizedString("Subject", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        
                        TextField(NSLocalizedString("Brief description of your issue", comment: ""), text: $subject)
                            .font(.system(size: userSettings.textSize.size))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // Message Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text(NSLocalizedString("Message", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        
                        TextEditor(text: $messageBody)
                            .font(.system(size: userSettings.textSize.size))
                            .frame(minHeight: 150)
                            .padding(5)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Submit Button
                    Button(action: {
                        prepareEmail()
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text(NSLocalizedString("Send Message", comment: ""))
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                
                // Alternative Contact Methods
                VStack(alignment: .leading, spacing: 15) {
                    Text(NSLocalizedString("Other Ways to Get Help", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        .padding(.top, 10)
                    
                    Button(action: {
                        if let url = URL(string: "tel:\(AppConfig.Support.phone.replacingOccurrences(of: "-", with: ""))") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        contactMethodButton(
                            icon: "phone.fill",
                            title: NSLocalizedString("Call Support", comment: ""),
                            subtitle: NSLocalizedString("Speak directly with our team", comment: ""),
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: VideoTutorialsView()) {
                        contactMethodButton(
                            icon: "play.rectangle.fill",
                            title: NSLocalizedString("Video Tutorials", comment: ""),
                            subtitle: NSLocalizedString("Learn through guided videos", comment: ""),
                            color: .orange
                        )
                    }
                    
                    Button(action: {
                        if let url = URL(string: AppConfig.HelpResources.faqUrl) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        contactMethodButton(
                            icon: "questionmark.circle.fill",
                            title: NSLocalizedString("FAQ", comment: ""),
                            subtitle: NSLocalizedString("Find answers to common questions", comment: ""),
                            color: .purple
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Contact Support", comment: ""))
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: $isShowingMailView, result: $mailResult, subject: subject, messageBody: messageBody, recipients: [AppConfig.Support.email])
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(NSLocalizedString("Email Result", comment: "")),
                message: Text(alertMessage),
                dismissButton: .default(Text(NSLocalizedString("OK", comment: "")))
            )
        }
        .onAppear {
            processMailResult()
        }
    }
    
    private func prepareEmail() {
        // Format the email body with the issue type
        let formattedBody = """
        Issue Type: \(selectedIssueType)
        
        \(messageBody)
        
        ---
        App Version: \(AppConfig.appVersion) (\(AppConfig.buildNumber))
        Device: \(UIDevice.current.model)
        iOS Version: \(UIDevice.current.systemVersion)
        """
        
        // Check if mail is available
        if MFMailComposeViewController.canSendMail() {
            self.messageBody = formattedBody
            isShowingMailView = true
        } else {
            // If mail isn't available, show alternative options
            alertMessage = NSLocalizedString("Email is not configured on this device. Please contact us at \(AppConfig.Support.email) or call \(AppConfig.Support.phone).", comment: "")
            showingAlert = true
        }
    }
    
    private func processMailResult() {
        if let result = mailResult {
            switch result {
            case .success(let mailComposeResult):
                switch mailComposeResult {
                case .sent:
                    alertMessage = NSLocalizedString("Email sent successfully!", comment: "")
                    showingAlert = true
                case .saved:
                    alertMessage = NSLocalizedString("Email saved as draft.", comment: "")
                    showingAlert = true
                case .cancelled:
                    alertMessage = NSLocalizedString("Email cancelled.", comment: "")
                    showingAlert = true
                case .failed:
                    alertMessage = NSLocalizedString("Failed to send email. Please try again.", comment: "")
                    showingAlert = true
                @unknown default:
                    alertMessage = NSLocalizedString("Unknown status.", comment: "")
                    showingAlert = true
                }
            case .failure(let error):
                alertMessage = NSLocalizedString("Failed to send email: ", comment: "") + error.localizedDescription
                showingAlert = true
            }
            
            // Reset the result after processing
            DispatchQueue.main.async {
                self.mailResult = nil
            }
        }
    }
    
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                
                Text(value)
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    private func contactMethodButton(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(color)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                
                Text(subtitle)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// Mail View using UIKit's MFMailComposeViewController
struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, NSError>?
    
    var subject: String
    var messageBody: String
    var recipients: [String]
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, NSError>?
        
        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, NSError>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            
            if let error = error as NSError? {
                self.result = .failure(error)
                return
            }
            
            self.result = .success(result)
        }
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(recipients)
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }
}

struct ContactSupportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactSupportView()
                .environmentObject(UserSettings())
        }
    }
}
