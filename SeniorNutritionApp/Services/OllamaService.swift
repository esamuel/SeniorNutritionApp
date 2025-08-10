import Foundation
import SwiftUI

// MARK: - Ollama API Models

struct OllamaRequest: Codable {
    let model: String
    let prompt: String
    let stream: Bool
    let options: OllamaOptions?
    
    init(model: String = "llama3.1:8b", prompt: String, stream: Bool = false, options: OllamaOptions? = nil) {
        self.model = model
        self.prompt = prompt
        self.stream = stream
        self.options = options
    }
}

struct OllamaOptions: Codable {
    let temperature: Double?
    let top_p: Double?
    let max_tokens: Int?
    
    init(temperature: Double = 0.7, top_p: Double = 0.9, max_tokens: Int = 1000) {
        self.temperature = temperature
        self.top_p = top_p
        self.max_tokens = max_tokens
    }
}

struct OllamaResponse: Codable {
    let model: String
    let response: String
    let done: Bool
    let context: [Int]?
    let total_duration: Int?
    let load_duration: Int?
    let prompt_eval_count: Int?
    let prompt_eval_duration: Int?
    let eval_count: Int?
    let eval_duration: Int?
}

// MARK: - Ollama Service

@MainActor
class OllamaService: ObservableObject {
    @Published var isConnected = false
    @Published var availableModels: [String] = []
    @Published var currentModel = "llama3.1:8b"
    @Published var isLoading = false
    
    private let baseURL = "http://10.10.1.167:11434" // Mac's IP address for real device testing
    private let session = URLSession.shared
    
    init() {
        Task {
            await checkConnection()
            await loadAvailableModels()
        }
    }
    
    // MARK: - Connection Management
    
