import SwiftUI

struct FastingTimerView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var fastingState: FastingState = .fasting
    @State private var progress: Double = 0.65
    @State private var startTime: Date = Date().addingTimeInterval(-50400) // Started 14 hours ago
    @State private var endTime: Date = Date().addingTimeInterval(21600) // Ends in 6 hours
    @State private var showingProtocolPicker = false
    @State private var showingEmergencyAlert = false
    
    enum FastingState {
        case fasting
        case eating
        
        var color: Color {
            switch self {
            case .fasting: return .blue
            case .eating: return .green
            }
        }
        
        var title: String {
            switch self {
            case .fasting: return "Fasting"
            case .eating: return "Eating Window"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Current protocol and status
                    currentProtocolSection
                    
                    // Large timer display
                    timerSection
                    
                    // Timeline visualization
                    timelineSection
                    
                    // Action buttons
                    actionButtonsSection
                    
                    // Help tips
                    Divider()
                        .padding(.vertical)
                    
                    helpTipsSection
                }
                .padding()
            }
            .navigationTitle("Fasting Timer")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingProtocolPicker = true
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Change Fasting Protocol")
                }
            }
            .sheet(isPresented: $showingProtocolPicker) {
                protocolPickerView
            }
            .alert(isPresented: $showingEmergencyAlert) {
                Alert(
                    title: Text("Emergency Override"),
                    message: Text("This will end your current fast early. Are you sure?"),
                    primaryButton: .destructive(Text("Yes, End Fast")) {
                        fastingState = .eating
                        // Reset fasting timer
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Current protocol section
    private var currentProtocolSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Protocol: \(userSettings.activeFastingProtocol.rawValue)")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            Text(userSettings.activeFastingProtocol.description)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Timer section with large display
    private var timerSection: some View {
        VStack(spacing: 20) {
            Text(fastingState.title)
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                .foregroundColor(fastingState.color)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(fastingState.color)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(fastingState.color)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress)
                
                VStack(spacing: 5) {
                    Text(timeRemaining)
                        .font(.system(size: userSettings.textSize.size + 12, weight: .bold))
                    
                    Text("Remaining")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 250, height: 250)
            .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Started")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    
                    Text(timeFormatter.string(from: startTime))
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Ends")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    
                    Text(timeFormatter.string(from: endTime))
                        .font(.system(size: userSettings.textSize.size))
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Visual timeline section
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Today's Schedule")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            timelineView
                .frame(height: 80)
            
            if !userSettings.medications.isEmpty {
                Text("Medication Schedule")
                    .font(.system(size: userSettings.textSize.size - 2, weight: .medium))
                    .padding(.top, 5)
                
                // Show medication dots on timeline
                ForEach(userSettings.medications) { medication in
                    HStack {
                        Image(systemName: "pill.fill")
                            .foregroundColor(.blue)
                        
                        Text(medication.name)
                            .font(.system(size: userSettings.textSize.size - 2))
                        
                        Spacer()
                        
                        Text(timeFormatter.string(from: medication.schedule[0]))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Visual timeline implementation
    private var timelineView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(height: 40)
                
                // Eating window segment
                let startPosition = timeToPosition(date: startTime, width: geometry.size.width)
                let endPosition = timeToPosition(date: endTime, width: geometry.size.width)
                let segmentWidth = endPosition - startPosition
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(fastingState == .fasting ? Color.blue : Color.green)
                    .frame(width: segmentWidth, height: 40)
                    .position(x: startPosition + segmentWidth/2, y: 20)
                
                // Current time indicator
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: 50)
                    .position(x: timeToPosition(date: Date(), width: geometry.size.width), y: 20)
                
                // Time labels
                VStack {
                    Spacer()
                    HStack {
                        Text("12 AM")
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("12 PM")
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("12 AM")
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    // Action buttons section
    private var actionButtonsSection: some View {
        VStack(spacing: 15) {
            Button(action: {
                // Toggle fasting state
                fastingState = fastingState == .fasting ? .eating : .fasting
            }) {
                Text(fastingState == .fasting ? "End Fasting Early" : "Start Fasting")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fastingState == .fasting ? Color.red : Color.green)
                    .cornerRadius(12)
            }
            
            Button(action: {
                showingEmergencyAlert = true
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    
                    Text("Emergency Override")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.red)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    // Help tips section
    private var helpTipsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Health Tips")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            tipRow(icon: "drop.fill", text: "Remember to drink plenty of water during your fast")
            
            tipRow(icon: "exclamationmark.triangle", text: "If you feel unwell, end your fast immediately")
            
            tipRow(icon: "bed.double.fill", text: "Quality sleep helps with fasting results")
            
            Button(action: {
                // Action to show more health tips
            }) {
                Text("View More Health Tips")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Protocol picker view
    private var protocolPickerView: some View {
        NavigationView {
            List {
                ForEach(FastingProtocol.allCases) { proto in
                    Button(action: {
                        userSettings.activeFastingProtocol = proto
                        showingProtocolPicker = false
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(proto.rawValue)
                                    .font(.system(size: userSettings.textSize.size))
                                
                                Text(proto.description)
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if userSettings.activeFastingProtocol == proto {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select Protocol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingProtocolPicker = false
                    }
                }
            }
        }
    }
    
    // Helper method for tip rows
    private func tipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size - 2))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    // Computed properties and helper methods
    private var timeRemaining: String {
        let duration = endTime.timeIntervalSince(Date())
        if duration <= 0 {
            return "Complete"
        }
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        return String(format: "%d:%02d", hours, minutes)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private func timeToPosition(date: Date, width: CGFloat) -> CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let totalMinutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
        let percentage = CGFloat(totalMinutes) / CGFloat(24 * 60)
        return percentage * width
    }
}

struct FastingTimerView_Previews: PreviewProvider {
    static var previews: some View {
        FastingTimerView()
            .environmentObject(UserSettings())
    }
} 