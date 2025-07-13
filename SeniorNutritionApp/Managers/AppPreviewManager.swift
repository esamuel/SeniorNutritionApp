import SwiftUI
import AVFoundation
import ReplayKit

/// Manager for handling app preview video recording and demo mode
class AppPreviewManager: NSObject, ObservableObject {
    static let shared = AppPreviewManager()
    
    @Published var isDemoMode = false
    @Published var isRecording = false
    @Published var recordingError: String?
    
    private let recorder = RPScreenRecorder.shared()
    private var recordingStartTime: Date?
    
    // Demo data for clean recordings (matches AppPreviewPersonalData.md)
    struct DemoData {
        static let userName = "Sarah Johnson"
        static let userAge = 68
        static let userHeight = 163.0 // 5'4"
        static let userWeight = 66.0 // 145 lbs
        static let userGender = "Female"
        
        static let sampleMeals = [
            ("Breakfast", "Oatmeal with berries", "08:30"),
            ("Lunch", "Grilled salmon with quinoa", "12:30"),
            ("Dinner", "Chicken breast with sweet potato", "18:30"),
            ("Snack", "Greek yogurt with honey", "10:30")
        ]
        
        static let sampleMedications = [
            ("Lisinopril", "10mg", "08:00"),
            ("Atorvastatin", "20mg", "21:00"),
            ("Vitamin D3", "2000 IU", "12:00"),
            ("Calcium Carbonate", "600mg", "08:00")
        ]
        
        static let sampleHealthData = [
            ("Blood Pressure", "128/82", "Slightly Elevated"),
            ("Weight", "145.2 lbs", "Stable"),
            ("Heart Rate", "72 bpm", "Good"),
            ("Blood Sugar", "95 mg/dL", "Normal")
        ]
        
        static let sampleAppointments = [
            ("Dr. Martinez", "Cardiologist", "Next Tuesday 2:00 PM"),
            ("Dr. Thompson", "Primary Care", "Next Friday 10:00 AM"),
            ("Lisa Chen", "Nutritionist", "Next Monday 3:00 PM")
        ]
        
        static let sampleWaterIntake = [
            ("07:00", "250ml"),
            ("09:00", "250ml"),
            ("11:00", "250ml"),
            ("13:00", "250ml"),
            ("15:00", "250ml"),
            ("17:00", "250ml")
        ]
        
        static let dailyWaterGoal = 2000 // ml
        static let currentWaterProgress = 1500 // ml (6/8 glasses)
        
        static let fastingProtocol = "16:8 Intermittent Fasting"
        static let fastingStatus = "6 hours into fast"
        static let eatingWindow = "12:00 PM - 8:00 PM"
    }
    
    private override init() {
        super.init()
        setupRecorder()
    }
    
    private func setupRecorder() {
        recorder.delegate = self
    }
    
    /// Enable demo mode for clean app preview recordings
    func enableDemoMode() {
        isDemoMode = true
        print("📹 Demo mode enabled for app preview recording")
    }
    
    /// Disable demo mode
    func disableDemoMode() {
        isDemoMode = false
        print("📹 Demo mode disabled")
    }
    
    /// Start recording app preview
    func startRecording() {
        print("📹 Attempting to start recording...")
        
        guard recorder.isAvailable else {
            print("📹 Screen recording not available")
            recordingError = "Screen recording not available"
            return
        }
        
        guard !recorder.isRecording else {
            print("📹 Already recording")
            recordingError = "Already recording"
            return
        }
        
        // Clear any previous errors
        recordingError = nil
        
        enableDemoMode()
        
        recorder.startRecording { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("📹 Failed to start recording: \(error.localizedDescription)")
                    self?.recordingError = error.localizedDescription
                } else {
                    print("📹 Successfully started recording")
                    self?.isRecording = true
                    self?.recordingStartTime = Date()
                }
            }
        }
    }
    
    /// Stop recording and save
    func stopRecording() {
        guard recorder.isRecording else { 
            print("📹 Recorder is not recording")
            // Force reset state if needed
            forceStopRecording()
            return 
        }
        
        print("📹 Stopping recording...")
        
        recorder.stopRecording { [weak self] previewController, error in
            DispatchQueue.main.async {
                print("📹 Stop recording callback called")
                self?.isRecording = false
                self?.recordingStartTime = nil
                self?.disableDemoMode()
                
                if let error = error {
                    print("📹 Recording error: \(error.localizedDescription)")
                    self?.recordingError = error.localizedDescription
                } else if let previewController = previewController {
                    print("📹 Presenting preview controller")
                    // Present the preview controller
                    self?.presentPreviewController(previewController)
                } else {
                    print("📹 Recording stopped successfully, no preview controller")
                }
            }
        }
    }
    
    /// Force stop recording (for cases where normal stop doesn't work)
    func forceStopRecording() {
        print("📹 Force stopping recording")
        isRecording = false
        recordingStartTime = nil
        disableDemoMode()
        recordingError = nil
    }
    
    private func presentPreviewController(_ controller: RPPreviewViewController) {
        controller.previewControllerDelegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(controller, animated: true)
        }
    }
    
    /// Get recording duration
    var recordingDuration: TimeInterval {
        guard let startTime = recordingStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    /// Check if recording is within App Store limits (15-30 seconds)
    var isWithinTimeLimit: Bool {
        let duration = recordingDuration
        return duration >= 15 && duration <= 30
    }
}

