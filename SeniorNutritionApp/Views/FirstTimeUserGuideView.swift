import SwiftUI

struct FirstTimeUserGuideView: View {
    @ObservedObject var ttsRouter = TTSRouter.shared
    @ObservedObject var voiceManager = VoiceManager.shared
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var showingProfileSetup = false
    @State private var showingHealthDataEntry = false
    
    private let steps: [GuideStep] = [
        GuideStep(
            title: "Welcome to Your Health Journey!",
            subtitle: "Let's get you set up for personalized nutrition guidance",
            icon: "heart.circle.fill",
            iconColor: .red,
            description: "This quick setup will help us provide you with accurate nutrition analysis and personalized recommendations tailored specifically to your health needs.",
            benefits: [
                "Personalized nutrition recommendations",
                "Accurate calorie and nutrient tracking",
                "Health-aware meal suggestions",
                "Better medication and meal timing"
            ],
            actionTitle: "Let's Start!",
            actionIcon: "arrow.right.circle.fill"
        ),
        GuideStep(
            title: "Create Your Personal Profile",
            subtitle: "Essential information for personalized recommendations",
            icon: "person.circle.fill",
            iconColor: .blue,
            description: "Your personal information helps us calculate your specific nutritional needs, including daily calorie requirements, portion sizes, and nutrient recommendations based on your age, gender, and physical characteristics.",
            benefits: [
                "Accurate daily calorie calculations",
                "Age-appropriate nutrient recommendations",
                "Proper portion size guidance",
                "Gender-specific health considerations"
            ],
            actionTitle: "Set Up Profile",
            actionIcon: "person.badge.plus"
        ),
        GuideStep(
            title: "Add Physical Information",
            subtitle: "Height, weight, and body measurements",
            icon: "figure.walk.circle.fill",
            iconColor: .green,
            description: "Your height and weight are crucial for calculating your Basal Metabolic Rate (BMR) and daily calorie needs. This ensures our nutrition analysis provides accurate recommendations for maintaining or reaching your health goals.",
            benefits: [
                "Precise BMR and calorie calculations",
                "Accurate BMI tracking",
                "Proper portion recommendations",
                "Weight management guidance"
            ],
            actionTitle: "Add Measurements",
            actionIcon: "ruler"
        ),
        GuideStep(
            title: "Medical Conditions Matter",
            subtitle: "Help us keep you safe and healthy",
            icon: "cross.circle.fill",
            iconColor: .red,
            description: "Adding your medical conditions allows us to provide nutrition advice that's safe for your specific health situation. We'll warn you about foods that might interact with your conditions and suggest beneficial alternatives.",
            benefits: [
                "Safe food recommendations",
                "Condition-specific nutrition alerts",
                "Medication interaction warnings",
                "Tailored health advice"
            ],
            actionTitle: "Add Conditions",
            actionIcon: "heart.text.square"
        ),
        GuideStep(
            title: "Dietary Restrictions & Preferences",
            subtitle: "Customize your nutrition experience",
            icon: "leaf.circle.fill",
            iconColor: .green,
            description: "Whether you're vegetarian, have food allergies, or follow specific diets, this information ensures all our recommendations fit your lifestyle and dietary needs safely.",
            benefits: [
                "Allergen-free recommendations",
                "Diet-compliant meal suggestions",
                "Safe ingredient alternatives",
                "Personalized recipe filtering"
            ],
            actionTitle: "Set Preferences",
            actionIcon: "checkmark.seal"
        ),
        GuideStep(
            title: "Start Tracking Your Health",
            subtitle: "Begin your wellness journey",
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            iconColor: .purple,
            description: "Now that your profile is complete, you can start logging meals, tracking health metrics, and receiving personalized nutrition analysis. The more data you provide, the better our recommendations become!",
            benefits: [
                "Accurate nutrition analysis",
                "Personalized meal recommendations",
                "Health trend monitoring",
                "Progress tracking"
            ],
            actionTitle: "Start Tracking",
            actionIcon: "plus.circle.fill"
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress indicator
                VStack(spacing: 12) {
                    HStack {
                        Text(NSLocalizedString("Setup Progress", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(currentStep + 1) / \(steps.count)")
                            .font(.system(size: userSettings.textSize.size - 2, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Main content
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        GuideStepView(
                            step: steps[index],
                            userSettings: userSettings,
                            voiceManager: voiceManager,
                            onAction: {
                                handleStepAction(for: index)
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text(NSLocalizedString("Previous", comment: ""))
                            }
                            .font(.system(size: userSettings.textSize.size, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(25)
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < steps.count - 1 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        }) {
                            HStack {
                                Text(NSLocalizedString("Next", comment: ""))
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: userSettings.textSize.size, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(25)
                        }
                    } else {
                        Button(action: {
                            // Mark guide as completed and dismiss
                            userSettings.isFirstTimeGuideComplete = true
                            dismiss()
                        }) {
                            HStack {
                                Text(NSLocalizedString("Start Using App", comment: ""))
                                Image(systemName: "checkmark.circle.fill")
                            }
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .cornerRadius(25)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Skip Guide", comment: "")) {
                        userSettings.isFirstTimeGuideComplete = true
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size, weight: .medium))
                    .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if TTSRouter.shared.isSpeaking { 
                            TTSRouter.shared.stopSpeaking() 
                        } else { 
                            speakCurrentStep() 
                        }
                    }) {
                        Image(systemName: TTSRouter.shared.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel(TTSRouter.shared.isSpeaking ? NSLocalizedString("Stop Speaking", comment: "") : NSLocalizedString("Read Aloud", comment: ""))
                }
            }
        }
        .sheet(isPresented: $showingProfileSetup) {
            UserProfileSetupView()
        }
        .sheet(isPresented: $showingHealthDataEntry) {
            HealthDataTabView()
        }
    }
    
    private func handleStepAction(for stepIndex: Int) {
        switch stepIndex {
        case 0:
            // Welcome step - just move to next
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = 1
            }
        case 1, 2, 3, 4:
            // Profile setup steps
            showingProfileSetup = true
        case 5:
            // Health data tracking step
            showingHealthDataEntry = true
        default:
            break
        }
    }
    
    private func speakCurrentStep() {
        let step = steps[currentStep]
        let textToSpeak = """
        \(NSLocalizedString(step.title, comment: "")).
        \(NSLocalizedString(step.subtitle, comment: "")).
        \(NSLocalizedString(step.description, comment: "")).
        \(NSLocalizedString("Benefits include:", comment: ""))
        \(step.benefits.map { NSLocalizedString($0, comment: "") }.joined(separator: ". "))
        """
        TTSRouter.shared.speak(textToSpeak, userSettings: userSettings)
    }
}

struct GuideStepView: View {
    let step: GuideStep
    let userSettings: UserSettings
    let voiceManager: VoiceManager
    let onAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                
                // Icon
                Image(systemName: step.icon)
                    .font(.system(size: 80))
                    .foregroundColor(step.iconColor)
                    .padding(40)
                    .background(
                        Circle()
                            .fill(step.iconColor.opacity(0.1))
                            .frame(width: 160, height: 160)
                    )
                
                // Title and subtitle
                VStack(spacing: 8) {
                    Text(NSLocalizedString(step.title, comment: ""))
                        .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text(NSLocalizedString(step.subtitle, comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                
                // Description
                Text(NSLocalizedString(step.description, comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .lineLimit(nil)
                
                // Benefits
                VStack(alignment: .leading, spacing: 12) {
                    Text(NSLocalizedString("Why this matters:", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    ForEach(step.benefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                                .padding(.top, 2)
                            
                            Text(NSLocalizedString(benefit, comment: ""))
                                .font(.system(size: userSettings.textSize.size - 1))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.green.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // Action button
                Button(action: onAction) {
                    HStack {
                        Image(systemName: step.actionIcon)
                        Text(NSLocalizedString(step.actionTitle, comment: ""))
                    }
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(step.iconColor)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Spacer(minLength: 20)
            }
        }
    }
}

struct GuideStep {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let description: String
    let benefits: [String]
    let actionTitle: String
    let actionIcon: String
}

struct FirstTimeUserGuideView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeUserGuideView()
            .environmentObject(UserSettings())
    }
} 