    func checkConnection() async {
        print("🔗 Checking Ollama connection to: \(baseURL)")
        
        do {
            let url = URL(string: "\(baseURL)/api/tags")!
            var request = URLRequest(url: url)
            request.timeoutInterval = 8.0 // Increased timeout for iOS network
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            // Create session with specific configuration for local network
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 8.0
            config.timeoutIntervalForResource = 8.0
            config.waitsForConnectivity = false
            let localSession = URLSession(configuration: config)
            
            let (data, response) = try await localSession.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Response: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    // Additional check: verify we have models available
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let models = json["models"] as? [[String: Any]],
                       !models.isEmpty {
                        isConnected = true
                        let modelNames = models.compactMap { $0["name"] as? String }
                        print("✅ Ollama connected successfully!")
                        print("📦 Available models: \(modelNames.joined(separator: ", "))")
                    } else {
                        isConnected = false
                        print("⚠️ Ollama connected but no models available. Run: ollama pull llama3.1:8b")
                    }
                } else {
                    isConnected = false
                    print("❌ Ollama HTTP error: \(httpResponse.statusCode)")
                }
            } else {
                isConnected = false
                print("❌ Ollama connection failed: Invalid response type")
            }
        } catch {
            isConnected = false
            let errorDesc = error.localizedDescription
            print("❌ Ollama connection error: \(errorDesc)")
            
            if errorDesc.contains("Connection refused") {
                print("💡 Fix: ollama serve")
            } else if errorDesc.contains("could not connect") || errorDesc.contains("Could not connect") {
                print("🔧 iOS Network Troubleshooting:")
                print("   • Ollama running? Check: ps aux | grep ollama")  
                print("   • URL accessible? Test: curl \(baseURL)/api/tags")
                print("   • iOS network issue? Try restarting simulator")
            } else if errorDesc.contains("timed out") {
                print("⏱️ Connection timeout - Ollama may be starting up")
            }
        }
    }
    
    private func loadAvailableModels() async {
        guard isConnected else { return }
        
        do {
            let url = URL(string: "\(baseURL)/api/tags")!
            let (data, _) = try await session.data(from: url)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let models = json["models"] as? [[String: Any]] {
                
                let modelNames = models.compactMap { $0["name"] as? String }
                availableModels = modelNames
                
                // Set default model if available
                if !modelNames.isEmpty && !modelNames.contains(currentModel) {
                    currentModel = modelNames.first ?? "llama3.1:8b"
                }
            }
        } catch {
            print("Failed to load models: \(error.localizedDescription)")
        }
    }
    
    // MARK: - AI Query Methods
    
    func generateNutritionResponse(
        userQuestion: String,
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        medications: [Medication],
        age: Int
    ) async -> String? {
        
        let prompt = buildNutritionPrompt(
            question: userQuestion,
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: healthGoals,
            medications: medications,
            age: age
        )
        
        return await queryOllama(prompt: prompt, temperature: 0.7)
    }
    
    func generateMealSuggestions(
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        mealType: MealType,
        availableIngredients: [String]? = nil
    ) async -> String? {
        
        let prompt = buildMealSuggestionPrompt(
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: healthGoals,
            mealType: mealType,
            availableIngredients: availableIngredients
        )
        
        return await queryOllama(prompt: prompt, temperature: 0.8)
    }
    
    // MARK: - Core Ollama Query
    
    func queryOllama(prompt: String, temperature: Double = 0.7) async -> String? {
        guard isConnected else {
            print("Ollama is not connected")
            return nil
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = URL(string: "\(baseURL)/api/generate")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 60.0 // Increase timeout for AI generation
            
            let ollamaRequest = OllamaRequest(
                model: currentModel,
                prompt: prompt,
                stream: false,
                options: OllamaOptions(
                    temperature: temperature,
                    top_p: 0.9,
                    max_tokens: 800 // Limit tokens for faster responses
                )
            )
            
            request.httpBody = try JSONEncoder().encode(ollamaRequest)
            
            // Create URLSession with longer timeout
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 60.0
            config.timeoutIntervalForResource = 60.0
            let longTimeoutSession = URLSession(configuration: config)
            
            let (data, response) = try await longTimeoutSession.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let ollamaResponse = try JSONDecoder().decode(OllamaResponse.self, from: data)
                    let result = ollamaResponse.response.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !result.isEmpty {
                        print("✅ Ollama responded successfully (\(result.count) chars)")
                        return result
                    } else {
                        print("⚠️ Ollama returned empty response")
                        return nil
                    }
                } else {
                    print("❌ Ollama HTTP error: \(httpResponse.statusCode)")
                    // Check if model needs to be loaded
                    if httpResponse.statusCode == 404 {
                        print("💡 Model might not be loaded. Try: ollama run \(currentModel)")
                    }
                    return nil
                }
            }
            
        } catch {
            print("❌ Ollama query failed: \(error.localizedDescription)")
            if error.localizedDescription.contains("timeout") {
                print("💡 Consider using a smaller model like llama3.1:3b for faster responses")
            }
            return nil
        }
        
        return nil
    }
    
    // MARK: - Prompt Building
    
    private func buildNutritionPrompt(
        question: String,
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        medications: [Medication],
        age: Int
    ) -> String {
        
        var prompt = """
        You are a certified nutritionist specializing in senior nutrition (65+ years). Provide accurate, evidence-based nutrition advice.
        
        USER PROFILE:
        - Age: \(age) years old
        """
        
        if let profile = userProfile {
            prompt += """
            - Gender: \(profile.gender)
            - Height: \(Int(profile.height))cm
            - Weight: \(Int(profile.weight))kg
            """
            
            if let bmi = profile.bmi {
                prompt += "- BMI: \(String(format: "%.1f", bmi))\n"
            }
        }
        
        if !dietaryRestrictions.isEmpty {
            prompt += "- Dietary Restrictions: \(dietaryRestrictions.joined(separator: ", "))\n"
        }
        
        if !healthGoals.isEmpty {
            prompt += "- Health Goals: \(healthGoals.joined(separator: ", "))\n"
        }
        
        if !medications.isEmpty {
            let medicationNames = medications.map { $0.name }
            prompt += "- Current Medications: \(medicationNames.joined(separator: ", "))\n"
        }
        
        prompt += """
        
        GUIDELINES:
        - Focus on senior-specific nutrition needs (higher protein, calcium, vitamin D, B12)
        - Consider medication interactions and health conditions
        - Provide specific, actionable advice
        - Include food examples and measurements
        - Warn about safety concerns when relevant
        - Keep response under 300 words
        - Use clear, friendly language
        
        QUESTION: \(question)
        
        RESPONSE:
        """
        
        return prompt
    }
    
    private func buildMealSuggestionPrompt(
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        mealType: MealType,
        availableIngredients: [String]?
    ) -> String {
        
        var prompt = """
        You are a senior nutrition specialist creating meal suggestions for older adults (65+).
        
        MEAL TYPE: \(mealType.rawValue)
        
        USER PROFILE:
        """
        
        if let profile = userProfile {
            prompt += """
            - Age: \(profile.age) years old
            - Gender: \(profile.gender)
            """
            
            if let bmi = profile.bmi {
                prompt += "- BMI: \(String(format: "%.1f", bmi))\n"
            }
        }
        
        if !dietaryRestrictions.isEmpty {
            prompt += "- Dietary Restrictions: \(dietaryRestrictions.joined(separator: ", "))\n"
        }
        
        if !healthGoals.isEmpty {
            prompt += "- Health Goals: \(healthGoals.joined(separator: ", "))\n"
        }
        
        if let ingredients = availableIngredients, !ingredients.isEmpty {
            prompt += "- Available Ingredients: \(ingredients.joined(separator: ", "))\n"
        }
        
        prompt += """
        
        REQUIREMENTS:
        - Senior-friendly foods (easy to chew, digest)
        - High protein content (1.2-1.6g per kg body weight daily)
        - Include calcium, vitamin D, B12 sources
        - Consider medication timing if relevant
        - Suggest 2-3 specific meal options
        - Include approximate nutritional values
        - Provide simple preparation instructions
        - Keep portions appropriate for seniors
        
        FORMAT:
        **Option 1: [Meal Name]**
        - Ingredients: [list]
        - Nutrition: [calories, protein, key nutrients]
        - Preparation: [simple steps]
        
        **Option 2: [Meal Name]**
        [same format]
        
        **Option 3: [Meal Name]**
        [same format]
        
        RESPONSE:
        """
        
        return prompt
    }
    
    // MARK: - Utility Methods
    
    func pullModel(_ modelName: String) async -> Bool {
        // Implementation for pulling new models if needed
        // This would be used to download models like llama3.1:8b
        return false
    }
    
    func switchModel(_ modelName: String) {
        if availableModels.contains(modelName) {
            currentModel = modelName
        }
    }
    
    // MARK: - Diagnostic Methods
    
    func testConnection() async -> (success: Bool, message: String) {
        // First test basic connection
        await checkConnection()
        
        if !isConnected {
            return (false, "Ollama server not reachable. Run 'ollama serve' in Terminal.")
        }
        
        // Test a simple generation
        let testResponse = await queryOllama(prompt: "Reply with just the word 'test'", temperature: 0.1)
        
        if let response = testResponse, !response.isEmpty {
            return (true, "✅ AI is working correctly. Response: '\(response)'")
        } else {
            return (false, "⚠️ Ollama connected but model not responding. Try: ollama run \(currentModel)")
        }
    }
}

// MARK: - Installation Instructions Extension

extension OllamaService {
    static let installationInstructions = """
    To use Ollama AI features:
    
    1. Install Ollama: https://ollama.ai
    2. Run in Terminal: `ollama pull llama3.1:8b`
    3. Start Ollama: `ollama serve`
    4. The app will automatically connect!
    
    Recommended models:
    - llama3.1:8b (8GB RAM) - Best balance
    - llama3.1:3b (4GB RAM) - Faster, less accurate
    - qwen2.5:7b (7GB RAM) - Good for instructions
    """
}