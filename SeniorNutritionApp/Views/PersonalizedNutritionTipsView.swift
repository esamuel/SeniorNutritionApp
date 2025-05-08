import SwiftUI

struct PersonalizedNutritionTipsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var voiceManager = VoiceManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
            .navigationTitle("Personalized Nutrition Tips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var generalTipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("General Nutrition Tips for Seniors")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    readGeneralTips()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if voiceManager.isSpeaking {
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
                .accessibilityLabel("Read General Tips")
                .accessibilityHint("Reads out general nutrition tips for seniors")
            }
            
            nutritionTip(
                icon: "leaf.fill",
                title: "Protein is Essential",
                description: "Aim for 1-1.2g of protein per kg of body weight daily to maintain muscle mass and strength."
            )
            
            nutritionTip(
                icon: "drop.fill",
                title: "Hydration Matters",
                description: "Drink at least 8 glasses of water daily, more if you're active or in hot weather."
            )
            
            nutritionTip(
                icon: "heart.fill",
                title: "Healthy Fats",
                description: "Include sources of omega-3 fatty acids like fatty fish, flaxseeds, and walnuts for heart and brain health."
            )
            
            nutritionTip(
                icon: "flame.fill",
                title: "Fiber for Digestion",
                description: "Consume 25-30g of fiber daily from fruits, vegetables, and whole grains to maintain digestive health."
            )
            
            nutritionTip(
                icon: "sun.max.fill",
                title: "Vitamin D",
                description: "Get adequate vitamin D through sunlight exposure and foods like fatty fish, egg yolks, and fortified foods."
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func medicalConditionTipsSection(conditions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Tips for Your Medical Conditions")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    readMedicalConditionTips(conditions)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if voiceManager.isSpeaking {
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
                .accessibilityLabel("Read Medical Condition Tips")
                .accessibilityHint("Reads out nutrition tips for your medical conditions")
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
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func dietaryRestrictionTipsSection(restrictions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Tips for Your Dietary Restrictions")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    readDietaryRestrictionTips(restrictions)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if voiceManager.isSpeaking {
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
                .accessibilityLabel("Read Dietary Restriction Tips")
                .accessibilityHint("Reads out nutrition tips for your dietary restrictions")
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
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var supplementsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Supplements to Consider")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    readSupplementTips()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if voiceManager.isSpeaking {
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
                .accessibilityLabel("Read Supplement Tips")
                .accessibilityHint("Reads out supplement recommendations for seniors")
            }
            
            nutritionTip(
                icon: "pills.fill",
                title: "Calcium",
                description: "Essential for bone health. Consider a supplement if you don't consume enough dairy or fortified foods."
            )
            
            nutritionTip(
                icon: "pills.fill",
                title: "Vitamin B12",
                description: "Absorption decreases with age. Consider a supplement or consume fortified foods."
            )
            
            nutritionTip(
                icon: "pills.fill",
                title: "Vitamin D3",
                description: "Important for calcium absorption and immune function. Consider a supplement if you have limited sun exposure."
            )
            
            Text("Note: Always consult with your healthcare provider before starting any supplement regimen.")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
                .padding(.top, 5)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func nutritionTip(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                Text(description)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 5)
    }
    
    // Helper function to get nutrition tips for specific medical conditions
    private func nutritionTipsForCondition(_ condition: String) -> [(icon: String, title: String, description: String)] {
        let lowercaseCondition = condition.lowercased()
        
        if lowercaseCondition.contains("diabetes") {
            return [
                (icon: "chart.line.downtrend.xyaxis", title: "Low Glycemic Foods",
                 description: "Choose foods with a low glycemic index like non-starchy vegetables, berries, and whole grains to help manage blood sugar levels."),
                (icon: "clock.fill", title: "Regular Meal Timing",
                 description: "Eat meals at consistent times to help maintain stable blood sugar levels."),
                (icon: "carrot.fill", title: "Fiber-Rich Foods",
                 description: "Include plenty of fiber in your diet to slow sugar absorption and improve blood glucose control.")
            ]
        } else if lowercaseCondition.contains("heart") || lowercaseCondition.contains("cardiovascular") || lowercaseCondition.contains("hypertension") || lowercaseCondition.contains("blood pressure") {
            return [
                (icon: "heart.slash.fill", title: "Limit Sodium",
                 description: "Reduce salt intake to help manage blood pressure. Aim for less than 2,300mg of sodium per day."),
                (icon: "heart.fill", title: "Heart-Healthy Fats",
                 description: "Choose unsaturated fats like olive oil, avocados, and nuts while limiting saturated and trans fats."),
                (icon: "leaf.fill", title: "DASH Diet",
                 description: "Consider following the DASH (Dietary Approaches to Stop Hypertension) diet, rich in fruits, vegetables, and low-fat dairy.")
            ]
        } else if lowercaseCondition.contains("arthritis") || lowercaseCondition.contains("joint") || lowercaseCondition.contains("inflammation") {
            return [
                (icon: "flame.fill", title: "Anti-Inflammatory Foods",
                 description: "Include foods rich in omega-3 fatty acids like fatty fish, walnuts, and flaxseeds to help reduce inflammation."),
                (icon: "tuningfork", title: "Turmeric and Ginger",
                 description: "These spices contain compounds that may help reduce inflammation and joint pain."),
                (icon: "xmark.circle.fill", title: "Limit Inflammatory Foods",
                 description: "Reduce consumption of processed foods, refined sugars, and excessive omega-6 fatty acids which can increase inflammation.")
            ]
        } else if lowercaseCondition.contains("osteoporosis") || lowercaseCondition.contains("bone") {
            return [
                (icon: "figure.walk", title: "Calcium-Rich Foods",
                 description: "Include dairy products, fortified plant milks, leafy greens, and canned fish with bones to support bone health."),
                (icon: "sun.max.fill", title: "Vitamin D",
                 description: "Ensure adequate vitamin D intake through sunlight exposure, fatty fish, and fortified foods to help calcium absorption."),
                (icon: "pills.fill", title: "Magnesium and Vitamin K",
                 description: "These nutrients work with calcium to build bone. Find them in nuts, seeds, leafy greens, and fermented foods.")
            ]
        } else if lowercaseCondition.contains("kidney") {
            return [
                (icon: "drop.fill", title: "Fluid Management",
                 description: "Monitor your fluid intake according to your doctor's recommendations."),
                (icon: "leaf.fill", title: "Phosphorus and Potassium",
                 description: "You may need to limit foods high in phosphorus and potassium. Consult with a renal dietitian for personalized advice."),
                (icon: "fork.knife", title: "Protein Balance",
                 description: "Balance protein intake - too much can strain kidneys, too little can lead to malnutrition. Follow your doctor's guidance.")
            ]
        } else if lowercaseCondition.contains("celiac") || lowercaseCondition.contains("gluten") {
            return [
                (icon: "exclamationmark.shield.fill", title: "Strict Gluten Avoidance",
                 description: "Avoid all sources of gluten including wheat, barley, rye, and foods that may be cross-contaminated."),
                (icon: "leaf.fill", title: "Nutrient-Dense Alternatives",
                 description: "Choose naturally gluten-free whole foods like quinoa, rice, buckwheat, and amaranth for essential nutrients."),
                (icon: "cart.fill", title: "Label Reading",
                 description: "Always check food labels for hidden sources of gluten and cross-contamination warnings.")
            ]
        } else {
            // Generic tips for other conditions
            return [
                (icon: "person.fill", title: "Personalized Nutrition",
                 description: "Consider consulting with a registered dietitian for nutrition advice tailored to your specific medical condition."),
                (icon: "doc.text.fill", title: "Keep a Food Journal",
                 description: "Track how different foods affect your symptoms to identify patterns and triggers."),
                (icon: "heart.text.square.fill", title: "Balanced Approach",
                 description: "Focus on a balanced diet rich in whole foods while limiting processed foods and added sugars.")
            ]
        }
    }
    
    // Helper function to get nutrition tips for specific dietary restrictions
    private func nutritionTipsForRestriction(_ restriction: String) -> [(icon: String, title: String, description: String)] {
        let lowercaseRestriction = restriction.lowercased()
        
        if lowercaseRestriction.contains("vegetarian") {
            return [
                (icon: "leaf.fill", title: "Complete Proteins",
                 description: "Combine plant proteins like beans and rice to get all essential amino acids."),
                (icon: "pills.fill", title: "Vitamin B12",
                 description: "Consider B12 supplements or fortified foods as this vitamin is primarily found in animal products."),
                (icon: "drop.fill", title: "Iron Sources",
                 description: "Include plant sources of iron like lentils, spinach, and fortified cereals, and pair with vitamin C for better absorption.")
            ]
        } else if lowercaseRestriction.contains("vegan") {
            return [
                (icon: "pills.fill", title: "Essential Supplements",
                 description: "Consider supplements for vitamin B12, vitamin D, omega-3 fatty acids, and possibly iodine and zinc."),
                (icon: "leaf.fill", title: "Protein Variety",
                 description: "Include a variety of plant proteins daily: legumes, tofu, tempeh, seitan, nuts, and seeds."),
                (icon: "drop.fill", title: "Calcium Sources",
                 description: "Consume calcium-rich plant foods like fortified plant milks, tofu made with calcium sulfate, and leafy greens.")
            ]
        } else if lowercaseRestriction.contains("dairy") || lowercaseRestriction.contains("lactose") {
            return [
                (icon: "drop.fill", title: "Calcium Alternatives",
                 description: "Include non-dairy calcium sources like fortified plant milks, tofu, leafy greens, and canned fish with bones."),
                (icon: "sun.max.fill", title: "Vitamin D",
                 description: "Ensure adequate vitamin D from sunlight, supplements, or fortified foods to help with calcium absorption."),
                (icon: "cart.fill", title: "Hidden Dairy",
                 description: "Check labels for ingredients like whey, casein, and lactose which indicate dairy content.")
            ]
        } else if lowercaseRestriction.contains("gluten") {
            return [
                (icon: "leaf.fill", title: "Whole Food Alternatives",
                 description: "Choose naturally gluten-free whole grains like rice, quinoa, buckwheat, and millet for essential nutrients."),
                (icon: "exclamationmark.shield.fill", title: "Cross-Contamination",
                 description: "Be aware of cross-contamination in food preparation. Use separate utensils and preparation areas."),
                (icon: "cart.fill", title: "Nutrient Deficiencies",
                 description: "Gluten-free products are often lower in B vitamins, iron, and fiber. Choose fortified options or take supplements if needed.")
            ]
        } else if lowercaseRestriction.contains("nut") || lowercaseRestriction.contains("peanut") {
            return [
                (icon: "leaf.fill", title: "Alternative Proteins",
                 description: "Include seeds like sunflower, pumpkin, and chia seeds for similar nutritional benefits."),
                (icon: "cart.fill", title: "Hidden Sources",
                 description: "Be vigilant about checking food labels for nut ingredients and 'may contain' warnings."),
                (icon: "fork.knife", title: "Nutrient Replacement",
                 description: "Ensure adequate intake of vitamin E, magnesium, and healthy fats from other sources like avocados and olive oil.")
            ]
        } else if lowercaseRestriction.contains("low sodium") || lowercaseRestriction.contains("salt") {
            return [
                (icon: "leaf.fill", title: "Herbs and Spices",
                 description: "Use herbs, spices, citrus, and vinegar to add flavor to foods without adding sodium."),
                (icon: "cart.fill", title: "Processed Foods",
                 description: "Limit processed and packaged foods which often contain high amounts of hidden sodium."),
                (icon: "house.fill", title: "Home Cooking",
                 description: "Prepare meals at home to control sodium content and gradually reduce salt to allow your taste buds to adjust.")
            ]
        } else if lowercaseRestriction.contains("low sugar") || lowercaseRestriction.contains("sugar free") {
            return [
                (icon: "leaf.fill", title: "Natural Sweeteners",
                 description: "Use small amounts of fruit or spices like cinnamon to add sweetness to foods without added sugar."),
                (icon: "cart.fill", title: "Hidden Sugars",
                 description: "Check labels for ingredients ending in '-ose' (like fructose, glucose) and terms like 'syrup' or 'concentrate'."),
                (icon: "chart.line.downtrend.xyaxis", title: "Gradual Reduction",
                 description: "Gradually reduce sugar intake to allow your taste preferences to adjust over time.")
            ]
        } else {
            // Generic tips for other restrictions
            return [
                (icon: "person.fill", title: "Personalized Advice",
                 description: "Consider consulting with a registered dietitian for personalized guidance on your specific dietary restriction."),
                (icon: "cart.fill", title: "Label Reading",
                 description: "Become proficient at reading food labels to identify ingredients you need to avoid."),
                (icon: "fork.knife", title: "Nutrient Balance",
                 description: "Ensure your restricted diet still provides all essential nutrients through careful food choices or supplements if necessary.")
            ]
        }
    }
    
    // Helper methods for text-to-speech
    private func readGeneralTips() {
        let speech = "General Nutrition Tips for Seniors. " +
                   "Protein is Essential: Aim for 1-1.2g of protein per kg of body weight daily to maintain muscle mass and strength. " +
                   "Hydration Matters: Drink at least 8 glasses of water daily, more if you're active or in hot weather. " +
                   "Healthy Fats: Include sources of omega-3 fatty acids like fatty fish, flaxseeds, and walnuts for heart and brain health. " +
                   "Fiber for Digestion: Consume 25-30g of fiber daily from fruits, vegetables, and whole grains to maintain digestive health. " +
                   "Vitamin D: Get adequate vitamin D through sunlight exposure and foods like fatty fish, egg yolks, and fortified foods."
        
        voiceManager.speak(speech)
    }
    
    private func readMedicalConditionTips(_ conditions: [String]) {
        var speech = "Tips for Your Medical Conditions. "
        
        for condition in conditions {
            let tips = nutritionTipsForCondition(condition)
            speech += "For \(condition): "
            
            for tip in tips {
                speech += "\(tip.title): \(tip.description) "
            }
        }
        
        voiceManager.speak(speech)
    }
    
    private func readDietaryRestrictionTips(_ restrictions: [String]) {
        var speech = "Tips for Your Dietary Restrictions. "
        
        for restriction in restrictions {
            let tips = nutritionTipsForRestriction(restriction)
            speech += "For \(restriction): "
            
            for tip in tips {
                speech += "\(tip.title): \(tip.description) "
            }
        }
        
        voiceManager.speak(speech)
    }
    
    private func readSupplementTips() {
        let speech = "Supplements to Consider. " +
                   "Calcium: Essential for bone health. Consider a supplement if you don't consume enough dairy or fortified foods. " +
                   "Vitamin B12: Absorption decreases with age. Consider a supplement or consume fortified foods. " +
                   "Vitamin D3: Important for calcium absorption and immune function. Consider a supplement if you have limited sun exposure. " +
                   "Note: Always consult with your healthcare provider before starting any supplement regimen."
        
        voiceManager.speak(speech)
    }
}

struct PersonalizedNutritionTipsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizedNutritionTipsView()
            .environmentObject(UserSettings())
    }
}
