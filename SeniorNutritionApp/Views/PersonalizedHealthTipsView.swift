import SwiftUI

struct PersonalizedHealthTipsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var voiceManager = VoiceManager.shared
    
    @State private var isReadingGeneralTips = false
    @State private var isReadingConditionTips = false
    @State private var isReadingFastingTips = false
    @State private var isReadingSafetyTips = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // General fasting tips
                    tipSection(
                        title: NSLocalizedString("General Fasting Tips", comment: ""),
                        icon: "timer",
                        color: .blue,
                        isReading: $isReadingGeneralTips,
                        readAction: readGeneralTips,
                        content: {
                            ForEach(generalFastingTips, id: \.title) { tip in
                                tipRow(title: NSLocalizedString(tip.title, comment: ""), description: NSLocalizedString(tip.description, comment: ""))
                            }
                        }
                    )
                    
                    // Condition-specific tips
                    if let profile = userSettings.userProfile, !profile.medicalConditions.isEmpty {
                        tipSection(
                            title: NSLocalizedString("Tips for Your Health Conditions", comment: ""),
                            icon: "heart.text.square",
                            color: .red,
                            isReading: $isReadingConditionTips,
                            readAction: readConditionTips,
                            content: {
                                ForEach(profile.medicalConditions, id: \.self) { condition in
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(condition)
                                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        ForEach(healthTipsForCondition(condition), id: \.title) { tip in
                                            tipRow(title: NSLocalizedString(tip.title, comment: ""), description: NSLocalizedString(tip.description, comment: ""))
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    
                                    if condition != profile.medicalConditions.last {
                                        Divider()
                                            .padding(.vertical, 8)
                                    }
                                }
                            }
                        )
                    }
                    
                    // Fasting safety tips
                    tipSection(
                        title: "Fasting Safety Guidelines",
                        icon: "exclamationmark.shield",
                        color: .orange,
                        isReading: $isReadingSafetyTips,
                        readAction: readSafetyTips,
                        content: {
                            ForEach(fastingSafetyTips, id: \.title) { tip in
                                tipRow(title: tip.title, description: tip.description)
                            }
                        }
                    )
                    
                    // Fasting benefits
                    tipSection(
                        title: "Benefits of Intermittent Fasting",
                        icon: "star",
                        color: .green,
                        isReading: $isReadingFastingTips,
                        readAction: readFastingBenefits,
                        content: {
                            ForEach(fastingBenefits, id: \.title) { tip in
                                tipRow(title: tip.title, description: tip.description)
                            }
                        }
                    )
                }
                .padding()
            }
            .navigationTitle("Health Tips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onDisappear {
                voiceManager.stopSpeaking()
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func tipSection<Content: View>(
        title: String,
        icon: String,
        color: Color,
        isReading: Binding<Bool>,
        readAction: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    .foregroundColor(color)
                
                Spacer()
                
                Button(action: {
                    if isReading.wrappedValue {
                        voiceManager.stopSpeaking()
                        isReading.wrappedValue = false
                    } else {
                        // Stop any other reading first
                        voiceManager.stopSpeaking()
                        isReadingGeneralTips = false
                        isReadingConditionTips = false
                        isReadingFastingTips = false
                        isReadingSafetyTips = false
                        
                        // Start reading this section
                        isReading.wrappedValue = true
                        readAction()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isReading.wrappedValue ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if isReading.wrappedValue {
                            Text("Stop")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        } else {
                            Text("Read")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
                .accessibilityLabel("Read \(title)")
                .accessibilityHint("Reads out \(title.lowercased()) information")
            }
            
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func tipRow(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: userSettings.textSize.size, weight: .medium))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 5)
    }
    
    // MARK: - Data
    
    private var generalFastingTips: [HealthTip] {
        [
            HealthTip(
                title: "Stay Hydrated",
                description: "Drink plenty of water during your fasting periods. Aim for at least 8-10 glasses daily to prevent dehydration."
            ),
            HealthTip(
                title: "Ease Into Fasting",
                description: "If you're new to fasting, start with shorter fasting periods and gradually increase the duration as your body adapts."
            ),
            HealthTip(
                title: "Break Fast Gently",
                description: "Break your fast with easily digestible foods like soups, fruits, or small portions of protein to avoid digestive discomfort."
            ),
            HealthTip(
                title: "Monitor Your Body",
                description: "Pay attention to how you feel during fasting. Mild hunger is normal, but dizziness, extreme fatigue, or confusion are not."
            )
        ]
    }
    
    private var fastingSafetyTips: [HealthTip] {
        [
            HealthTip(
                title: "Know When to Stop",
                description: "If you experience severe headaches, dizziness, confusion, or weakness, break your fast immediately and consult your doctor."
            ),
            HealthTip(
                title: "Medication Timing",
                description: "Take medications as prescribed by your doctor. Some medications need to be taken with food, which may require adjusting your fasting schedule."
            ),
            HealthTip(
                title: "Consult Healthcare Providers",
                description: "Always consult with your healthcare provider before starting a fasting regimen, especially if you have chronic health conditions."
            ),
            HealthTip(
                title: "Avoid Overexertion",
                description: "During extended fasts, avoid strenuous exercise. Light activities like walking or gentle stretching are better options."
            )
        ]
    }
    
    private var fastingBenefits: [HealthTip] {
        [
            HealthTip(
                title: "Cellular Repair",
                description: "Fasting triggers cellular repair processes, including autophagy, where cells remove damaged components."
            ),
            HealthTip(
                title: "Insulin Sensitivity",
                description: "Regular fasting can improve insulin sensitivity, potentially reducing the risk of type 2 diabetes."
            ),
            HealthTip(
                title: "Reduced Inflammation",
                description: "Studies suggest that fasting may reduce inflammatory markers in the body, which are linked to many chronic diseases."
            ),
            HealthTip(
                title: "Brain Health",
                description: "Fasting may increase the production of brain-derived neurotrophic factor (BDNF), which supports brain health and may protect against neurodegenerative diseases."
            )
        ]
    }
    
    // MARK: - Condition-specific tips
    
    private func healthTipsForCondition(_ condition: String) -> [HealthTip] {
        let normalizedCondition = condition.lowercased()
        
        if normalizedCondition.contains("diabetes") || normalizedCondition.contains("blood sugar") {
            return [
                HealthTip(
                    title: "Monitor Blood Sugar Closely",
                    description: "Check your blood glucose levels more frequently during fasting periods to ensure they remain within a safe range."
                ),
                HealthTip(
                    title: "Shorter Fasting Windows",
                    description: "Consider shorter fasting periods (12-14 hours) rather than extended fasts to avoid blood sugar fluctuations."
                ),
                HealthTip(
                    title: "Medication Timing",
                    description: "Work with your healthcare provider to adjust the timing of diabetes medications during fasting periods."
                ),
                HealthTip(
                    title: "Break Fast Appropriately",
                    description: "Break your fast with a balanced meal containing protein, healthy fats, and complex carbohydrates to prevent blood sugar spikes."
                )
            ]
        } else if normalizedCondition.contains("heart") || normalizedCondition.contains("cardiovascular") || normalizedCondition.contains("hypertension") || normalizedCondition.contains("blood pressure") {
            return [
                HealthTip(
                    title: "Monitor Blood Pressure",
                    description: "Check your blood pressure regularly during fasting periods, as fasting can sometimes cause fluctuations."
                ),
                HealthTip(
                    title: "Stay Hydrated",
                    description: "Dehydration during fasting can affect blood pressure. Drink plenty of water throughout your fasting window."
                ),
                HealthTip(
                    title: "Maintain Electrolyte Balance",
                    description: "Consider adding a pinch of salt to your water or drinking sugar-free electrolyte beverages during longer fasts."
                ),
                HealthTip(
                    title: "Gradual Transition",
                    description: "If you take blood pressure medications, work with your doctor to monitor how fasting affects your blood pressure and adjust medications if necessary."
                )
            ]
        } else if normalizedCondition.contains("kidney") || normalizedCondition.contains("renal") {
            return [
                HealthTip(
                    title: "Consult Your Nephrologist",
                    description: "Kidney disease requires specialized fasting protocols. Always consult with your kidney specialist before fasting."
                ),
                HealthTip(
                    title: "Shorter Fasting Periods",
                    description: "Consider time-restricted eating (10-12 hours) rather than extended fasting periods to minimize stress on the kidneys."
                ),
                HealthTip(
                    title: "Hydration Balance",
                    description: "Follow your doctor's recommendations for fluid intake during fasting, as both over-hydration and dehydration can be problematic."
                ),
                HealthTip(
                    title: "Monitor Electrolytes",
                    description: "Kidney disease affects electrolyte balance. Regular monitoring during fasting periods is essential."
                )
            ]
        } else if normalizedCondition.contains("thyroid") {
            return [
                HealthTip(
                    title: "Medication Timing",
                    description: "Take thyroid medication on an empty stomach as directed, typically 30-60 minutes before eating."
                ),
                HealthTip(
                    title: "Monitor Energy Levels",
                    description: "Pay attention to energy levels during fasting. Excessive fatigue may indicate a need to adjust your fasting schedule."
                ),
                HealthTip(
                    title: "Iodine-Rich Foods",
                    description: "When breaking your fast, include iodine-rich foods like seaweed, fish, or eggs to support thyroid function."
                ),
                HealthTip(
                    title: "Regular Testing",
                    description: "Continue regular thyroid function tests to ensure your condition remains stable while practicing intermittent fasting."
                )
            ]
        } else if normalizedCondition.contains("arthritis") || normalizedCondition.contains("joint") || normalizedCondition.contains("inflammation") {
            return [
                HealthTip(
                    title: "Anti-Inflammatory Benefits",
                    description: "Fasting may help reduce inflammation, potentially providing relief from arthritis symptoms."
                ),
                HealthTip(
                    title: "Gentle Movement",
                    description: "Incorporate gentle stretching or yoga during fasting periods to maintain joint mobility."
                ),
                HealthTip(
                    title: "Anti-Inflammatory Foods",
                    description: "Break your fast with anti-inflammatory foods like fatty fish, berries, turmeric, and leafy greens."
                ),
                HealthTip(
                    title: "Medication Timing",
                    description: "If you take anti-inflammatory medications, consult your doctor about optimal timing during your eating window."
                )
            ]
        } else if normalizedCondition.contains("gastro") || normalizedCondition.contains("digestive") || normalizedCondition.contains("ibs") || normalizedCondition.contains("bowel") {
            return [
                HealthTip(
                    title: "Digestive Rest",
                    description: "Fasting gives your digestive system time to rest and repair, which may help reduce symptoms."
                ),
                HealthTip(
                    title: "Gentle Refeeding",
                    description: "Break your fast with easily digestible foods and avoid known trigger foods that aggravate your condition."
                ),
                HealthTip(
                    title: "Hydration with Care",
                    description: "Stay hydrated but avoid carbonated or caffeinated beverages that might irritate your digestive tract."
                ),
                HealthTip(
                    title: "Probiotic Support",
                    description: "Consider including probiotic-rich foods when breaking your fast to support gut health."
                )
            ]
        } else if normalizedCondition.contains("osteoporosis") || normalizedCondition.contains("bone") {
            return [
                HealthTip(
                    title: "Calcium Timing",
                    description: "Ensure adequate calcium intake during your eating window. Consider calcium-rich foods like dairy, fortified plant milks, or leafy greens."
                ),
                HealthTip(
                    title: "Vitamin D",
                    description: "Maintain vitamin D supplementation as recommended by your doctor, as it's crucial for calcium absorption."
                ),
                HealthTip(
                    title: "Weight-Bearing Exercise",
                    description: "Include weight-bearing exercises during your eating window to help maintain bone density."
                ),
                HealthTip(
                    title: "Protein Intake",
                    description: "Ensure adequate protein intake during your eating window, as protein is essential for bone health."
                )
            ]
        } else {
            // Generic tips for other conditions
            return [
                HealthTip(
                    title: "Consult Your Doctor",
                    description: "Always discuss your fasting regimen with your healthcare provider to ensure it's safe for your specific health condition."
                ),
                HealthTip(
                    title: "Start Gradually",
                    description: "Begin with shorter fasting periods and gradually extend them as your body adapts."
                ),
                HealthTip(
                    title: "Listen to Your Body",
                    description: "Pay close attention to how your body responds to fasting and adjust your approach accordingly."
                ),
                HealthTip(
                    title: "Medication Management",
                    description: "Work with your healthcare provider to adjust medication timing if needed to accommodate your fasting schedule."
                )
            ]
        }
    }
    
    // MARK: - Text-to-Speech Methods
    
    private func readGeneralTips() {
        var speech = "General Fasting Tips. "
        
        for tip in generalFastingTips {
            speech += "\(tip.title): \(tip.description) "
        }
        
        voiceManager.speak(speech, userSettings: userSettings)
    }
    
    private func readConditionTips() {
        guard let profile = userSettings.userProfile, !profile.medicalConditions.isEmpty else {
            return
        }
        
        var speech = "Tips for Your Health Conditions. "
        
        for condition in profile.medicalConditions {
            speech += "For \(condition): "
            
            let tips = healthTipsForCondition(condition)
            for tip in tips {
                speech += "\(tip.title): \(tip.description) "
            }
        }
        
        voiceManager.speak(speech, userSettings: userSettings)
    }
    
    private func readSafetyTips() {
        var speech = "Fasting Safety Guidelines. "
        
        for tip in fastingSafetyTips {
            speech += "\(tip.title): \(tip.description) "
        }
        
        voiceManager.speak(speech, userSettings: userSettings)
    }
    
    private func readFastingBenefits() {
        var speech = "Benefits of Intermittent Fasting. "
        
        for tip in fastingBenefits {
            speech += "\(tip.title): \(tip.description) "
        }
        
        voiceManager.speak(speech, userSettings: userSettings)
    }
}

// MARK: - Health Tip Model
struct HealthTip {
    let title: String
    let description: String
}
