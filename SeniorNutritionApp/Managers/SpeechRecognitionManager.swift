import Foundation
import Speech
import AVFoundation

@MainActor
class SpeechRecognitionManager: NSObject, ObservableObject {
    static let shared = SpeechRecognitionManager()
    
    // Available languages with their display names
    let availableLanguages: [(locale: Locale, name: String)] = [
        (Locale(identifier: "en-US"), "English (US)"),
        (Locale(identifier: "es-ES"), "Español (Spain)"),
        (Locale(identifier: "fr-FR"), "Français (France)"),
        (Locale(identifier: "it-IT"), "Italiano (Italy)"),
        (Locale(identifier: "pt-BR"), "Português (Brazil)"),
        (Locale(identifier: "ru-RU"), "Русский (Russia)"),
        (Locale(identifier: "zh-CN"), "中文 (China)"),
        (Locale(identifier: "ja-JP"), "日本語 (Japan)"),
        (Locale(identifier: "ko-KR"), "한국어 (Korea)"),
        (Locale(identifier: "he-IL"), "עברית (Israel)")
    ]
    
    @Published var selectedLanguageIndex = 0
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var errorMessage: String?
    @Published var isAuthorized = false
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private override init() {
        super.init()
        updateSpeechRecognizer()
        requestAuthorization()
    }
    
    var currentLanguage: Locale {
        availableLanguages[selectedLanguageIndex].locale
    }
    
    func updateLanguage(index: Int) {
        selectedLanguageIndex = index
        updateSpeechRecognizer()
    }
    
    private func updateSpeechRecognizer() {
        speechRecognizer = SFSpeechRecognizer(locale: currentLanguage)
    }
    
    private func requestAuthorization() {
        // Request speech recognition authorization
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            Task { @MainActor in
                switch status {
                case .authorized:
                    self?.isAuthorized = true
                    self?.errorMessage = nil
                case .denied:
                    self?.isAuthorized = false
                    self?.errorMessage = "Speech recognition permission denied. Please enable it in Settings."
                case .restricted:
                    self?.isAuthorized = false
                    self?.errorMessage = "Speech recognition is restricted on this device"
                case .notDetermined:
                    self?.isAuthorized = false
                    self?.errorMessage = "Speech recognition not yet authorized"
                @unknown default:
                    self?.isAuthorized = false
                    self?.errorMessage = "Unknown authorization status"
                }
            }
        }
        
        // Request microphone authorization
        requestMicrophonePermission()
    }
    
    private func requestMicrophonePermission() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isRecording = granted
                    if !granted {
                        self?.errorMessage = "Microphone access is required for voice input"
                    }
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isRecording = granted
                    if !granted {
                        self?.errorMessage = "Microphone access is required for voice input"
                    }
                }
            }
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }
        
        // Check authorization status
        guard isAuthorized else {
            errorMessage = "Speech recognition not authorized. Please enable it in Settings."
            return
        }
        
        // Reset any existing task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Failed to set up audio session: \(error.localizedDescription)"
            return
        }
        
        // Create and configure the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "Unable to create speech recognition request"
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                Task { @MainActor in
                    self.transcribedText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil {
                Task { @MainActor in
                    self.stopRecording()
                }
            }
        }
        
        // Configure audio engine
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        // Start audio engine
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            errorMessage = nil
        } catch {
            errorMessage = "Failed to start audio engine: \(error.localizedDescription)"
            stopRecording()
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        isRecording = false
        recognitionRequest = nil
        recognitionTask = nil
    }
} 