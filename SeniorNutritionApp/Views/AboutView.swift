import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // App Logo and Version
                VStack(spacing: 10) {
                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text("Senior Nutrition")
                        .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                    
                    Text("Version 1.0.0")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                // About the App
                sectionTitle("About the App")
                Text("Senior Nutrition is a comprehensive health and wellness app designed specifically for adults aged 50 and above. Our mission is to support healthy aging through personalized nutrition guidance, mindful eating practices, and safe fasting protocols tailored for seniors.")
                    .font(.system(size: userSettings.textSize.size))
                
                // Vision and Purpose
                sectionTitle("Our Vision")
                Text("We believe that proper nutrition is fundamental to healthy aging. Our app combines the latest research in senior nutrition with user-friendly technology to help older adults maintain their health, independence, and quality of life.")
                    .font(.system(size: userSettings.textSize.size))
                
                // Key Features
                sectionTitle("Key Features")
                featuresList([
                    "Personalized nutrition tracking and recommendations",
                    "Senior-friendly fasting protocols with safety features",
                    "Medication and meal schedule integration",
                    "Multi-language support (English, French, Spanish, Hebrew)",
                    "Enhanced accessibility with adjustable text sizes",
                    "Voice assistance for hands-free operation"
                ])
                
                // The Story Behind
                sectionTitle("The Story Behind")
                Text("This app was born from a deep understanding of the unique nutritional needs of seniors and the challenges they face in maintaining healthy eating habits. We worked closely with nutritionists, geriatric care specialists, and seniors themselves to create a tool that's both comprehensive and easy to use.")
                    .font(.system(size: userSettings.textSize.size))
                
                // Safety First
                sectionTitle("Safety First")
                Text("All our features, especially the fasting protocols, are designed with senior safety in mind. We incorporate regular reminders, health checks, and emergency override options to ensure a safe and healthy experience.")
                    .font(.system(size: userSettings.textSize.size))
                
                // Contact Information
                sectionTitle("Contact Us")
                VStack(alignment: .leading, spacing: 10) {
                    contactRow(icon: "envelope.fill", text: "support@seniornutritionapp.com")
                    contactRow(icon: "globe", text: "www.seniornutritionapp.com")
                    contactRow(icon: "phone.fill", text: "+1 (800) 123-4567")
                }
                
                // Legal Information
                sectionTitle("Legal Information")
                VStack(alignment: .leading, spacing: 15) {
                    Button("Privacy Policy") {
                        // Handle privacy policy navigation
                    }
                    .font(.system(size: userSettings.textSize.size))
                    
                    Button("Terms of Service") {
                        // Handle terms of service navigation
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                // Disclaimer
                Text("This app is designed for informational purposes only and should not replace professional medical advice. Always consult with your healthcare provider before starting any new diet or fasting program.")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("About")
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            .padding(.vertical, 5)
    }
    
    private func featuresList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(item)
                        .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    private func contactRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.system(size: userSettings.textSize.size))
        }
    }
}

#Preview {
    NavigationView {
        AboutView()
            .environmentObject(UserSettings())
    }
} 