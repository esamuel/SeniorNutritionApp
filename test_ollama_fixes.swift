#!/usr/bin/env swift

import Foundation

// Simple test to verify Ollama integration is working
func testOllamaConnection() async {
    print("🧪 Testing Ollama Connection...")
    
    // Test 1: Basic connection
    print("\n1️⃣ Testing basic connection...")
    do {
        let url = URL(string: "http://localhost:11434/api/tags")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let models = json["models"] as? [[String: Any]] {
                print("✅ Connection successful. Found \(models.count) model(s)")
                for model in models {
                    if let name = model["name"] as? String {
                        print("   📦 Model: \(name)")
                    }
                }
            }
        } else {
            print("❌ Connection failed")
            return
        }
    } catch {
        print("❌ Connection error: \(error.localizedDescription)")
        return
    }
    
    // Test 2: Simple generation
    print("\n2️⃣ Testing AI generation...")
    do {
        let url = URL(string: "http://localhost:11434/api/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30.0
        
        let requestBody = [
            "model": "llama3.1:8b",
            "prompt": "Reply with just the word 'test'",
            "stream": false,
            "options": [
                "temperature": 0.1,
                "max_tokens": 10
            ]
        ] as [String: Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let startTime = Date()
        let (data, response) = try await URLSession.shared.data(for: request)
        let duration = Date().timeIntervalSince(startTime)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let responseText = json["response"] as? String {
                print("✅ AI generation successful in \(String(format: "%.1f", duration))s")
                print("   🤖 Response: '\(responseText.trimmingCharacters(in: .whitespacesAndNewlines))'")
            }
        } else {
            print("❌ Generation failed with status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        }
    } catch {
        print("❌ Generation error: \(error.localizedDescription)")
        if error.localizedDescription.contains("timeout") {
            print("💡 Suggestion: Model may be loading. Wait a moment and try again.")
        }
    }
    
    // Test 3: Nutrition prompt
    print("\n3️⃣ Testing nutrition-specific prompt...")
    do {
        let url = URL(string: "http://localhost:11434/api/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 45.0
        
        let nutritionPrompt = """
        You are a nutritionist for seniors. Answer briefly: 
        What should a 70-year-old person drink daily for hydration?
        """
        
        let requestBody = [
            "model": "llama3.1:8b",
            "prompt": nutritionPrompt,
            "stream": false,
            "options": [
                "temperature": 0.7,
                "max_tokens": 200
            ]
        ] as [String: Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let startTime = Date()
        let (data, response) = try await URLSession.shared.data(for: request)
        let duration = Date().timeIntervalSince(startTime)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let responseText = json["response"] as? String {
                print("✅ Nutrition AI test successful in \(String(format: "%.1f", duration))s")
                print("   💧 Response preview: \(String(responseText.prefix(100)))...")
            }
        } else {
            print("❌ Nutrition test failed with status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        }
    } catch {
        print("❌ Nutrition test error: \(error.localizedDescription)")
    }
    
    print("\n🏁 Test complete!")
}

// Run the test
Task {
    await testOllamaConnection()
    exit(0)
}