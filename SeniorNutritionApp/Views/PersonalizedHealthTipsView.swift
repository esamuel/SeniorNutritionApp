#if canImport(UIKit)
import UIKit
#endif

import SwiftUI

// Add imports to ensure we can access the HealthTip model
import Foundation

struct PersonalizedHealthTipsView: View {
    @ObservedObject var ttsRouter = TTSRouter.shared
    @ObservedObject var voiceManager = VoiceManager.shared
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var isReadingGeneralTips = false
    @State private var isReadingConditionTips = false
    @State private var isReadingFastingTips = false
    @State private var isReadingSafetyTips = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Doctor Note Banner
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.blue)
                        Text("Health tips are for educational purposes only. Always consult your doctor before making changes to your health routine.")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .padding([.top, .horizontal])
                    
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
                            
                            // Add citations for general fasting tips
                            CitationsView(categories: [.fasting])
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
                                
                                // Add citations for health conditions
                                CitationsView(categories: [.seniorHealth])
                            }
                        )
                    }
                    
                    // Fasting safety tips
                    tipSection(
                        title: NSLocalizedString("Fasting Safety Guidelines", comment: ""),
                        icon: "exclamationmark.shield",
                        color: .orange,
                        isReading: $isReadingSafetyTips,
                        readAction: readSafetyTips,
                        content: {
                            ForEach(fastingSafetyTips, id: \.title) { tip in
                                tipRow(title: tip.title, description: tip.description)
                            }
                            
                            // Add citations for fasting safety
                            CitationsView(categories: [.fasting])
                        }
                    )
                    
                    // Fasting benefits
                    tipSection(
                        title: NSLocalizedString("Benefits of Intermittent Fasting", comment: ""),
                        icon: "star",
                        color: .green,
                        isReading: $isReadingFastingTips,
                        readAction: readFastingBenefits,
                        content: {
                            ForEach(fastingBenefits, id: \.title) { tip in
                                tipRow(title: tip.title, description: tip.description)
                            }
                            
                            // Add citations for fasting benefits
                            CitationsView(categories: [.fasting])
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
                TTSRouter.shared.stopSpeaking()
                isReadingGeneralTips = false
                isReadingConditionTips = false
                isReadingFastingTips = false
                isReadingSafetyTips = false
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
                    if isReading.wrappedValue || TTSRouter.shared.isSpeaking { 
                        TTSRouter.shared.stopSpeaking()
                        isReading.wrappedValue = false
                    } else {
                        // Stop any other reading first
                        TTSRouter.shared.stopSpeaking()
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
                        Image(systemName: (isReading.wrappedValue || TTSRouter.shared.isSpeaking) ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            
                        if isReading.wrappedValue || TTSRouter.shared.isSpeaking {
                            Text(NSLocalizedString("Stop", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.white)
                        } else {
                            Text(NSLocalizedString("Read", comment: ""))
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
        TipRowView(icon: nil, title: title, description: description, textSize: userSettings.textSize.size)
    }
    
    // MARK: - Data
    
    private var generalFastingTips: [HealthTip] {
        [
            HealthTip(
                title: NSLocalizedString("Stay Hydrated", comment: ""),
                description: NSLocalizedString("Drink plenty of water during your fasting periods. Aim for at least 8-10 glasses daily to prevent dehydration.", comment: ""),
                category: .hydration,
                icon: "drop.fill"
            ),
            HealthTip(
                title: NSLocalizedString("Ease Into Fasting", comment: ""),
                description: NSLocalizedString("If you're new to fasting, start with shorter fasting periods and gradually increase the duration as your body adapts.", comment: ""),
                category: .fasting,
                icon: "clock"
            ),
            HealthTip(
                title: NSLocalizedString("Break Fast Gently", comment: ""),
                description: NSLocalizedString("Break your fast with easily digestible foods like soups, fruits, or small portions of protein to avoid digestive discomfort.", comment: ""),
                category: .nutrition,
                icon: "fork.knife"
            ),
            HealthTip(
                title: NSLocalizedString("Monitor Your Body", comment: ""),
                description: NSLocalizedString("Pay attention to how you feel during fasting. Mild hunger is normal, but dizziness, extreme fatigue, or confusion are not.", comment: ""),
                category: .general,
                icon: "heart.text.square"
            )
        ]
    }
    
    private var fastingSafetyTips: [HealthTip] {
        [
            HealthTip(
                title: NSLocalizedString("Know When to Stop", comment: ""),
                description: NSLocalizedString("If you experience severe headaches, dizziness, confusion, or weakness, break your fast immediately and consult your doctor.", comment: ""),
                category: .seniorSpecific,
                icon: "exclamationmark.triangle"
            ),
            HealthTip(
                title: NSLocalizedString("Medication Timing", comment: ""),
                description: NSLocalizedString("Take medications as prescribed by your doctor. Some medications need to be taken with food, which may require adjusting your fasting schedule.", comment: ""),
                category: .medication,
                icon: "pills"
            ),
            HealthTip(
                title: NSLocalizedString("Consult Healthcare Providers", comment: ""),
                description: NSLocalizedString("Always consult with your healthcare provider before starting a fasting regimen, especially if you have chronic health conditions.", comment: ""),
                category: .general,
                icon: "person.text.rectangle"
            ),
            HealthTip(
                title: NSLocalizedString("Avoid Overexertion", comment: ""),
                description: NSLocalizedString("During extended fasts, avoid strenuous exercise. Light activities like walking or gentle stretching are better options.", comment: ""),
                category: .activity,
                icon: "figure.walk"
            )
        ]
    }
    
    private var fastingBenefits: [HealthTip] {
        [
            HealthTip(
                title: NSLocalizedString("Cellular Repair", comment: ""),
                description: NSLocalizedString("Fasting triggers cellular repair processes, including autophagy, where cells remove damaged components.", comment: ""),
                category: .general,
                icon: "checkmark.seal"
            ),
            HealthTip(
                title: NSLocalizedString("Insulin Sensitivity", comment: ""),
                description: NSLocalizedString("Regular fasting can improve insulin sensitivity, potentially reducing the risk of type 2 diabetes.", comment: ""),
                category: .general,
                icon: "chart.line.downtrend.xyaxis"
            ),
            HealthTip(
                title: NSLocalizedString("Reduced Inflammation", comment: ""),
                description: NSLocalizedString("Studies suggest that fasting may reduce inflammatory markers in the body, which are linked to many chronic diseases.", comment: ""),
                category: .general,
                icon: "flame.slash"
            ),
            HealthTip(
                title: NSLocalizedString("Brain Health", comment: ""),
                description: NSLocalizedString("Fasting may increase the production of brain-derived neurotrophic factor (BDNF), which supports brain health and may protect against neurodegenerative diseases.", comment: ""),
                category: .general,
                icon: "brain"
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
                    description: "Check your blood glucose levels more frequently during fasting periods to ensure they remain within a safe range.",
                    category: .seniorSpecific,
                    icon: "drop.fill"
                ),
                HealthTip(
                    title: "Shorter Fasting Windows",
                    description: "Consider shorter fasting periods (12-14 hours) rather than extended fasts to avoid blood sugar fluctuations.",
                    category: .fasting,
                    icon: "clock"
                ),
                HealthTip(
                    title: "Medication Timing",
                    description: "Work with your healthcare provider to adjust the timing of diabetes medications during fasting periods.",
                    category: .medication,
                    icon: "pills"
                ),
                HealthTip(
                    title: "Break Fast Appropriately",
                    description: "Break your fast with a balanced meal containing protein, healthy fats, and complex carbohydrates to prevent blood sugar spikes.",
                    category: .nutrition,
                    icon: "fork.knife"
                )
            ]
        } else if normalizedCondition.contains("heart") || normalizedCondition.contains("cardiovascular") || normalizedCondition.contains("hypertension") || normalizedCondition.contains("blood pressure") {
            return [
                HealthTip(
                    title: "Monitor Blood Pressure",
                    description: "Check your blood pressure regularly during fasting periods, as fasting can sometimes cause fluctuations.",
                    category: .seniorSpecific,
                    icon: "heart.text.square"
                ),
                HealthTip(
                    title: "Stay Hydrated",
                    description: "Dehydration during fasting can affect blood pressure. Drink plenty of water throughout your fasting window.",
                    category: .hydration,
                    icon: "drop.fill"
                ),
                HealthTip(
                    title: "Maintain Electrolyte Balance",
                    description: "Consider adding a pinch of salt to your water or drinking sugar-free electrolyte beverages during longer fasts.",
                    category: .nutrition,
                    icon: "bolt.fill"
                ),
                HealthTip(
                    title: "Gradual Transition",
                    description: "If you take blood pressure medications, work with your doctor to monitor how fasting affects your blood pressure and adjust medications if necessary.",
                    category: .medication,
                    icon: "arrow.up.right.circle"
                )
            ]
        } else if normalizedCondition.contains("kidney") || normalizedCondition.contains("renal") {
            return [
                HealthTip(
                    title: "Consult Your Nephrologist",
                    description: "Kidney disease requires specialized fasting protocols. Always consult with your kidney specialist before fasting.",
                    category: .seniorSpecific,
                    icon: "person.text.rectangle"
                ),
                HealthTip(
                    title: "Shorter Fasting Periods",
                    description: "Consider time-restricted eating (10-12 hours) rather than extended fasting periods to minimize stress on the kidneys.",
                    category: .fasting,
                    icon: "clock"
                ),
                HealthTip(
                    title: "Hydration Balance",
                    description: "Follow your doctor's recommendations for fluid intake during fasting, as both over-hydration and dehydration can be problematic.",
                    category: .hydration,
                    icon: "drop.fill"
                ),
                HealthTip(
                    title: "Monitor Electrolytes",
                    description: "Kidney disease affects electrolyte balance. Regular monitoring during fasting periods is essential.",
                    category: .seniorSpecific,
                    icon: "bolt.fill"
                )
            ]
        } else if normalizedCondition.contains("thyroid") {
            return [
                HealthTip(
                    title: "Medication Timing",
                    description: "Take thyroid medication on an empty stomach as directed, typically 30-60 minutes before eating.",
                    category: .medication,
                    icon: "pills"
                ),
                HealthTip(
                    title: "Monitor Energy Levels",
                    description: "Pay attention to energy levels during fasting. Excessive fatigue may indicate a need to adjust your fasting schedule.",
                    category: .seniorSpecific,
                    icon: "battery.75"
                ),
                HealthTip(
                    title: "Iodine-Rich Foods",
                    description: "When breaking your fast, include iodine-rich foods like seaweed, fish, or eggs to support thyroid function.",
                    category: .nutrition,
                    icon: "fork.knife"
                ),
                HealthTip(
                    title: "Regular Testing",
                    description: "Continue regular thyroid function tests to ensure your condition remains stable while practicing intermittent fasting.",
                    category: .seniorSpecific,
                    icon: "waveform.path.ecg"
                )
            ]
        } else if normalizedCondition.contains("arthritis") || normalizedCondition.contains("joint") || normalizedCondition.contains("inflammation") {
            return [
                HealthTip(
                    title: "Anti-Inflammatory Benefits",
                    description: "Fasting may help reduce inflammation, potentially providing relief from arthritis symptoms.",
                    category: .seniorSpecific,
                    icon: "flame.slash"
                ),
                HealthTip(
                    title: "Gentle Movement",
                    description: "Incorporate gentle stretching or yoga during fasting periods to maintain joint mobility.",
                    category: .activity,
                    icon: "figure.walk"
                ),
                HealthTip(
                    title: "Anti-Inflammatory Foods",
                    description: "Break your fast with anti-inflammatory foods like fatty fish, berries, turmeric, and leafy greens.",
                    category: .nutrition,
                    icon: "leaf.fill"
                ),
                HealthTip(
                    title: "Medication Timing",
                    description: "If you take anti-inflammatory medications, consult your doctor about optimal timing during your eating window.",
                    category: .medication,
                    icon: "pills"
                )
            ]
        } else if normalizedCondition.contains("gastro") || normalizedCondition.contains("digestive") || normalizedCondition.contains("ibs") || normalizedCondition.contains("bowel") {
            return [
                HealthTip(
                    title: "Digestive Rest",
                    description: "Fasting gives your digestive system time to rest and repair, which may help reduce symptoms.",
                    category: .fasting,
                    icon: "zzz"
                ),
                HealthTip(
                    title: "Gentle Refeeding",
                    description: "Break your fast with easily digestible foods and avoid known trigger foods that aggravate your condition.",
                    category: .nutrition,
                    icon: "fork.knife"
                ),
                HealthTip(
                    title: "Hydration with Care",
                    description: "Stay hydrated but avoid carbonated or caffeinated beverages that might irritate your digestive tract.",
                    category: .hydration,
                    icon: "drop.fill"
                ),
                HealthTip(
                    title: "Probiotic Support",
                    description: "Consider including probiotic-rich foods when breaking your fast to support gut health.",
                    category: .nutrition,
                    icon: "pills.fill"
                )
            ]
        } else if normalizedCondition.contains("osteoporosis") || normalizedCondition.contains("bone") {
            return [
                HealthTip(
                    title: "Calcium Timing",
                    description: "Ensure adequate calcium intake during your eating window. Consider calcium-rich foods like dairy, fortified plant milks, or leafy greens.",
                    category: .nutrition,
                    icon: "cup.and.saucer.fill"
                ),
                HealthTip(
                    title: "Vitamin D",
                    description: "Maintain vitamin D supplementation as recommended by your doctor, as it's crucial for calcium absorption.",
                    category: .medication,
                    icon: "sun.max.fill"
                ),
                HealthTip(
                    title: "Weight-Bearing Exercise",
                    description: "Include weight-bearing exercises during your eating window to help maintain bone density.",
                    category: .activity,
                    icon: "figure.walk"
                ),
                HealthTip(
                    title: "Protein Intake",
                    description: "Ensure adequate protein intake during your eating window, as protein is essential for bone health.",
                    category: .nutrition,
                    icon: "fork.knife"
                )
            ]
        } else {
            // Generic tips for other conditions
            return [
                HealthTip(
                    title: "Consult Your Doctor",
                    description: "Always discuss your fasting regimen with your healthcare provider to ensure it's safe for your specific health condition.",
                    category: .general,
                    icon: "person.text.rectangle"
                ),
                HealthTip(
                    title: "Start Gradually",
                    description: "Begin with shorter fasting periods and gradually extend them as your body adapts.",
                    category: .fasting,
                    icon: "clock"
                ),
                HealthTip(
                    title: "Listen to Your Body",
                    description: "Pay close attention to how your body responds to fasting and adjust your approach accordingly.",
                    category: .seniorSpecific,
                    icon: "ear.fill"
                ),
                HealthTip(
                    title: "Medication Management",
                    description: "Work with your healthcare provider to adjust medication timing if needed to accommodate your fasting schedule.",
                    category: .medication,
                    icon: "pills"
                )
            ]
        }
    }
    
    // MARK: - Text-to-Speech Methods
    
    private func readGeneralTips() {
        var speech = NSLocalizedString("General Fasting Tips", comment: "") + ". "
        
        for tip in generalFastingTips {
            speech += "\(NSLocalizedString(tip.title, comment: "")): \(NSLocalizedString(tip.description, comment: "")) "
        }
        
        TTSRouter.shared.speak(speech, userSettings: userSettings) { success in
            DispatchQueue.main.async {
                isReadingGeneralTips = false
            }
        }
    }
    
    private func readConditionTips() {
        guard let profile = userSettings.userProfile, !profile.medicalConditions.isEmpty else {
            return
        }
        
        var speech = NSLocalizedString("Tips for Your Health Conditions", comment: "") + ". "
        
        for condition in profile.medicalConditions {
            speech += NSLocalizedString("For", comment: "") + " \(condition): "
            
            let tips = healthTipsForCondition(condition)
            for tip in tips {
                speech += "\(NSLocalizedString(tip.title, comment: "")): \(NSLocalizedString(tip.description, comment: "")) "
            }
        }
        
        TTSRouter.shared.speak(speech, userSettings: userSettings) { success in
            DispatchQueue.main.async {
                isReadingConditionTips = false
            }
        }
    }
    
    private func readSafetyTips() {
        var speech = NSLocalizedString("Fasting Safety Guidelines", comment: "") + ". "
        
        for tip in fastingSafetyTips {
            speech += "\(NSLocalizedString(tip.title, comment: "")): \(NSLocalizedString(tip.description, comment: "")) "
        }
        
        TTSRouter.shared.speak(speech, userSettings: userSettings) { success in
            DispatchQueue.main.async {
                isReadingSafetyTips = false
            }
        }
    }
    
    private func readFastingBenefits() {
        var speech = NSLocalizedString("Benefits of Intermittent Fasting", comment: "") + ". "
        
        for tip in fastingBenefits {
            speech += "\(NSLocalizedString(tip.title, comment: "")): \(NSLocalizedString(tip.description, comment: "")) "
        }
        
        TTSRouter.shared.speak(speech, userSettings: userSettings) { success in
            DispatchQueue.main.async {
                isReadingFastingTips = false
            }
        }
    }
}

// MARK: - Health Tip Model is defined in SeniorNutritionApp/Models/HealthTips.swift
