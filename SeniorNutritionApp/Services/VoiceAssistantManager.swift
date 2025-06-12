import Foundation
import Speech
import SwiftUI

class VoiceAssistantManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    // Published properties for UI updates
    @Published var isListening = false
    @Published var recognizedText = ""
    @Published var feedbackMessage = ""
    @Published var showFeedback = false
    
    // Speech recognition properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // Command handling
    private var commandHandlers: [String: () -> Void] = [:]
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
        
        // Request authorization for speech recognition
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied:
                    self.showFeedbackWithMessage("Speech recognition permission denied")
                case .restricted, .notDetermined:
                    self.showFeedbackWithMessage("Speech recognition not available")
                @unknown default:
                    self.showFeedbackWithMessage("Speech recognition status unknown")
                }
            }
        }
    }
    
    // Register a command with its handler
    func registerCommand(phrase: String, handler: @escaping () -> Void) {
        commandHandlers[phrase.lowercased()] = handler
    }
    
    // Start listening for voice commands
    func startListening() {
        // Check if already listening
        if isListening { return }
        
        // Reset recognized text
        recognizedText = ""
        
        // Request authorization if needed
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus != .authorized {
                    self.showFeedbackWithMessage("Speech recognition not authorized")
                    return
                }
                
                // Set listening state first so UI updates
                self.isListening = true
                self.showFeedbackWithMessage("Listening...")
                
                // Start the recognition task
                self.startRecognitionTask()
            }
        }
    }
    
    private func startRecognitionTask() {
        // Reset recognized text when starting a new session
        DispatchQueue.main.async {
            self.recognizedText = ""
        }
        
        // Clear previous session
        recognitionTask?.cancel()
        recognitionTask = nil
        self.recognitionRequest = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session configuration error: \(error.localizedDescription)")
            showFeedbackWithMessage("Could not configure audio session")
            return
        }
        
        // Create a new recognition request
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = self.recognitionRequest,
              let speechRecognizer = self.speechRecognizer,
              speechRecognizer.isAvailable else {
            print("Speech recognizer not available or not authorized")
            showFeedbackWithMessage("Speech recognition not available")
            return
        }
        
        // Configure input node
        let inputNode = audioEngine.inputNode
        
        // Configure request
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.taskHint = .dictation  // Optimize for continuous speech
        
        // Start recognition task
        // Create local variables to track recognition state
        var hasProcessedFinalResult = false
        var lastTranscriptionTime = Date()
        var silenceTimer: Timer?
        
        // Timer to detect silence/end of speech
        let createSilenceTimer = { [weak self] in
            silenceTimer?.invalidate()
            silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                guard let self = self, !hasProcessedFinalResult else { return }
                
                // If we haven't received new transcription for a while, consider it final
                let currentText = self.recognizedText
                if !currentText.isEmpty {
                    print("Silence detected - processing as final: \(currentText)")
                    hasProcessedFinalResult = true
                    
                    // Process on main thread
                    DispatchQueue.main.async {
                        self.showFeedbackWithMessage("Recognized: \(currentText)")
                        self.processCommand(currentText)
                        self.stopListening()
                    }
                }
            }
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            // Skip processing if we've already handled the final result
            if hasProcessedFinalResult {
                return
            }
            
            // Handle results if available
            if let result = result {
                // Get the transcription
                let transcription = result.bestTranscription.formattedString
                
                // Update last transcription time to track speech activity
                lastTranscriptionTime = Date()
                
                // Only log if text changed to avoid console spam
                if transcription != self.recognizedText {
                    print("Transcription: \(transcription)")
                    
                    // Reset silence timer when new transcription arrives
                    createSilenceTimer()
                }
                
                // Update UI with the recognized text
                DispatchQueue.main.async {
                    self.recognizedText = transcription
                }
                
                // Process final result from Apple's recognition system
                if result.isFinal && !hasProcessedFinalResult {
                    // Mark as processed to prevent duplicate processing
                    hasProcessedFinalResult = true
                    silenceTimer?.invalidate() // Cancel silence timer
                    
                    // Store the final text
                    let finalText = transcription
                    print("Final text captured (system final): \(finalText)")
                    
                    // Process the command if we have text - IMMEDIATELY
                    if !finalText.isEmpty {
                        // Show feedback immediately
                        self.showFeedbackWithMessage("Recognized: \(finalText)")
                        
                        // Process the command immediately on the main thread
                        print("Processing command immediately: \(finalText)")
                        self.processCommand(finalText)
                        
                        // Stop listening right after processing
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        self.recognitionTask = nil
                        self.recognitionRequest = nil
                        self.isListening = false
                    } else {
                        print("WARNING: Empty final text detected")
                        self.showFeedbackWithMessage("Sorry, I didn't catch that")
                        
                        // Stop listening
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        self.recognitionTask = nil
                        self.recognitionRequest = nil
                        self.isListening = false
                    }
                } 
                // If not final but we have text, start the silence timer
                else if !transcription.isEmpty {
                    createSilenceTimer()
                }
            }
            
            // Handle errors
            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                
                // Don't treat cancellation as an error if we have text
                let isCancellationWithText = error.localizedDescription.contains("canceled") && !self.recognizedText.isEmpty
                
                if !isCancellationWithText && !hasProcessedFinalResult {
                    // Mark as processed
                    hasProcessedFinalResult = true
                    
                    // Process any text we might have before the error
                    if !self.recognizedText.isEmpty {
                        print("Using partial text before error: \(self.recognizedText)")
                        self.showFeedbackWithMessage("Recognized: \(self.recognizedText)")
                        
                        DispatchQueue.main.async {
                            self.processCommand(self.recognizedText)
                        }
                    } else {
                        self.showFeedbackWithMessage("Speech recognition error")
                    }
                    
                    // Stop listening
                    DispatchQueue.main.async {
                        self.isListening = false
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        self.recognitionTask = nil
                        self.recognitionRequest = nil
                    }
                }
            }
        }
        
        // Configure audio format
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        // Start audio engine
        do {
            // Make sure audio session is active
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            // Prepare and start the audio engine
            audioEngine.prepare()
            try audioEngine.start()
            
            // Update UI state
            DispatchQueue.main.async {
                self.isListening = true
                self.showFeedbackWithMessage("Listening...")
                print("Audio engine started successfully")
            }
        } catch {
            print("Audio engine error: \(error.localizedDescription)")
            showFeedbackWithMessage("Could not start audio engine: \(error.localizedDescription)")
            
            // Clean up on error
            recognitionTask = nil
            // Clear the request reference
            self.recognitionRequest = nil
            
            DispatchQueue.main.async {
                self.isListening = false
            }
        }
    }
    
    // Stop listening for voice commands
    func stopListening() {
        print("Stopping voice recognition")
        
        // Save any recognized text before stopping
        let currentText = self.recognizedText
        print("Text at stop: \(currentText)")
        
        // Cancel any ongoing recognition task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Stop audio engine
        audioEngine.stop()
        
        // Remove audio tap if installed
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // Cleanup request - set to nil after task is canceled
        self.recognitionRequest = nil
        
        // Update state
        DispatchQueue.main.async {
            self.isListening = false
        }
        
        // Process any recognized text if it exists
        if !currentText.isEmpty {
            print("Processing text from stopListening: \(currentText)")
            self.showFeedbackWithMessage("Recognized: \(currentText)")
            
            // Process the command with a slight delay to ensure UI updates first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.processCommand(currentText)
            }
        } else {
            // Cancel any pending commands if no text was recognized
            cancelPendingCommands()
        }
        
        // Try to deactivate audio session
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Could not deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    // Cancel any pending command processing
    private var pendingWorkItems: [DispatchWorkItem] = []
    
    func cancelPendingCommands() {
        // Cancel any delayed command processing
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        // Cancel any pending work items
        pendingWorkItems.forEach { $0.cancel() }
        pendingWorkItems.removeAll()
        
        // Clear any feedback that might be showing
        DispatchQueue.main.async {
            self.showFeedback = false
        }
    }
    
    // Process recognized command
    private func processCommand(_ command: String) {
        print("Processing voice command: \(command)")
        
        // Normalize the command for consistent matching
        let normalizedCommand = command.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print("Normalized command: \(normalizedCommand)")
        
        // Ensure we're on the main thread for UI updates and notifications
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                self.processCommandOnMainThread(normalizedCommand)
            }
        } else {
            self.processCommandOnMainThread(normalizedCommand)
        }
    }
    
    // Process command on main thread
    private func processCommandOnMainThread(_ normalizedCommand: String) {
        
        // Check for registered commands
        for (phrase, handler) in commandHandlers {
            if normalizedCommand.contains(phrase) {
                DispatchQueue.main.async {
                    self.showFeedbackWithMessage("Executing: \(phrase)")
                    handler()
                }
                return
            }
        }
        
        // NAVIGATION COMMANDS
        
        // Home tab
        if normalizedCommand.contains("go to home") || normalizedCommand.contains("show home") {
            showFeedbackWithMessage("Going to home screen")
            NotificationCenter.default.post(name: Notification.Name("NavigateToTab"), object: nil, userInfo: ["tab": "home"])
            return
        }
        
        // Nutrition tab
        if normalizedCommand.contains("go to nutrition") || normalizedCommand.contains("show nutrition") || normalizedCommand.contains("open nutrition") {
            showFeedbackWithMessage("Going to nutrition screen")
            NotificationCenter.default.post(name: Notification.Name("NavigateToTab"), object: nil, userInfo: ["tab": "nutrition"])
            return
        }
        
        // Water tab
        if normalizedCommand.contains("go to water") || normalizedCommand.contains("show water") || 
           normalizedCommand.contains("water tracker") || normalizedCommand.contains("open water") {
            showFeedbackWithMessage("Going to water tracking screen")
            NotificationCenter.default.post(name: Notification.Name("NavigateToTab"), object: nil, userInfo: ["tab": "water"])
            return
        }
        
        // Fasting tab
        if normalizedCommand.contains("go to fasting") || normalizedCommand.contains("show fasting") || 
           normalizedCommand.contains("fasting timer") || normalizedCommand.contains("open fasting") || 
           normalizedCommand.contains("go to fast") || normalizedCommand.contains("show fast") {
            showFeedbackWithMessage("Going to fasting screen")
            NotificationCenter.default.post(name: Notification.Name("NavigateToTab"), object: nil, userInfo: ["tab": "fasting"])
            return
        }
        
        // Menu/Settings tab
        if normalizedCommand.contains("go to settings") || normalizedCommand.contains("show settings") || 
           normalizedCommand.contains("go to menu") || normalizedCommand.contains("show menu") || 
           normalizedCommand.contains("open settings") || normalizedCommand.contains("open menu") || 
           normalizedCommand.contains("go to more") || normalizedCommand.contains("show more") {
            showFeedbackWithMessage("Going to settings/menu screen")
            NotificationCenter.default.post(name: Notification.Name("NavigateToTab"), object: nil, userInfo: ["tab": "settings"])
            return
        }
        
        // Help navigation
        if normalizedCommand.contains("show help") || normalizedCommand.contains("open help") || normalizedCommand.contains("go to help") {
            showFeedbackWithMessage("Opening help section")
            NotificationCenter.default.post(name: Notification.Name("NavigateTo"), object: nil, userInfo: ["destination": "help"])
            return
        }
        
        // Medications navigation
        if normalizedCommand.contains("show medication") || normalizedCommand.contains("open medication") || 
           normalizedCommand.contains("go to medication") || normalizedCommand.contains("view medication") {
            showFeedbackWithMessage("Opening medications")
            NotificationCenter.default.post(name: Notification.Name("NavigateTo"), object: nil, userInfo: ["destination": "medications"])
            return
        }
        
        // ACTION COMMANDS
        
        // Add water
        if normalizedCommand.contains("add water") || normalizedCommand.contains("log water") {
            showFeedbackWithMessage("Logging water consumption")
            NotificationCenter.default.post(name: Notification.Name("VoiceAction"), object: nil, userInfo: ["action": "addWater"])
            return
        }
        
        // Log meal
        if normalizedCommand.contains("log meal") || normalizedCommand.contains("add meal") || normalizedCommand.contains("record meal") {
            showFeedbackWithMessage("Recording a new meal")
            NotificationCenter.default.post(name: Notification.Name("VoiceAction"), object: nil, userInfo: ["action": "logMeal"])
            return
        }
        
        // Start fast
        if normalizedCommand.contains("start fast") || normalizedCommand.contains("begin fast") || normalizedCommand.contains("start fasting") {
            showFeedbackWithMessage("Starting fasting timer")
            NotificationCenter.default.post(name: Notification.Name("VoiceAction"), object: nil, userInfo: ["action": "startFast"])
            return
        }
        
        // Set reminder
        if normalizedCommand.contains("set reminder") || normalizedCommand.contains("create reminder") || normalizedCommand.contains("add reminder") {
            showFeedbackWithMessage("Creating a new reminder")
            NotificationCenter.default.post(name: Notification.Name("VoiceAction"), object: nil, userInfo: ["action": "setReminder"])
            return
        }
        
        // INFORMATION COMMANDS
        
        // Progress summary
        if normalizedCommand.contains("progress") || normalizedCommand.contains("my progress") {
            showFeedbackWithMessage("Checking your daily progress")
            NotificationCenter.default.post(name: Notification.Name("VoiceInfo"), object: nil, userInfo: ["info": "progressSummary"])
            return
        }
        
        // Water intake
        if normalizedCommand.contains("water today") || normalizedCommand.contains("today's water") || normalizedCommand.contains("how much water") {
            showFeedbackWithMessage("Checking your water intake")
            NotificationCenter.default.post(name: Notification.Name("VoiceInfo"), object: nil, userInfo: ["info": "waterIntake"])
            return
        }
        
        // Next medication
        if normalizedCommand.contains("next medication") || normalizedCommand.contains("next med") || normalizedCommand.contains("when is my next medication") {
            showFeedbackWithMessage("Checking your next medication")
            NotificationCenter.default.post(name: Notification.Name("VoiceInfo"), object: nil, userInfo: ["info": "nextMedication"])
            return
        }
        
        // Fasting status
        if normalizedCommand.contains("fasting status") || normalizedCommand.contains("fast status") || normalizedCommand.contains("how is my fast") {
            showFeedbackWithMessage("Checking your fasting status")
            NotificationCenter.default.post(name: Notification.Name("VoiceInfo"), object: nil, userInfo: ["info": "fastingStatus"])
            return
        }
        
        // Command not recognized
        showFeedbackWithMessage("Command not recognized: \(normalizedCommand)")
        // Provide a hint for help
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showFeedbackWithMessage("Try saying 'Show help' for available commands")
        }
    }
    
    // Show feedback message
    private func showFeedbackWithMessage(_ message: String) {
        // Ensure we're on the main thread
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                self.showFeedbackWithMessageOnMain(message)
            }
        } else {
            self.showFeedbackWithMessageOnMain(message)
        }
    }
    
    // Show feedback message on main thread
    private func showFeedbackWithMessageOnMain(_ message: String) {
        // Cancel any previous feedback hide timers
        cancelPendingFeedbackTimers()
        
        // Update feedback message immediately
        self.feedbackMessage = message
        self.showFeedback = true
        
        // Print for debugging
        print("Voice Assistant Feedback: \(message)")
        
        // Auto-hide feedback after 3 seconds
        let hideWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.showFeedback = false
        }
        
        // Store the work item so it can be cancelled if needed
        self.pendingWorkItems.append(hideWorkItem)
        
        // Schedule the work item
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: hideWorkItem)
    }
    
    // Cancel pending feedback timers
    private func cancelPendingFeedbackTimers() {
        pendingWorkItems.forEach { $0.cancel() }
        pendingWorkItems.removeAll()
    }
    
    // Speech recognizer availability changed
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            isListening = false
            showFeedbackWithMessage("Speech recognition not available")
        }
    }
}
