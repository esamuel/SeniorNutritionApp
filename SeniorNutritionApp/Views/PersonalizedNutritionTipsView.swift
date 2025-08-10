import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct PersonalizedNutritionTipsView: View {
    @ObservedObject var ttsRouter = TTSRouter.shared
    @ObservedObject var voiceManager = VoiceManager.shared
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @State private var isReadingGeneralTips = false
    @State private var isReadingConditionTips = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Doctor Note Banner
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.blue)
                        Text("Nutrition tips are for educational purposes only. Always consult your doctor or a registered dietitian before making changes to your diet.")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .padding([.top, .horizontal])
                    
                    generalTipsSection
                    
                    if let profile = userSettings.userProfile, !profile.medicalConditions.isEmpty {
                        medicalConditionTipsSection(conditions: profile.medicalConditions)
                    }
                    
                    if let profile = userSettings.userProfile, !profile.dietaryRestrictions.isEmpty {
                        dietaryRestrictionTipsSection(restrictions: profile.dietaryRestrictions)
                    } else if !userSettings.userDietaryRestrictions.isEmpty {
                        dietaryRestrictionTipsSection(restrictions: userSettings.userDietaryRestrictions)
                    }
                    
                    supplementsSection
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Personalized Nutrition Tips", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var generalTipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            // BMI-specific tips
            if let profile = userSettings.userProfile,
               let bmi = profile.bmi {
                let (icon, title, description) = bmiBasedTip(bmi: bmi)
                nutritionTip(
                    icon: icon,
                    title: title,
                    description: description
                )
            }
            
            nutritionTip(
                icon: "leaf.fill",
                title: NSLocalizedString("Protein is Essential", comment: ""),
                description: NSLocalizedString("Aim for 1-1.2g of protein per kg of body weight daily to maintain muscle mass and strength.", comment: "")
            )
            
            nutritionTip(
                icon: "drop.fill",
                title: NSLocalizedString("Hydration Matters", comment: ""),
                description: NSLocalizedString("Drink at least 8 glasses of water daily, more if you're active or in hot weather.", comment: "")
            )
            
            nutritionTip(
                icon: "heart.fill",
                title: NSLocalizedString("Healthy Fats", comment: ""),
                description: NSLocalizedString("Include sources of omega-3 fatty acids like fatty fish, flaxseeds, and walnuts for heart and brain health.", comment: "")
            )
            
            nutritionTip(
                icon: "flame.fill",
                title: NSLocalizedString("Fiber for Digestion", comment: ""),
                description: NSLocalizedString("Consume 25-30g of fiber daily from fruits, vegetables, and whole grains to maintain digestive health.", comment: "")
            )
            
            nutritionTip(
                icon: "sun.max.fill",
                title: NSLocalizedString("Vitamin D", comment: ""),
                description: NSLocalizedString("Get adequate vitamin D through sunlight exposure and foods like fatty fish, egg yolks, and fortified foods.", comment: "")
            )
            
            // Add citations for general nutrition tips
            CitationsView(categories: [.nutrition, .seniorHealth])
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func medicalConditionTipsSection(conditions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(NSLocalizedString("Tips for Your Medical Conditions", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                Spacer()
                Button(action: {
                    if isReadingConditionTips || TTSRouter.shared.isSpeaking { 
                        TTSRouter.shared.stopSpeaking()
                        isReadingConditionTips = false
                        isReadingGeneralTips = false
                    } else {
                        isReadingConditionTips = true
                        readMedicalConditionTips(conditions)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: (isReadingConditionTips || TTSRouter.shared.isSpeaking) ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if isReadingConditionTips || TTSRouter.shared.isSpeaking {
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
                .accessibilityLabel(NSLocalizedString("Read Medical Condition Tips", comment: ""))
                .accessibilityHint(NSLocalizedString("Reads out nutrition tips for your medical conditions", comment: ""))
            }
            
            ForEach(conditions, id: \.self) { condition in
                let tips = nutritionTipsForCondition(condition)
                ForEach(0..<tips.count, id: \.self) { index in
                    let tip = tips[index]
                    nutritionTip(
                        icon: tip.icon,
                        title: tip.title,
                        description: tip.description
                    )
                }
            }
            
            // Add citations for medical conditions
            CitationsView(categories: [.nutrition, .seniorHealth])
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func dietaryRestrictionTipsSection(restrictions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(NSLocalizedString("Tips for Your Dietary Restrictions", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                Spacer()
                Button(action: {
                    if TTSRouter.shared.isSpeaking { 
                        TTSRouter.shared.stopSpeaking()
                        isReadingConditionTips = false
                        isReadingGeneralTips = false
                    } else {
                        readDietaryRestrictionTips(restrictions)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: TTSRouter.shared.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if TTSRouter.shared.isSpeaking {
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
                .accessibilityLabel(NSLocalizedString("Read Dietary Restriction Tips", comment: ""))
                .accessibilityHint(NSLocalizedString("Reads out nutrition tips for your dietary restrictions", comment: ""))
            }
            
            ForEach(restrictions, id: \.self) { restriction in
                let tips = nutritionTipsForRestriction(restriction)
                ForEach(0..<tips.count, id: \.self) { index in
                    let tip = tips[index]
                    nutritionTip(
                        icon: tip.icon,
                        title: tip.title,
                        description: tip.description
                    )
                }
            }
            
            // Add citations for dietary restrictions
            CitationsView(categories: [.nutrition])
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var supplementsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Supplements to Consider", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            nutritionTip(
                icon: "pills.fill",
                title: NSLocalizedString("Calcium", comment: ""),
                description: NSLocalizedString("Essential for bone health. Consider a supplement if you don't consume enough dairy or fortified foods.", comment: "")
            )
            
            nutritionTip(
                icon: "pills.fill",
                title: NSLocalizedString("Vitamin B12", comment: ""),
                description: NSLocalizedString("Absorption decreases with age. Consider a supplement or consume fortified foods.", comment: "")
            )
            
            nutritionTip(
                icon: "pills.fill",
                title: NSLocalizedString("Vitamin D3", comment: ""),
                description: NSLocalizedString("Important for calcium absorption and immune function. Consider a supplement if you have limited sun exposure.", comment: "")
            )
            
            Text(NSLocalizedString("Note: Always consult with your healthcare provider before starting any supplement regimen.", comment: ""))
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
                .padding(.top, 5)
            
            // Add citations for supplements
            CitationsView(categories: [.nutrition, .seniorHealth])
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func nutritionTip(icon: String, title: String, description: String) -> some View {
        TipRowView(icon: icon, title: title, description: description, textSize: userSettings.textSize.size, iconColor: .green)
    }
    
    // Helper function to get nutrition tips for specific medical conditions
    private func nutritionTipsForCondition(_ condition: String) -> [(icon: String, title: String, description: String)] {
        let lowercaseCondition = condition.lowercased()
        
        if lowercaseCondition.contains("diabetes") {
            return [
                (icon: "chart.line.downtrend.xyaxis", 
                 title: NSLocalizedString("Low Glycemic Foods", comment: ""),
                 description: NSLocalizedString("Choose foods with a low glycemic index like non-starchy vegetables, berries, and whole grains to help manage blood sugar levels.", comment: "")),
                (icon: "clock.fill", 
                 title: NSLocalizedString("Regular Meal Timing", comment: ""),
                 description: NSLocalizedString("Eat meals at consistent times to help maintain stable blood sugar levels.", comment: "")),
                (icon: "carrot.fill", 
                 title: NSLocalizedString("Fiber-Rich Foods", comment: ""),
                 description: NSLocalizedString("Include plenty of fiber in your diet to slow sugar absorption and improve blood glucose control.", comment: ""))
            ]
        } else if lowercaseCondition.contains("heart") || lowercaseCondition.contains("cardiovascular") || lowercaseCondition.contains("hypertension") || lowercaseCondition.contains("blood pressure") {
            return [
                (icon: "heart.slash.fill", 
                 title: NSLocalizedString("Limit Sodium", comment: ""),
                 description: NSLocalizedString("Reduce salt intake to help manage blood pressure. Aim for less than 2,300mg of sodium per day.", comment: "")),
                (icon: "heart.fill", 
                 title: NSLocalizedString("Heart-Healthy Fats", comment: ""),
                 description: NSLocalizedString("Choose unsaturated fats like olive oil, avocados, and nuts while limiting saturated and trans fats.", comment: "")),
                (icon: "leaf.fill", 
                 title: NSLocalizedString("DASH Diet", comment: ""),
                 description: NSLocalizedString("Consider following the DASH (Dietary Approaches to Stop Hypertension) diet, rich in fruits, vegetables, and low-fat dairy.", comment: ""))
            ]
        } else if lowercaseCondition.contains("arthritis") || lowercaseCondition.contains("joint") || lowercaseCondition.contains("inflammation") {
            return [
                (icon: "flame.fill", 
                 title: NSLocalizedString("Anti-Inflammatory Foods", comment: ""),
                 description: NSLocalizedString("Include foods rich in omega-3 fatty acids like fatty fish, walnuts, and flaxseeds to help reduce inflammation.", comment: "")),
                (icon: "tuningfork", 
                 title: NSLocalizedString("Turmeric and Ginger", comment: ""),
                 description: NSLocalizedString("These spices contain compounds that may help reduce inflammation and joint pain.", comment: "")),
                (icon: "xmark.circle.fill", 
                 title: NSLocalizedString("Limit Inflammatory Foods", comment: ""),
                 description: NSLocalizedString("Reduce consumption of processed foods, refined sugars, and excessive omega-6 fatty acids which can increase inflammation.", comment: ""))
            ]
        } else if lowercaseCondition.contains("osteoporosis") || lowercaseCondition.contains("bone") {
            return [
                (icon: "figure.walk", 
                 title: NSLocalizedString("Calcium-Rich Foods", comment: ""),
                 description: NSLocalizedString("Include dairy products, fortified plant milks, leafy greens, and canned fish with bones to support bone health.", comment: "")),
                (icon: "sun.max.fill", 
                 title: NSLocalizedString("Vitamin D", comment: ""),
                 description: NSLocalizedString("Ensure adequate vitamin D intake through sunlight exposure, fatty fish, and fortified foods to help calcium absorption.", comment: "")),
                (icon: "pills.fill", 
                 title: NSLocalizedString("Magnesium and Vitamin K", comment: ""),
                 description: NSLocalizedString("These nutrients work with calcium to build bone. Find them in nuts, seeds, leafy greens, and fermented foods.", comment: ""))
            ]
        } else if lowercaseCondition.contains("kidney") {
            return [
                (icon: "drop.fill", 
                 title: NSLocalizedString("Fluid Management", comment: ""),
                 description: NSLocalizedString("Monitor your fluid intake according to your doctor's recommendations.", comment: "")),
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Phosphorus and Potassium", comment: ""),
                 description: NSLocalizedString("You may need to limit foods high in phosphorus and potassium. Consult with a renal dietitian for personalized advice.", comment: "")),
                (icon: "fork.knife", 
                 title: NSLocalizedString("Protein Balance", comment: ""),
                 description: NSLocalizedString("Balance protein intake - too much can strain kidneys, too little can lead to malnutrition. Follow your doctor's guidance.", comment: ""))
            ]
        } else if lowercaseCondition.contains("celiac") || lowercaseCondition.contains("gluten") {
            return [
                (icon: "exclamationmark.shield.fill", 
                 title: NSLocalizedString("Strict Gluten Avoidance", comment: ""),
                 description: NSLocalizedString("Avoid all sources of gluten including wheat, barley, rye, and foods that may be cross-contaminated.", comment: "")),
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Nutrient-Dense Alternatives", comment: ""),
                 description: NSLocalizedString("Choose naturally gluten-free whole foods like quinoa, rice, buckwheat, and amaranth for essential nutrients.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Label Reading", comment: ""),
                 description: NSLocalizedString("Always check food labels for hidden sources of gluten and cross-contamination warnings.", comment: ""))
            ]
        } else {
            // Generic tips for other conditions
            return [
                (icon: "person.fill", 
                 title: NSLocalizedString("Personalized Nutrition", comment: ""),
                 description: NSLocalizedString("Consider consulting with a registered dietitian for nutrition advice tailored to your specific medical condition.", comment: "")),
                (icon: "doc.text.fill", 
                 title: NSLocalizedString("Keep a Food Journal", comment: ""),
                 description: NSLocalizedString("Track how different foods affect your symptoms to identify patterns and triggers.", comment: "")),
                (icon: "heart.text.square.fill", 
                 title: NSLocalizedString("Balanced Approach", comment: ""),
                 description: NSLocalizedString("Focus on a balanced diet rich in whole foods while limiting processed foods and added sugars.", comment: ""))
            ]
        }
    }
    
    // Helper function to get nutrition tips for specific dietary restrictions
    private func nutritionTipsForRestriction(_ restriction: String) -> [(icon: String, title: String, description: String)] {
        let lowercaseRestriction = restriction.lowercased()
        
        if lowercaseRestriction.contains("vegetarian") {
            return [
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Complete Proteins", comment: ""),
                 description: NSLocalizedString("Combine plant proteins like beans and rice to get all essential amino acids.", comment: "")),
                (icon: "pills.fill", 
                 title: NSLocalizedString("Vitamin B12", comment: ""),
                 description: NSLocalizedString("Consider B12 supplements or fortified foods as this vitamin is primarily found in animal products.", comment: "")),
                (icon: "drop.fill", 
                 title: NSLocalizedString("Iron Sources", comment: ""),
                 description: NSLocalizedString("Include plant sources of iron like lentils, spinach, and fortified cereals, and pair with vitamin C for better absorption.", comment: ""))
            ]
        } else if lowercaseRestriction.contains("vegan") {
            return [
                (icon: "pills.fill", 
                 title: NSLocalizedString("Essential Supplements", comment: ""),
                 description: NSLocalizedString("Consider supplements for vitamin B12, vitamin D, omega-3 fatty acids, and possibly iodine and zinc.", comment: "")),
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Protein Variety", comment: ""),
                 description: NSLocalizedString("Include a variety of plant proteins daily: legumes, tofu, tempeh, seitan, nuts, and seeds.", comment: "")),
                (icon: "drop.fill", 
                 title: NSLocalizedString("Calcium Sources", comment: ""),
                 description: NSLocalizedString("Consume calcium-rich plant foods like fortified plant milks, tofu made with calcium sulfate, and leafy greens.", comment: ""))
            ]
        } else if lowercaseRestriction.contains("dairy") || lowercaseRestriction.contains("lactose") {
            return [
                (icon: "drop.fill", 
                 title: NSLocalizedString("Calcium Alternatives", comment: ""),
                 description: NSLocalizedString("Include non-dairy calcium sources like fortified plant milks, tofu, leafy greens, and canned fish with bones.", comment: "")),
                (icon: "sun.max.fill", 
                 title: NSLocalizedString("Vitamin D", comment: ""),
                 description: NSLocalizedString("Ensure adequate vitamin D from sunlight, supplements, or fortified foods to help with calcium absorption.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Hidden Dairy", comment: ""),
                 description: NSLocalizedString("Check labels for ingredients like whey, casein, and lactose which indicate dairy content.", comment: ""))
            ]
        } else if lowercaseRestriction.contains("gluten") {
            return [
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Whole Food Alternatives", comment: ""),
                 description: NSLocalizedString("Choose naturally gluten-free whole grains like rice, quinoa, buckwheat, and millet for essential nutrients.", comment: "")),
                (icon: "exclamationmark.shield.fill", 
                 title: NSLocalizedString("Cross-Contamination", comment: ""),
                 description: NSLocalizedString("Be aware of cross-contamination in food preparation. Use separate utensils and preparation areas.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Nutrient Deficiencies", comment: ""),
                 description: NSLocalizedString("Gluten-free products are often lower in B vitamins, iron, and fiber. Choose fortified options or take supplements if needed.", comment: ""))
            ]
        } else if lowercaseRestriction.contains("nut") || lowercaseRestriction.contains("peanut") {
            return [
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Alternative Proteins", comment: ""),
                 description: NSLocalizedString("Include seeds like sunflower, pumpkin, and chia seeds for similar nutritional benefits.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Hidden Sources", comment: ""),
                 description: NSLocalizedString("Be vigilant about checking food labels for nut ingredients and 'may contain' warnings.", comment: "")),
                (icon: "fork.knife", 
                 title: NSLocalizedString("Nutrient Replacement", comment: ""),
                 description: NSLocalizedString("Ensure adequate intake of vitamin E, magnesium, and healthy fats from other sources like avocados and olive oil.", comment: ""))
            ]
        } else if lowercaseRestriction.contains("low sodium") || lowercaseRestriction.contains("salt") {
            return [
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Herbs and Spices", comment: ""),
                 description: NSLocalizedString("Use herbs, spices, citrus, and vinegar to add flavor to foods without adding sodium.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Processed Foods", comment: ""),
                 description: NSLocalizedString("Limit processed and packaged foods which often contain high amounts of hidden sodium.", comment: "")),
                (icon: "house.fill", 
                 title: NSLocalizedString("Home Cooking", comment: ""),
                 description: NSLocalizedString("Prepare meals at home to control sodium content and gradually reduce salt to allow your taste buds to adjust.", comment: ""))
            ]
        } else if lowercaseRestriction.contains("low sugar") || lowercaseRestriction.contains("sugar free") {
            return [
                (icon: "leaf.fill", 
                 title: NSLocalizedString("Natural Sweeteners", comment: ""),
                 description: NSLocalizedString("Use small amounts of fruit or spices like cinnamon to add sweetness to foods without added sugar.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Hidden Sugars", comment: ""),
                 description: NSLocalizedString("Check labels for ingredients ending in '-ose' (like fructose, glucose) and terms like 'syrup' or 'concentrate'.", comment: "")),
                (icon: "chart.line.downtrend.xyaxis", 
                 title: NSLocalizedString("Gradual Reduction", comment: ""),
                 description: NSLocalizedString("Gradually reduce sugar intake to allow your taste preferences to adjust over time.", comment: ""))
            ]
        } else {
            // Generic tips for other restrictions
            return [
                (icon: "person.fill", 
                 title: NSLocalizedString("Personalized Advice", comment: ""),
                 description: NSLocalizedString("Consider consulting with a registered dietitian for personalized guidance on your specific dietary restriction.", comment: "")),
                (icon: "cart.fill", 
                 title: NSLocalizedString("Label Reading", comment: ""),
                 description: NSLocalizedString("Become proficient at reading food labels to identify ingredients you need to avoid.", comment: "")),
                (icon: "fork.knife", 
                 title: NSLocalizedString("Nutrient Balance", comment: ""),
                 description: NSLocalizedString("Ensure your restricted diet still provides all essential nutrients through careful food choices or supplements if necessary.", comment: ""))
            ]
        }
    }
    
    // Helper methods for text-to-speech
    private func bmiBasedTip(bmi: Double) -> (icon: String, title: String, description: String) {
        if bmi >= 30 {
            return ("scale.3d",
                    NSLocalizedString("Weight Management Focus", comment: ""),
                    NSLocalizedString("Focus on nutrient-dense, lower-calorie foods. Include plenty of vegetables, lean proteins, and high-fiber foods to feel satisfied while managing portions.", comment: ""))
        } else if bmi >= 25 {
            return ("figure.walk",
                    NSLocalizedString("Balanced Nutrition", comment: ""),
                    NSLocalizedString("Maintain a balanced diet with portion control. Choose whole grains, lean proteins, and plenty of vegetables to support healthy weight management.", comment: ""))
        } else if bmi < 18.5 {
            return ("plus.circle",
                    NSLocalizedString("Nutrient-Rich Foods", comment: ""),
                    NSLocalizedString("Include nutrient-dense foods with healthy fats like nuts, avocados, and olive oil. Focus on protein-rich foods to support healthy weight gain.", comment: ""))
        } else {
            return ("heart.circle",
                    NSLocalizedString("Maintain Healthy Balance", comment: ""),
                    NSLocalizedString("Continue with a balanced diet rich in whole foods. Include a variety of nutrients to maintain your healthy weight.", comment: ""))
        }
    }
    
    private func readGeneralTips() {
        var speech = NSLocalizedString("General Nutrition Tips for Seniors", comment: "") + ". "
        
        if let profile = userSettings.userProfile,
           let bmi = profile.bmi {
            let tip = bmiBasedTip(bmi: bmi)
            speech += "\(tip.title): \(tip.description) "
        }
        
        speech += 
                   NSLocalizedString("Protein is Essential", comment: "") + ": " + 
                   NSLocalizedString("Aim for 1-1.2g of protein per kg of body weight daily to maintain muscle mass and strength.", comment: "") + " " +
                   NSLocalizedString("Hydration Matters", comment: "") + ": " + 
                   NSLocalizedString("Drink at least 8 glasses of water daily, more if you're active or in hot weather.", comment: "") + " " +
                   NSLocalizedString("Healthy Fats", comment: "") + ": " + 
                   NSLocalizedString("Include sources of omega-3 fatty acids like fatty fish, flaxseeds, and walnuts for heart and brain health.", comment: "") + " " +
                   NSLocalizedString("Fiber for Digestion", comment: "") + ": " + 
                   NSLocalizedString("Consume 25-30g of fiber daily from fruits, vegetables, and whole grains to maintain digestive health.", comment: "") + " " +
                   NSLocalizedString("Vitamin D", comment: "") + ": " + 
                   NSLocalizedString("Get adequate vitamin D through sunlight exposure and foods like fatty fish, egg yolks, and fortified foods.", comment: "")
        
        TTSRouter.shared.speak(speech, userSettings: userSettings) { success in
            DispatchQueue.main.async {
                isReadingGeneralTips = false
            }
        }
    }
    
    private func readMedicalConditionTips(_ conditions: [String]) {
        var speech = NSLocalizedString("Tips for Your Medical Conditions", comment: "") + ". "
        
        for condition in conditions {
            let tips = nutritionTipsForCondition(condition)
            speech += NSLocalizedString("For", comment: "") + " \(condition): "
            
            for tip in tips {
                speech += "\(tip.title): \(tip.description) "
            }
        }
        
        TTSRouter.shared.speak(speech, userSettings: userSettings) { success in
            DispatchQueue.main.async {
                isReadingConditionTips = false
            }
        }
    }
    
    private func readDietaryRestrictionTips(_ restrictions: [String]) {
        var speech = NSLocalizedString("Tips for Your Dietary Restrictions", comment: "") + ". "
        
        for restriction in restrictions {
            let tips = nutritionTipsForRestriction(restriction)
            speech += NSLocalizedString("For", comment: "") + " \(restriction): "
            
            for tip in tips {
                speech += "\(tip.title): \(tip.description) "
            }
        }
        
        TTSRouter.shared.speak(speech, userSettings: userSettings)
    }
    
    private func readSupplementTips() {
        let speech = NSLocalizedString("Supplements to Consider", comment: "") + ". " +
                   NSLocalizedString("Calcium", comment: "") + ": " + NSLocalizedString("Essential for bone health. Consider a supplement if you don't consume enough dairy or fortified foods.", comment: "") + " " +
                   NSLocalizedString("Vitamin B12", comment: "") + ": " + NSLocalizedString("Absorption decreases with age. Consider a supplement or consume fortified foods.", comment: "") + " " +
                   NSLocalizedString("Vitamin D3", comment: "") + ": " + NSLocalizedString("Important for calcium absorption and immune function. Consider a supplement if you have limited sun exposure.", comment: "") + " " +
                   NSLocalizedString("Note: Always consult with your healthcare provider before starting any supplement regimen.", comment: "")
        
        TTSRouter.shared.speak(speech, userSettings: userSettings)
    }
}

struct PersonalizedNutritionTipsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizedNutritionTipsView()
            .environmentObject(UserSettings())
    }
}
