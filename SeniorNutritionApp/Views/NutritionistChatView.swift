import SwiftUI

struct NutritionistChatView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var chatService: NutritionistChatService
    
    @State private var messageText = ""
    @State private var showingUpgradeSheet = false
    @FocusState private var isTextFieldFocused: Bool
    
    init() {
        self._chatService = StateObject(wrappedValue: NutritionistChatService())
    }
    
    private var statusMessage: String {
        if chatService.isConnected {
            return "AI Nutritionist Ready"
        } else {
            return "Fallback Mode (Start Ollama for AI)"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Premium Feature Header
                if !premiumManager.hasFullAccess {
                    premiumHeader
                }
                
                if premiumManager.hasFullAccess {
                    // Chat Interface
                    VStack(spacing: 0) {
                        // Chat Status Bar
                        chatStatusBar
                        
                        // Messages List
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(chatService.messages) { message in
                                        MessageBubble(message: message)
                                    }
                                }
                                .padding()
                            }
                            .onChange(of: chatService.messages.count) {
                                if let lastMessage = chatService.messages.last {
                                    withAnimation {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        
                        // Message Input
                        messageInputBar
                    }
                } else {
                    Spacer()
                }
            }
            .navigationTitle("Nutritionist Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .onAppear {
                // Set user settings reference for personalized responses
                chatService.setUserSettings(userSettings)
                
                // Force check Ollama connection
                Task {
                    await chatService.aiNutritionService.forceConnectionCheck()
                }
                
                if premiumManager.hasFullAccess && chatService.messages.isEmpty {
                    chatService.sendWelcomeMessage()
                }
            }
            .sheet(isPresented: $showingUpgradeSheet) {
                PremiumFeaturesView()
            }
        }
    }
    
    private var premiumHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                Text("Premium Feature")
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    .foregroundColor(.purple)
            }
            
            VStack(spacing: 8) {
                Text("1-on-1 Nutritionist Chat")
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Text("Connect with certified nutrition professionals for personalized guidance on your health journey")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: {
                showingUpgradeSheet = true
            }) {
                Text("Upgrade to Premium")
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
    }
    
    private var chatStatusBar: some View {
        HStack {
            Circle()
                .fill(chatService.isConnected ? Color.green : Color.orange)
                .frame(width: 8, height: 8)
            
            Text(statusMessage)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
            
            Spacer()
            
            if chatService.isTyping {
                HStack(spacing: 4) {
                    Text(chatService.isConnected ? "AI is thinking" : "Processing")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    
                    TypingIndicator()
                }
            } else {
                Button(action: {
                    Task {
                        await chatService.aiNutritionService.forceConnectionCheck()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private var messageInputBar: some View {
        HStack(spacing: 12) {
            TextField("Type your message...", text: $messageText, axis: .vertical)
                .font(.system(size: userSettings.textSize.size))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .cornerRadius(20)
                .focused($isTextFieldFocused)
                .lineLimit(1...4)
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        chatService.sendMessage(text)
        messageText = ""
    }
}

struct MessageBubble: View {
    @EnvironmentObject private var userSettings: UserSettings
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                if !message.isFromUser {
                    HStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text("Nutritionist")
                            .font(.system(size: userSettings.textSize.size - 4, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
                
                Text(message.text)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(message.isFromUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(formatTime(message.timestamp))
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromUser {
                Spacer(minLength: 50)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TypingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 4, height: 4)
                    .scaleEffect(animating ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

// MARK: - Chat Models and Service

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
    
    init(text: String, isFromUser: Bool) {
        self.text = text
        self.isFromUser = isFromUser
        self.timestamp = Date()
    }
}

@MainActor
class NutritionistChatService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isConnected = false
    @Published var isTyping = false
    
    // AI-powered nutrition service (exposed for connection checking)
    let aiNutritionService = UnifiedAINutritionService()
    
    // Fallback knowledge base for when AI is unavailable
    private let nutritionKnowledgeBase = NutritionKnowledgeBase()
    
    // Reference to user settings for personalized responses
    private weak var userSettings: UserSettings?
    
    private let predefinedResponses = [
        "Thank you for reaching out! I'm here to help you with your nutrition goals.",
        "That's a great question about nutrition. Based on your profile, I'd recommend focusing on balanced meals with adequate protein.",
        "For seniors, it's particularly important to maintain bone health through calcium and vitamin D intake.",
        "I understand your concerns about dietary restrictions. Let's work together to find suitable alternatives.",
        "Remember, small changes in your diet can lead to significant health improvements over time.",
        "Have you been tracking your water intake? Proper hydration is crucial for overall health.",
        "I'd suggest discussing these dietary changes with your healthcare provider as well.",
        "Your fasting schedule looks good! Make sure you're getting proper nutrition during your eating windows."
    ]
    
    init(userSettings: UserSettings? = nil) {
        self.userSettings = userSettings
        
        // Monitor AI service availability
        aiNutritionService.$isAvailable
            .assign(to: &$isConnected)
        
        // Initial connection check
        Task {
            await aiNutritionService.checkOllamaStatus()
        }
    }
    
    func setUserSettings(_ settings: UserSettings) {
        self.userSettings = settings
    }
    
    func sendWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            text: "Hello! I'm your certified nutritionist. I'm here to help you with personalized nutrition advice, meal planning, and answering any questions about your dietary needs. How can I assist you today?",
            isFromUser: false
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage(_ text: String) {
        // Add user message
        let userMessage = ChatMessage(text: text, isFromUser: true)
        messages.append(userMessage)
        
        // Simulate nutritionist typing
        isTyping = true
        
        // Generate AI response (with realistic delay)
        Task { @MainActor in
            // Add a minimum delay for better UX
            try? await Task.sleep(nanoseconds: UInt64(Double.random(in: 1...2) * 1_000_000_000))
            
            let response = await self.generateResponse(for: text)
            
            self.isTyping = false
            let nutritionistMessage = ChatMessage(text: response, isFromUser: false)
            self.messages.append(nutritionistMessage)
        }
    }
    
    @MainActor
    private func generateResponse(for userMessage: String) async -> String {
        // Get user context for personalized responses
        guard let userSettings = userSettings else {
            return predefinedResponses.randomElement() ?? "Thank you for your question. Could you provide more details so I can give you more specific guidance?"
        }
        
        let userProfile = userSettings.userProfile
        let dietaryRestrictions = userSettings.userDietaryRestrictions
        let healthGoals = userSettings.userHealthGoals
        let medications = userSettings.medications
        let age = userProfile?.age ?? userSettings.userAge
        
        // Use AI-powered nutrition service (with fallback to keyword-based)
        return await aiNutritionService.generateNutritionResponse(
            userMessage: userMessage,
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: healthGoals,
            medications: medications,
            age: age
        )
    }
}

// MARK: - Comprehensive Nutrition Knowledge Base

class NutritionKnowledgeBase {
    
    func generateNutritionResponse(
        userMessage: String,
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        medications: [Medication],
        age: Int
    ) -> String? {
        
        // PRIORITY ORDER: Most specific queries first
        
        // Hydration queries - MOVED TO TOP for priority
        if (userMessage.contains("fluid") && (userMessage.contains("goal") || userMessage.contains("daily") || userMessage.contains("need"))) ||
           (userMessage.contains("water") && (userMessage.contains("goal") || userMessage.contains("daily") || userMessage.contains("much"))) ||
           userMessage.contains("hydration goal") ||
           userMessage.contains("how much water") ||
           userMessage.contains("how much fluid") ||
           userMessage.contains("fluid intake") ||
           userMessage.contains("water intake") ||
           (userMessage.contains("drink") && userMessage.contains("daily")) {
            return generateHydrationResponse(userMessage: userMessage, age: age)
        }
        
        // Specific nutrient queries
        if userMessage.contains("vitamin b12") || userMessage.contains("b12") ||
           userMessage.contains("iron deficiency") || userMessage.contains("low iron") ||
           userMessage.contains("calcium deficiency") || 
           (userMessage.contains("fiber") && (userMessage.contains("need") || userMessage.contains("daily"))) {
            return generateNutrientResponse(
                userMessage: userMessage,
                age: age,
                dietaryRestrictions: dietaryRestrictions
            )
        }
        
        // Weight management queries  
        if (userMessage.contains("weight") && (userMessage.contains("lose") || userMessage.contains("gain") || userMessage.contains("management"))) ||
           userMessage.contains("weight loss") || userMessage.contains("weight gain") {
            return generateWeightManagementResponse(
                userMessage: userMessage,
                userProfile: userProfile,
                healthGoals: healthGoals,
                age: age
            )
        }
        
        // Diabetes and blood sugar queries
        if userMessage.contains("diabetes") || userMessage.contains("blood sugar") || 
           userMessage.contains("glucose") || userMessage.contains("diabetic diet") {
            return generateDiabetesResponse(
                userMessage: userMessage,
                medications: medications,
                dietaryRestrictions: dietaryRestrictions,
                age: age
            )
        }
        
        // Heart health queries
        if userMessage.contains("heart") || userMessage.contains("cardiac") || 
           userMessage.contains("cholesterol") || userMessage.contains("blood pressure") {
            return generateHeartHealthResponse(
                userMessage: userMessage,
                medications: medications,
                dietaryRestrictions: dietaryRestrictions,
                age: age
            )
        }
        
        // Bone health queries
        if userMessage.contains("bone") || userMessage.contains("osteoporosis") ||
           (userMessage.contains("calcium") && !userMessage.contains("deficiency")) {
            return generateBoneHealthResponse(
                userMessage: userMessage,
                age: age,
                dietaryRestrictions: dietaryRestrictions
            )
        }
        
        // Fasting queries
        if userMessage.contains("fasting") || userMessage.contains("intermittent") {
            return generateFastingResponse(
                userMessage: userMessage,
                age: age,
                medications: medications
            )
        }
        
        // Supplement queries
        if userMessage.contains("supplement") || 
           (userMessage.contains("vitamins") && !userMessage.contains("vitamin")) {
            return generateSupplementResponse(
                userMessage: userMessage,
                age: age,
                medications: medications,
                dietaryRestrictions: dietaryRestrictions
            )
        }
        
        // Meal planning queries
        if userMessage.contains("meal plan") || userMessage.contains("recipe") || 
           userMessage.contains("cook") || userMessage.contains("meal prep") {
            return generateMealPlanningResponse(
                userMessage: userMessage,
                dietaryRestrictions: dietaryRestrictions,
                healthGoals: healthGoals,
                age: age
            )
        }
        
        // Dietary restriction queries
        if userMessage.contains("allergy") || userMessage.contains("intolerance") || 
           dietaryRestrictions.contains(where: { restriction in
               userMessage.contains(restriction.lowercased())
           }) {
            return generateDietaryRestrictionResponse(
                userMessage: userMessage,
                dietaryRestrictions: dietaryRestrictions,
                age: age
            )
        }
        
        // General hydration (broader match)
        if userMessage.contains("water") || userMessage.contains("hydration") || userMessage.contains("drink") {
            return generateHydrationResponse(userMessage: userMessage, age: age)
        }
        
        // General nutrient queries (broader match)
        if userMessage.contains("vitamin") || userMessage.contains("mineral") || userMessage.contains("nutrient") {
            return generateNutrientResponse(
                userMessage: userMessage,
                age: age,
                dietaryRestrictions: dietaryRestrictions
            )
        }
        
        // General food/eating queries (broader match)
        if userMessage.contains("food") || userMessage.contains("eat") || 
           userMessage.contains("nutrition") || userMessage.contains("healthy") {
            return generateGeneralNutritionResponse(
                userMessage: userMessage,
                age: age,
                healthGoals: healthGoals
            )
        }
        
        return nil
    }
    
    private func generateWeightManagementResponse(
        userMessage: String,
        userProfile: UserProfile?,
        healthGoals: [String],
        age: Int
    ) -> String {
        var response = ""
        
        if userMessage.contains("lose") {
            response = "For healthy weight loss in seniors, focus on:\n\n"
            response += "• Create a moderate calorie deficit (300-500 calories/day)\n"
            response += "• Prioritize protein (1.2-1.6g per kg body weight) to preserve muscle mass\n"
            response += "• Include strength training exercises as approved by your doctor\n"
            response += "• Focus on nutrient-dense foods: lean proteins, vegetables, fruits, whole grains\n"
            response += "• Stay hydrated and eat regular meals to maintain energy\n\n"
            
            if let profile = userProfile, let bmi = profile.bmi {
                response += "Based on your current BMI of \(String(format: "%.1f", bmi)), "
                if bmi > 25 {
                    response += "a gradual weight loss of 1-2 pounds per week would be beneficial for your health."
                } else {
                    response += "maintaining your current weight might be more appropriate than losing weight."
                }
            }
        } else if userMessage.contains("gain") {
            response = "For healthy weight gain in seniors:\n\n"
            response += "• Increase calorie intake with nutrient-dense foods\n"
            response += "• Focus on healthy fats: avocados, nuts, olive oil\n"
            response += "• Include protein at every meal and snack\n"
            response += "• Try frequent, smaller meals if appetite is poor\n"
            response += "• Consider protein smoothies between meals\n"
            response += "• Stay active to build muscle, not just fat\n\n"
            response += "Unintentional weight loss in seniors can be concerning. Please consult your healthcare provider."
        } else {
            response = "Weight management for seniors requires a balanced approach:\n\n"
            response += "• Focus on maintaining muscle mass through adequate protein\n"
            response += "• Choose nutrient-dense foods over empty calories\n"
            response += "• Stay physically active within your abilities\n"
            response += "• Monitor weight changes and discuss with your doctor\n"
            response += "• Consider metabolic changes that occur with aging"
        }
        
        return response
    }
    
    private func generateDiabetesResponse(
        userMessage: String,
        medications: [Medication],
        dietaryRestrictions: [String],
        age: Int
    ) -> String {
        var response = "Managing blood sugar effectively involves:\n\n"
        response += "• Choose complex carbohydrates over simple sugars\n"
        response += "• Include fiber-rich foods to slow glucose absorption\n"
        response += "• Pair carbohydrates with protein or healthy fats\n"
        response += "• Maintain consistent meal timing\n"
        response += "• Monitor portion sizes, especially for carbs\n\n"
        
        response += "Recommended foods:\n"
        response += "• Non-starchy vegetables (broccoli, spinach, peppers)\n"
        response += "• Lean proteins (fish, chicken, legumes)\n"
        response += "• Whole grains in moderation\n"
        response += "• Healthy fats (olive oil, nuts, avocado)\n\n"
        
        response += "Foods to limit:\n"
        response += "• Refined sugars and sweets\n"
        response += "• White bread, white rice, pastries\n"
        response += "• Sugary drinks and fruit juices\n"
        response += "• Processed foods high in sodium\n\n"
        
        if medications.contains(where: { $0.name.lowercased().contains("metformin") || $0.name.lowercased().contains("insulin") }) {
            response += "⚠️ Since you're taking diabetes medication, coordinate your meal timing with your medication schedule. Never skip meals if you're on insulin or sulfonylureas."
        }
        
        response += "\n\n💡 Consider working with a certified diabetes educator for personalized meal planning."
        
        return response
    }
    
    private func generateHeartHealthResponse(
        userMessage: String,
        medications: [Medication],
        dietaryRestrictions: [String],
        age: Int
    ) -> String {
        var response = "Heart-healthy nutrition for seniors:\n\n"
        response += "🐟 **Omega-3 Rich Foods:**\n"
        response += "• Fatty fish (salmon, mackerel, sardines) 2-3 times/week\n"
        response += "• Walnuts, flaxseeds, chia seeds\n"
        response += "• Plant-based sources if you don't eat fish\n\n"
        
        response += "🥬 **Antioxidant-Rich Foods:**\n"
        response += "• Colorful vegetables and fruits\n"
        response += "• Berries (blueberries, strawberries)\n"
        response += "• Dark leafy greens\n"
        response += "• Green tea\n\n"
        
        response += "🧂 **Sodium Management:**\n"
        response += "• Limit to 1,500mg daily (seniors recommendation)\n"
        response += "• Use herbs and spices instead of salt\n"
        response += "• Read food labels carefully\n"
        response += "• Choose fresh over processed foods\n\n"
        
        response += "💊 **Heart-Healthy Nutrients:**\n"
        response += "• Potassium: bananas, oranges, potatoes\n"
        response += "• Magnesium: nuts, seeds, whole grains\n"
        response += "• Fiber: oats, beans, apples\n\n"
        
        if medications.contains(where: { $0.name.lowercased().contains("warfarin") || $0.name.lowercased().contains("coumadin") }) {
            response += "⚠️ **Important:** You're taking blood thinners. Maintain consistent vitamin K intake (leafy greens) and discuss any major dietary changes with your doctor."
        }
        
        if userMessage.contains("cholesterol") {
            response += "\n🩺 **Cholesterol Management:**\n"
            response += "• Soluble fiber helps lower LDL cholesterol\n"
            response += "• Plant stanols/sterols in fortified foods\n"
            response += "• Limit saturated fats (<7% of calories)\n"
            response += "• Avoid trans fats completely"
        }
        
        return response
    }
    
    private func generateBoneHealthResponse(
        userMessage: String,
        age: Int,
        dietaryRestrictions: [String]
    ) -> String {
        var response = "Bone health is crucial for seniors. Here's what you need:\n\n"
        response += "🦴 **Calcium Sources (1,200mg daily for seniors):**\n"
        
        if !dietaryRestrictions.contains("Dairy-Free") && !dietaryRestrictions.contains("Lactose Intolerant") {
            response += "• Dairy products: milk, yogurt, cheese\n"
        }
        
        response += "• Dark leafy greens: kale, collard greens, bok choy\n"
        response += "• Fortified plant milks (soy, almond, oat)\n"
        response += "• Canned sardines and salmon with bones\n"
        response += "• Fortified orange juice\n"
        response += "• Tofu made with calcium sulfate\n\n"
        
        response += "☀️ **Vitamin D (800-1,000 IU daily):**\n"
        response += "• Fatty fish (salmon, tuna, mackerel)\n"
        response += "• Fortified milk and cereals\n"
        response += "• Egg yolks\n"
        response += "• Safe sun exposure (10-15 minutes daily)\n"
        response += "• Consider supplements (discuss with doctor)\n\n"
        
        response += "💪 **Bone-Supporting Nutrients:**\n"
        response += "• Vitamin K: leafy greens, broccoli\n"
        response += "• Magnesium: nuts, seeds, whole grains\n"
        response += "• Phosphorus: dairy, fish, poultry\n"
        response += "• Vitamin C: citrus fruits, berries, peppers\n\n"
        
        response += "⚠️ **Bone Health Tips:**\n"
        response += "• Limit caffeine (affects calcium absorption)\n"
        response += "• Moderate alcohol consumption\n"
        response += "• Include weight-bearing exercises\n"
        response += "• Avoid smoking"
        
        if age >= 70 {
            response += "\n\n💡 At your age, calcium and vitamin D supplements may be recommended. Please discuss with your healthcare provider."
        }
        
        return response
    }
    
    private func generateNutrientResponse(
        userMessage: String,
        age: Int,
        dietaryRestrictions: [String]
    ) -> String {
        var response = ""
        
        if userMessage.contains("vitamin b12") || userMessage.contains("b12") {
            response = "Vitamin B12 is crucial for seniors:\n\n"
            response += "🎯 **Daily Need:** 2.4 mcg (seniors may need more)\n\n"
            response += "📍 **Best Sources:**\n"
            response += "• Fish, poultry, meat, eggs\n"
            response += "• Fortified nutritional yeast\n"
            response += "• Fortified plant milks and cereals\n\n"
            response += "⚠️ **Senior Concerns:**\n"
            response += "• Absorption decreases with age\n"
            response += "• Many seniors are deficient\n"
            response += "• Consider B12 supplements or fortified foods\n"
            response += "• Get blood levels checked annually"
            
        } else if userMessage.contains("iron") {
            response = "Iron needs for seniors:\n\n"
            response += "🎯 **Daily Need:** 8mg for men, 8mg for postmenopausal women\n\n"
            response += "📍 **Iron-Rich Foods:**\n"
            response += "• Red meat, poultry, fish (heme iron - better absorbed)\n"
            response += "• Beans, lentils, spinach (non-heme iron)\n"
            response += "• Fortified cereals\n\n"
            response += "💡 **Absorption Tips:**\n"
            response += "• Pair iron-rich foods with vitamin C\n"
            response += "• Avoid tea/coffee with iron-rich meals\n"
            response += "• Don't take calcium supplements with iron"
            
        } else if userMessage.contains("fiber") {
            response = "Fiber recommendations for seniors:\n\n"
            response += "🎯 **Daily Need:** 21g for women 51+, 30g for men 51+\n\n"
            response += "📍 **High-Fiber Foods:**\n"
            response += "• Whole grains: oats, quinoa, brown rice\n"
            response += "• Legumes: beans, lentils, chickpeas\n"
            response += "• Fruits: apples, pears, berries\n"
            response += "• Vegetables: broccoli, artichokes, Brussels sprouts\n\n"
            response += "💡 **Benefits for Seniors:**\n"
            response += "• Prevents constipation (common in seniors)\n"
            response += "• Helps control blood sugar\n"
            response += "• Supports heart health\n"
            response += "• May reduce cancer risk\n\n"
            response += "⚠️ **Increase gradually and drink plenty of water**"
            
        } else {
            response = "Key nutrients for seniors:\n\n"
            response += "🔥 **Priority Nutrients:**\n"
            response += "• Protein: 1.2-1.6g per kg body weight\n"
            response += "• Calcium: 1,200mg daily\n"
            response += "• Vitamin D: 800-1,000 IU daily\n"
            response += "• Vitamin B12: 2.4+ mcg daily\n"
            response += "• Fiber: 21-30g daily\n"
            response += "• Omega-3 fatty acids: 1.1-1.6g daily\n\n"
            response += "💡 Focus on nutrient-dense foods to meet these needs efficiently."
        }
        
        return response
    }
    
    private func generateMealPlanningResponse(
        userMessage: String,
        dietaryRestrictions: [String],
        healthGoals: [String],
        age: Int
    ) -> String {
        var response = "Meal planning tips for seniors:\n\n"
        response += "🍽️ **Balanced Plate Method:**\n"
        response += "• 1/2 plate: non-starchy vegetables\n"
        response += "• 1/4 plate: lean protein\n"
        response += "• 1/4 plate: whole grains or starchy vegetables\n"
        response += "• Add healthy fats (olive oil, nuts, avocado)\n\n"
        
        response += "⏰ **Meal Timing:**\n"
        response += "• Eat regularly to maintain energy\n"
        response += "• Include protein at each meal\n"
        response += "• Consider smaller, frequent meals if appetite is poor\n\n"
        
        response += "🥘 **Easy Meal Ideas:**\n"
        response += "• **Breakfast:** Oatmeal with berries and nuts\n"
        response += "• **Lunch:** Soup with whole grain bread and cheese\n"
        response += "• **Dinner:** Baked fish with roasted vegetables\n"
        response += "• **Snacks:** Greek yogurt with fruit, nuts\n\n"
        
        // Customize based on dietary restrictions
        if !dietaryRestrictions.isEmpty {
            response += "🚫 **Considering your dietary restrictions:**\n"
            for restriction in dietaryRestrictions {
                switch restriction {
                case "Vegetarian":
                    response += "• Focus on plant proteins: legumes, nuts, seeds, tofu\n"
                case "Vegan":
                    response += "• Ensure B12, iron, and calcium from fortified foods\n"
                case "Gluten-Free":
                    response += "• Choose quinoa, rice, and certified gluten-free oats\n"
                case "Low-Sodium":
                    response += "• Use herbs, spices, and lemon for flavor\n"
                case "Diabetic":
                    response += "• Focus on complex carbs and consistent timing\n"
                default:
                    response += "• Modified recommendations for \(restriction)\n"
                }
            }
            response += "\n"
        }
        
        response += "💡 **Meal Prep Tips:**\n"
        response += "• Batch cook proteins and grains\n"
        response += "• Pre-cut vegetables for easy access\n"
        response += "• Keep healthy frozen options on hand\n"
        response += "• Consider meal delivery services if cooking is difficult"
        
        return response
    }
    
    private func generateHydrationResponse(userMessage: String, age: Int) -> String {
        // Check if asking specifically about daily goals/amounts
        if userMessage.contains("goal") || userMessage.contains("daily") || 
           userMessage.contains("how much") || userMessage.contains("amount") {
            
            var response = "Your daily fluid goals as a senior:\n\n"
            response += "💧 **Daily Fluid Targets:**\n"
            response += "• **Women 65+:** ~11 cups (2.7 liters) total fluids daily\n"
            response += "• **Men 65+:** ~15 cups (3.7 liters) total fluids daily\n"
            response += "• **Plain water:** About 8-10 cups of this should be water\n"
            response += "• **Other fluids:** 20% can come from food and other beverages\n\n"
            
            response += "📏 **Easy Measurements:**\n"
            response += "• 1 cup = 8 oz = 240ml\n"
            response += "• Standard water bottle = ~2 cups\n"
            response += "• Large glass = ~1.5 cups\n\n"
            
            response += "⏰ **Daily Distribution:**\n"
            response += "• Morning: 2-3 cups\n"
            response += "• Afternoon: 4-5 cups\n"
            response += "• Evening: 3-4 cups (reduce before bedtime)\n\n"
            
            response += "🚨 **Senior-Specific Needs:**\n"
            response += "• Thirst sensation decreases with age\n"
            response += "• Some medications increase fluid needs\n"
            response += "• Higher risk of dehydration\n"
            response += "• Monitor urine color (pale yellow is ideal)"
            
            return response
        }
        
        // General hydration information
        let response = """
        Hydration guidance for seniors:\n\n
        💧 **Daily Fluid Goals:**
        • Women: ~11 cups (2.7 liters) total fluids daily
        • Men: ~15 cups (3.7 liters) total fluids daily
        • About 80% should come from beverages, 20% from food\n\n
        
        🚨 **Why Seniors Need More Attention to Hydration:**
        • Kidney function declines with age
        • Thirst sensation decreases
        • Some medications increase fluid needs
        • Risk of dehydration is higher\n\n
        
        🥤 **Best Hydration Sources:**
        • Plain water (best choice)
        • Herbal teas
        • Low-sodium broths
        • Milk and plant-based milks
        • Fruits with high water content (watermelon, oranges)\n\n
        
        ⚠️ **Limit These:**
        • Excessive caffeine (diuretic effect)
        • Alcohol (dehydrating)
        • High-sodium drinks
        • Sugary beverages\n\n
        
        💡 **Hydration Tips:**
        • Sip throughout the day, don't wait until thirsty
        • Keep water visible as a reminder
        • Flavor water with lemon, cucumber, or mint
        • Monitor urine color (pale yellow is ideal)
        • Increase intake in hot weather or when sick
        """
        
        return response
    }
    
    private func generateFastingResponse(
        userMessage: String,
        age: Int,
        medications: [Medication]
    ) -> String {
        var response = "Intermittent fasting considerations for seniors:\n\n"
        
        response += "⚠️ **Important Safety Note:**\n"
        response += "Intermittent fasting requires medical supervision for seniors, especially those with:\n"
        response += "• Diabetes or blood sugar issues\n"
        response += "• Multiple medications\n"
        response += "• History of eating disorders\n"
        response += "• Underweight or recent weight loss\n\n"
        
        if !medications.isEmpty {
            response += "🚨 **Medication Considerations:**\n"
            response += "You're taking medications that may need adjustment with fasting:\n"
            for medication in medications.prefix(3) {
                response += "• \(medication.name)\n"
            }
            response += "Please consult your doctor before starting any fasting regimen.\n\n"
        }
        
        response += "🕐 **Gentler Approaches for Seniors:**\n"
        response += "• 12:12 method (12 hours eating, 12 hours fasting)\n"
        response += "• Stop eating 3 hours before bedtime\n"
        response += "• Focus on nutrient timing vs. restriction\n\n"
        
        response += "🍽️ **During Eating Windows:**\n"
        response += "• Prioritize protein at every meal\n"
        response += "• Include calcium and vitamin D sources\n"
        response += "• Don't skip essential nutrients\n"
        response += "• Stay well hydrated\n\n"
        
        response += "💡 **Alternative Approaches:**\n"
        response += "• Time-restricted eating (eating earlier in the day)\n"
        response += "• Mediterranean-style eating patterns\n"
        response += "• Focus on whole foods vs. timing restrictions"
        
        return response
    }
    
    private func generateSupplementResponse(
        userMessage: String,
        age: Int,
        medications: [Medication],
        dietaryRestrictions: [String]
    ) -> String {
        var response = "Supplement considerations for seniors:\n\n"
        
        response += "🎯 **Commonly Needed Supplements:**\n"
        response += "• **Vitamin D:** 800-1,000 IU (most seniors are deficient)\n"
        response += "• **Vitamin B12:** May need supplementation due to absorption issues\n"
        response += "• **Calcium:** If dietary intake is insufficient\n"
        response += "• **Omega-3:** If fish intake is low\n\n"
        
        response += "⚠️ **Important Safety Notes:**\n"
        response += "• Always discuss supplements with your healthcare provider\n"
        response += "• Some supplements interact with medications\n"
        response += "• More is not always better - avoid mega-doses\n"
        response += "• Get blood tests to identify actual deficiencies\n\n"
        
        if !medications.isEmpty {
            response += "💊 **Medication Interactions to Consider:**\n"
            response += "• Blood thinners + Vitamin K, Omega-3, Vitamin E\n"
            response += "• Diabetes medications + Chromium, Cinnamon\n"
            response += "• Blood pressure medications + Potassium\n"
            response += "• Always check with your pharmacist\n\n"
        }
        
        response += "🥬 **Food First Approach:**\n"
        response += "• Try to get nutrients from whole foods when possible\n"
        response += "• Supplements should complement, not replace, good nutrition\n"
        response += "• Consider fortified foods as alternatives\n\n"
        
        if dietaryRestrictions.contains("Vegan") {
            response += "🌱 **Special Vegan Considerations:**\n"
            response += "• B12 supplementation is essential\n"
            response += "• Consider algae-based omega-3\n"
            response += "• Iron levels should be monitored\n"
            response += "• Calcium and vitamin D may be needed\n\n"
        }
        
        response += "💡 **Quality Matters:**\n"
        response += "• Look for third-party testing (USP, NSF)\n"
        response += "• Choose reputable brands\n"
        response += "• Store properly and check expiration dates"
        
        return response
    }
    
    private func generateDietaryRestrictionResponse(
        userMessage: String,
        dietaryRestrictions: [String],
        age: Int
    ) -> String {
        var response = "Managing dietary restrictions as a senior:\n\n"
        
        for restriction in dietaryRestrictions {
            switch restriction {
            case "Diabetes", "Diabetic":
                response += "🩺 **Diabetes Management:**\n"
                response += "• Focus on complex carbohydrates\n"
                response += "• Pair carbs with protein or healthy fats\n"
                response += "• Monitor portion sizes\n"
                response += "• Maintain consistent meal timing\n\n"
                
            case "Heart Disease", "Low-Sodium":
                response += "❤️ **Heart-Healthy Eating:**\n"
                response += "• Limit sodium to 1,500mg daily\n"
                response += "• Choose omega-3 rich foods\n"
                response += "• Increase fruits and vegetables\n"
                response += "• Use herbs and spices for flavor\n\n"
                
            case "Vegetarian":
                response += "🌱 **Vegetarian Nutrition:**\n"
                response += "• Combine proteins (beans + grains)\n"
                response += "• Include iron-rich foods with vitamin C\n"
                response += "• Consider B12 supplementation\n"
                response += "• Focus on varied, colorful foods\n\n"
                
            case "Gluten-Free":
                response += "🌾 **Gluten-Free Guidelines:**\n"
                response += "• Choose naturally gluten-free grains\n"
                response += "• Read labels carefully\n"
                response += "• Ensure adequate fiber intake\n"
                response += "• Consider fortified gluten-free products\n\n"
                
            case "Lactose Intolerant", "Dairy-Free":
                response += "🥛 **Dairy-Free Nutrition:**\n"
                response += "• Choose fortified plant milks\n"
                response += "• Include non-dairy calcium sources\n"
                response += "• Consider lactase enzymes for small amounts\n"
                response += "• Monitor calcium and vitamin D intake\n\n"
                
            default:
                response += "• Customized guidance for \(restriction)\n"
            }
        }
        
        response += "💡 **General Tips:**\n"
        response += "• Work with a registered dietitian\n"
        response += "• Plan meals in advance\n"
        response += "• Keep suitable snacks on hand\n"
        response += "• Communicate restrictions to caregivers\n"
        response += "• Don't let restrictions limit nutrition quality"
        
        return response
    }
    
    private func generateGeneralNutritionResponse(
        userMessage: String,
        age: Int,
        healthGoals: [String]
    ) -> String {
        var response = "Healthy eating principles for seniors:\n\n"
        
        response += "🌟 **Core Nutrition Principles:**\n"
        response += "• Eat a variety of colorful foods\n"
        response += "• Include protein at every meal\n"
        response += "• Choose whole grains over refined\n"
        response += "• Limit processed and packaged foods\n"
        response += "• Stay adequately hydrated\n\n"
        
        response += "🍎 **Senior-Specific Nutrition Needs:**\n"
        response += "• Higher protein needs for muscle preservation\n"
        response += "• Increased calcium and vitamin D for bones\n"
        response += "• B12 supplementation may be needed\n"
        response += "• Fiber for digestive health\n"
        response += "• Omega-3s for brain and heart health\n\n"
        
        if !healthGoals.isEmpty {
            response += "🎯 **Aligned with Your Health Goals:**\n"
            for goal in healthGoals.prefix(3) {
                switch goal {
                case "Weight Loss":
                    response += "• Focus on nutrient-dense, lower-calorie foods\n"
                case "Heart Health":
                    response += "• Emphasize omega-3s and limit sodium\n"
                case "Bone Health":
                    response += "• Prioritize calcium and vitamin D sources\n"
                case "Energy":
                    response += "• Include complex carbs and B vitamins\n"
                default:
                    response += "• Nutrition support for \(goal)\n"
                }
            }
            response += "\n"
        }
        
        response += "🍽️ **Practical Eating Tips:**\n"
        response += "• Make meals social when possible\n"
        response += "• Prepare foods that are easy to chew and digest\n"
        response += "• Use herbs and spices to enhance flavor\n"
        response += "• Keep healthy snacks easily accessible\n"
        response += "• Consider meal delivery services if cooking is difficult\n\n"
        
        response += "🩺 **When to Seek Help:**\n"
        response += "• Unintended weight loss or gain\n"
        response += "• Changes in appetite or taste\n"
        response += "• Difficulty swallowing or chewing\n"
        response += "• New dietary restrictions due to health conditions"
        
        return response
    }
}

#Preview {
    NutritionistChatView()
        .environmentObject(UserSettings())
}