// MARK: - RPScreenRecorderDelegate
extension AppPreviewManager: RPScreenRecorderDelegate {
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        DispatchQueue.main.async {
            self.isRecording = false
            if let error = error {
                self.recordingError = error.localizedDescription
            }
        }
    }
}

// MARK: - RPPreviewViewControllerDelegate
extension AppPreviewManager: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        previewController.dismiss(animated: true)
        print("📹 App preview saved successfully")
    }
}

// MARK: - Preview Recording Helper
struct AppPreviewRecordingView: View {
    @StateObject private var previewManager = AppPreviewManager.shared
    @State private var showingInstructions = false
    
    var body: some View {
        VStack(spacing: 20) {
            if previewManager.isRecording {
                recordingIndicator
            } else {
                recordingControls
            }
            
            if let error = previewManager.recordingError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showingInstructions) {
            AppPreviewInstructionsView()
        }
    }
    
    private var recordingIndicator: some View {
        VStack(spacing: 15) {
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .opacity(0.8)
                
                Text("Recording App Preview")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Text(String(format: "%.1f seconds", previewManager.recordingDuration))
                .font(.title2)
                .fontWeight(.medium)
            
            if !previewManager.isWithinTimeLimit && previewManager.recordingDuration > 30 {
                Text("⚠️ Recording too long (max 30 seconds)")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
            
            VStack(spacing: 10) {
                Button("Stop Recording") {
                    previewManager.stopRecording()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Force Stop") {
                    previewManager.forceStopRecording()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private var recordingControls: some View {
        VStack(spacing: 15) {
            Text("App Preview Recording")
                .font(.headline)
            
            Text("Create 15-30 second videos showcasing your app's key features")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                HStack(spacing: 15) {
                    Button("Instructions") {
                        showingInstructions = true
                    }
                    .buttonStyle(.bordered)
                    
                    NavigationLink(destination: AppPreviewStoryboardView()) {
                        Text("Storyboard")
                    }
                    .buttonStyle(.bordered)
                }
                
                Button("Start Recording") {
                    previewManager.startRecording()
                }
                .buttonStyle(.borderedProminent)
                
                // Demo mode toggle for testing
                Toggle("Demo Mode", isOn: $previewManager.isDemoMode)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

// MARK: - Instructions View
struct AppPreviewInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("App Preview Recording Guidelines")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    instructionSection(
                        title: "📱 Technical Requirements",
                        items: [
                            "15-30 seconds duration",
                            "Portrait or landscape orientation",
                            "Show actual app interface only",
                            "No hands or external interactions"
                        ]
                    )
                    
                    instructionSection(
                        title: "🎬 Content Guidelines",
                        items: [
                            "Start with your app's most compelling feature",
                            "Show 3-5 key functionalities",
                            "Keep each feature demo to 3-5 seconds",
                            "Use smooth transitions between screens"
                        ]
                    )
                    
                    instructionSection(
                        title: "🎯 For Senior Nutrition App",
                        items: [
                            "Show meal logging and nutrition tracking",
                            "Demonstrate medication reminders",
                            "Highlight accessibility features",
                            "Show health monitoring dashboard"
                        ]
                    )
                    
                    instructionSection(
                        title: "📝 Recording Tips",
                        items: [
                            "Demo mode will populate sample data",
                            "Practice the flow before recording",
                            "Record in good lighting",
                            "Ensure device is fully charged"
                        ]
                    )
                }
                .padding()
            }
            .navigationTitle("Recording Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func instructionSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                    Text(item)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#if DEBUG
struct AppPreviewRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AppPreviewRecordingView()
    }
}
#endif 