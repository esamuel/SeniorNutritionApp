import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
// Import models and views needed for this file

// MARK: - TimerSectionView
private struct TimerSectionView: View {
    let fastingState: FastingManager.FastingState
    let currentTime: Date
    let lastMealTime: Date
    let nextMealTime: Date
    let textSize: CGFloat
    let onShowLastMealPicker: () -> Void
    let onShowNextMealPicker: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Timer display
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(fastingState == .fasting ? .green : .orange)
                    .frame(width: 250, height: 250) // Set a specific size for the circle
                
                Circle()
                    .trim(from: 0, to: CGFloat(calculatePercentageRemaining()) / 100)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(fastingState == .fasting ? .green : .orange)
                    .frame(width: 250, height: 250) // Match the size of the background circle
                    .rotationEffect(Angle(degrees: -90))
                
                VStack(spacing: 5) {
                    let remaining = calculateRemainingTime()
                    Text(formatTimeString(hours: remaining.hours, minutes: remaining.minutes))
                        .font(.system(size: textSize + 20, weight: .bold))
                        .contentTransition(.numericText())
                    Text(String(format: "%d%%", calculatePercentageRemaining()))
                        .font(.system(size: textSize))
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                    Text(fastingState == .fasting ? NSLocalizedString("of fasting", comment: "") : NSLocalizedString("of eating window", comment: ""))
                        .font(.system(size: textSize - 2))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("Last Meal", comment: ""))
                        .font(.system(size: textSize - 2))
                        .foregroundColor(.secondary)
                    Button(action: onShowLastMealPicker) {
                        Text(lastMealTime.localizedTimeString())
                            .font(.system(size: textSize))
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(NSLocalizedString("Next Meal", comment: ""))
                        .font(.system(size: textSize - 2))
                        .foregroundColor(.secondary)
                    Button(action: onShowNextMealPicker) {
                        Text(nextMealTime.localizedTimeString())
                            .font(.system(size: textSize))
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func calculateRemainingTime() -> (hours: Int, minutes: Int) {
        let calendar = Calendar.current
        let now = currentTime
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let lastMealMinutes = calendar.component(.hour, from: lastMealTime) * 60 + calendar.component(.minute, from: lastMealTime)
        let nextMealMinutes = calendar.component(.hour, from: nextMealTime) * 60 + calendar.component(.minute, from: nextMealTime)
        
        var remainingMinutes: Int
        if fastingState == .fasting {
            if nextMealMinutes > currentMinutes {
                remainingMinutes = nextMealMinutes - currentMinutes
            } else {
                remainingMinutes = (nextMealMinutes + 24 * 60) - currentMinutes
            }
        } else {
            if lastMealMinutes > currentMinutes {
                remainingMinutes = lastMealMinutes - currentMinutes
            } else {
                remainingMinutes = (lastMealMinutes + 24 * 60) - currentMinutes
            }
        }
        
        let hours = remainingMinutes / 60
        let minutes = remainingMinutes % 60
        return (hours, minutes)
    }
    
    private func calculatePercentageRemaining() -> Int {
        let calendar = Calendar.current
        let now = currentTime
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let lastMealMinutes = calendar.component(.hour, from: lastMealTime) * 60 + calendar.component(.minute, from: lastMealTime)
        let nextMealMinutes = calendar.component(.hour, from: nextMealTime) * 60 + calendar.component(.minute, from: nextMealTime)
        
        let totalMinutes: Int
        let remainingMinutes: Int
        
        if fastingState == .fasting {
            if nextMealMinutes > lastMealMinutes {
                totalMinutes = nextMealMinutes - lastMealMinutes
            } else {
                totalMinutes = (nextMealMinutes + 24 * 60) - lastMealMinutes
            }
            
            if nextMealMinutes > currentMinutes {
                remainingMinutes = nextMealMinutes - currentMinutes
            } else {
                remainingMinutes = (nextMealMinutes + 24 * 60) - currentMinutes
            }
        } else {
            if lastMealMinutes > nextMealMinutes {
                totalMinutes = lastMealMinutes - nextMealMinutes
            } else {
                totalMinutes = (lastMealMinutes + 24 * 60) - nextMealMinutes
            }
            
            if lastMealMinutes > currentMinutes {
                remainingMinutes = lastMealMinutes - currentMinutes
            } else {
                remainingMinutes = (lastMealMinutes + 24 * 60) - currentMinutes
            }
        }
        
        let percentage = (Double(remainingMinutes) / Double(totalMinutes)) * 100
        return min(100, max(0, Int(round(percentage))))
    }
    
    private func formatTimeString(hours: Int, minutes: Int) -> String {
        return String(format: "%d:%02d", hours, minutes)
    }
}

// MARK: - TimelineSectionView
private struct TimelineSectionView: View {
    let lastMealTime: Date
    let nextMealTime: Date
    let textSize: CGFloat
    let timeFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Today's Schedule", comment: ""))
                .font(.system(size: textSize, weight: .bold))
            
            // Fasting and eating windows
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.blue)
                    Text(NSLocalizedString("Fasting Window", comment: "") + ": " + formatTimeRange(start: lastMealTime, end: nextMealTime))
                        .font(.system(size: textSize))
                }
                
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                    Text(NSLocalizedString("Eating Window", comment: "") + ": " + formatTimeRange(start: nextMealTime, end: lastMealTime))
                        .font(.system(size: textSize))
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func formatTimeRange(start: Date, end: Date) -> String {
        return "\(timeFormatter.string(from: start)) - \(timeFormatter.string(from: end))"
    }
}

// MARK: - FastingTimerView
struct FastingTimerView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var fastingManager = FastingManager.shared
    
    @State private var showingProtocolPicker = false
    @State private var showingEmergencyAlert = false
    @State private var showingLastMealPicker = false
    @State private var showingNextMealPicker = false
    @State private var showingCustomProtocolSheet = false
    @State private var customFastingHours = 16
    @State private var customEatingHours = 8
    @State private var showingCustomProtocol = false
    
    // Use our localized time formatter
    private var timeFormatter: DateFormatter {
        return FastingManager.getLocalizedTimeFormatter()
    }
    
    private func formatTimeRange(start: Date, end: Date) -> String {
        return Date.localizedTimeRange(start: start, end: end)
    }
    
    private func endFasting() {
        fastingManager.updateLastMealTime(Date())
        showingEmergencyAlert = false
    }
    
    private func startFasting() {
        fastingManager.updateLastMealTime(Date())
    }
    
    private func timePickerView(title: String, time: Binding<Date>, onSave: @escaping () -> Void) -> some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                
                DatePicker(
                    title,
                    selection: time,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .datePickerLTR()
                
                Button(action: onSave) {
                    Text(NSLocalizedString("Save", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        if title == NSLocalizedString("Last Meal Time", comment: "") {
                            showingLastMealPicker = false
                        } else {
                            showingNextMealPicker = false
                        }
                    }
                }
            }
        }
    }
    
    private var customProtocolView: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Custom Protocol Setup", comment: ""))) {
                    Stepper(String(format: NSLocalizedString("Fasting Hours: %d", comment: ""), customFastingHours), value: $customFastingHours, in: 1...23)
                    Stepper(String(format: NSLocalizedString("Eating Hours: %d", comment: ""), customEatingHours), value: $customEatingHours, in: 1...23)
                    
                    if customFastingHours + customEatingHours != 24 {
                        Text(NSLocalizedString("Total hours must equal 24", comment: ""))
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(NSLocalizedString("Save Protocol", comment: "")) {
                        if customFastingHours + customEatingHours == 24 {
                            FastingProtocol.setCustomProtocol(
                                fastingHours: customFastingHours,
                                eatingHours: customEatingHours
                            )
                            userSettings.activeFastingProtocol = .custom
                            showingCustomProtocolSheet = false
                            showingProtocolPicker = false
                        }
                    }
                    .disabled(customFastingHours + customEatingHours != 24)
                }
            }
            .navigationTitle(NSLocalizedString("Custom Protocol", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        showingCustomProtocolSheet = false
                    }
                }
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
            .navigationTitle(NSLocalizedString("Fasting Timer", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if userSettings.activeFastingProtocol == .custom {
                            showingCustomProtocol = true
                        } else {
                            showingProtocolPicker = true
                        }
                    }) {
                        HStack {
                            Text(userSettings.activeFastingProtocol.localizedTitle)
                                .font(.system(size: userSettings.textSize.size))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityLabel(NSLocalizedString("Change Fasting Protocol", comment: ""))
                }
            }
            .sheet(isPresented: $showingProtocolPicker) {
                protocolPickerView
            }
            .sheet(isPresented: $showingLastMealPicker) {
                timePickerView(title: NSLocalizedString("Last Meal Time", comment: ""), time: Binding(
                    get: { fastingManager.lastMealTime },
                    set: { fastingManager.updateLastMealTime($0) }
                )) {
                    showingLastMealPicker = false
                }
            }
            .sheet(isPresented: $showingNextMealPicker) {
                timePickerView(title: NSLocalizedString("Next Meal Time", comment: ""), time: Binding(
                    get: { fastingManager.nextMealTime },
                    set: { newTime in
                        fastingManager.nextMealTime = newTime
                        let calendar = Calendar.current
                        fastingManager.lastMealTime = calendar.date(byAdding: .hour, value: -userSettings.activeFastingProtocol.fastingHours, to: newTime) ?? newTime
                    }
                )) {
                    showingNextMealPicker = false
                }
            }
            .sheet(isPresented: $showingCustomProtocol) {
                CustomFastingProtocolView()
            }
            .alert(isPresented: $showingEmergencyAlert) {
                Alert(
                    title: Text(NSLocalizedString("Emergency Override", comment: "")),
                    message: Text(NSLocalizedString("This will end your current fast early. Are you sure?", comment: "")),
                    primaryButton: .destructive(Text(NSLocalizedString("Yes, End Fast", comment: ""))) {
                        endFasting()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fastingManager.setUserSettings(userSettings)
        }
    }
    
    // Current protocol section
    private var currentProtocolSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(format: NSLocalizedString("Current Protocol: %@", comment: ""), userSettings.activeFastingProtocol.localizedTitle))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            Text(userSettings.activeFastingProtocol.description.localized)
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
        TimerSectionView(
            fastingState: fastingManager.fastingState,
            currentTime: fastingManager.currentTime,
            lastMealTime: fastingManager.lastMealTime,
            nextMealTime: fastingManager.nextMealTime,
            textSize: userSettings.textSize.size,
            onShowLastMealPicker: { showingLastMealPicker = true },
            onShowNextMealPicker: { showingNextMealPicker = true }
        )
    }
    
    // Timeline section
    private var timelineSection: some View {
        TimelineSectionView(
            lastMealTime: fastingManager.lastMealTime,
            nextMealTime: fastingManager.nextMealTime,
            textSize: userSettings.textSize.size,
            timeFormatter: timeFormatter
        )
    }
    
    // Action buttons section
    private var actionButtonsSection: some View {
        ActionButtonsSectionView(
            fastingState: fastingManager.fastingState,
            textSize: userSettings.textSize.size,
            onEndFasting: { showingEmergencyAlert = true },
            onStartFasting: { showingLastMealPicker = true }
        )
    }
    
    // Help tips section
    private var helpTipsSection: some View {
        HelpTipsSectionView(textSize: userSettings.textSize.size)
    }
    
    // Protocol picker view
    private var protocolPickerView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(FastingProtocol.allCases) { proto in
                        ProtocolCard(
                            protocol: proto,
                            isSelected: userSettings.activeFastingProtocol == proto,
                            onSelect: {
                                if proto == .custom {
                                    showingCustomProtocolSheet = true
                                } else {
                                    userSettings.activeFastingProtocol = proto
                                    showingProtocolPicker = false
                                }
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Select Protocol", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
                        showingProtocolPicker = false
                    }
                }
            }
            .sheet(isPresented: $showingCustomProtocolSheet) {
                customProtocolView
            }
        }
    }
    
    // Protocol Card View
    private struct ProtocolCard: View {
        let `protocol`: FastingProtocol
        let isSelected: Bool
        let onSelect: () -> Void
        @State private var isExpanded = false
        @EnvironmentObject private var userSettings: UserSettings
        
        private var benefitsSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("Benefits", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                ForEach(benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(NSLocalizedString(benefit, comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
            }
        }
        
        private var recommendedForSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("Recommended For", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                ForEach(recommendedFor, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString(recommendation, comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
            }
        }
        
        private var guidelinesSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("Guidelines", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                ForEach(guidelines, id: \.self) { guideline in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        Text(NSLocalizedString(guideline, comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
            }
        }
        
        private var benefits: [String] {
            switch `protocol` {
            case .twelveTwelve:
                return [
                    "Gentle introduction to intermittent fasting",
                    "Helps regulate blood sugar levels",
                    "Supports better sleep patterns",
                    "Minimal disruption to daily routine"
                ]
            case .fourteenTen:
                return [
                    "Enhanced fat burning",
                    "Improved metabolic flexibility",
                    "Better appetite control",
                    "Increased mental clarity",
                    "Supports cellular repair processes"
                ]
            case .sixteenEight:
                return [
                    "Maximum autophagy benefits",
                    "Significant fat burning potential",
                    "Improved insulin sensitivity",
                    "Enhanced cognitive function",
                    "Promotes cellular repair and longevity"
                ]
            case .custom:
                return [
                    "Tailored to your specific needs",
                    "Flexible scheduling",
                    "Adaptable to your lifestyle",
                    "Can be adjusted as needed"
                ]
            }
        }
        
        private var recommendedFor: [String] {
            switch `protocol` {
            case .twelveTwelve:
                return [
                    "Beginners to intermittent fasting",
                    "Those with regular medication schedules",
                    "People with active social lives",
                    "Those who prefer eating dinner with family"
                ]
            case .fourteenTen:
                return [
                    "Experienced fasters looking for more benefits",
                    "Those with stable blood sugar control",
                    "People looking for weight management",
                    "Those with flexible morning schedules"
                ]
            case .sixteenEight:
                return [
                    "Experienced fasters",
                    "Those seeking maximum health benefits",
                    "People with stable health conditions",
                    "Those comfortable with longer fasting periods"
                ]
            case .custom:
                return [
                    "Those with unique scheduling needs",
                    "People with specific health considerations",
                    "Those who've tried other protocols",
                    "People with varying daily routines"
                ]
            }
        }
        
        private var guidelines: [String] {
            switch `protocol` {
            case .twelveTwelve:
                return [
                    "Start your fast after dinner",
                    "Skip breakfast or have it later",
                    "Stay hydrated during fasting",
                    "Break fast with a light meal",
                ]
            case .fourteenTen:
                return [
                    "Consider ending eating by 8 PM",
                    "Break fast around 10 AM",
                    "Plan meals within the 10-hour window",
                    "Stay active but avoid intense exercise while fasting",
                    "Monitor how you feel and adjust if needed"
                ]
            case .sixteenEight:
                return [
                    "End eating by 7 PM",
                    "Break fast at 11 AM",
                    "Plan 2-3 nutritious meals in eating window",
                    "Stay well hydrated",
                    "Consider electrolyte supplementation",
                    "Break fast with protein-rich foods"
                ]
            case .custom:
                return [
                    "Choose times that fit your schedule",
                    "Maintain consistent fasting periods",
                    "Listen to your body's signals",
                    "Adjust the protocol as needed",
                    "Keep track of your progress"
                ]
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(`protocol`.localizedTitle)
                                .font(.system(size: userSettings.textSize.size, weight: .bold))
                            
                            Text(`protocol`.description)
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                            
                            if `protocol` == .custom && userSettings.activeFastingProtocol == .custom {
                                Text("\(UserDefaults.standard.integer(forKey: "customFastingHours")):\(UserDefaults.standard.integer(forKey: "customEatingHours")) Protocol")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 15) {
                        benefitsSection
                        recommendedForSection
                        guidelinesSection
                        
                        Button(action: onSelect) {
                            Text(isSelected ? "Currently Selected" : "Select This Protocol")
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isSelected ? Color.green : Color.blue)
                                .cornerRadius(10)
                        }
                        .disabled(isSelected)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
    
    // MARK: - TimelineView
    private struct TimelineView: View {
        let lastMealTime: Date
        let nextMealTime: Date
        let textSize: CGFloat
        let timeFormatter: DateFormatter
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .frame(height: 40)
                    // Fasting window segment
                    let fastingStartPosition = timeToPosition(date: lastMealTime, width: geometry.size.width)
                    let fastingEndPosition = timeToPosition(date: nextMealTime, width: geometry.size.width)
                    let fastingWidth = max(0, fastingEndPosition - fastingStartPosition)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .frame(width: fastingWidth, height: 40)
                        .position(x: fastingStartPosition + fastingWidth/2, y: 20)
                    // Eating window segment
                    let eatingStartPosition = fastingEndPosition
                    let eatingEndPosition = timeToPosition(date: lastMealTime, width: geometry.size.width) + geometry.size.width
                    let eatingWidth = max(0, eatingEndPosition - eatingStartPosition)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                        .frame(width: eatingWidth, height: 40)
                        .position(x: eatingStartPosition + eatingWidth/2, y: 20)
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
                                .font(.system(size: textSize - 4))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("12 PM")
                                .font(.system(size: textSize - 4))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("12 AM")
                                .font(.system(size: textSize - 4))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        
        private func timeToPosition(date: Date, width: CGFloat) -> CGFloat {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let totalMinutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
            let percentage = CGFloat(totalMinutes) / CGFloat(24 * 60)
            return percentage * width
        }
    }
    
    // MARK: - ActionButtonsSectionView
    private struct ActionButtonsSectionView: View {
        let fastingState: FastingManager.FastingState
        let textSize: CGFloat
        let onEndFasting: () -> Void
        let onStartFasting: () -> Void
        
        var body: some View {
            VStack(spacing: 15) {
                Button(action: {
                    if fastingState == .fasting {
                        onEndFasting()
                    } else {
                        onStartFasting()
                    }
                }) {
                    Text(fastingState == .fasting ? "End Fasting Early" : "Start Fasting")
                        .font(.system(size: textSize))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(fastingState == .fasting ? Color.red : Color.green)
                        .cornerRadius(12)
                }
                if fastingState == .fasting {
                    Button(action: onEndFasting) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Emergency Override")
                                .font(.system(size: textSize))
                                .foregroundColor(.red)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    // MARK: - HelpTipsSectionView
    private struct HelpTipsSectionView: View {
        let textSize: CGFloat
        @EnvironmentObject private var userSettings: UserSettings
        @State private var showingHealthTips = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Health Tips")
                    .font(.system(size: textSize, weight: .bold))
                TipRowView(icon: "drop.fill", title: NSLocalizedString("Remember to drink plenty of water during your fast", comment: ""), description: nil, textSize: textSize, iconColor: .blue)
                TipRowView(icon: "exclamationmark.triangle", title: NSLocalizedString("If you feel unwell, end your fast immediately", comment: ""), description: nil, textSize: textSize, iconColor: .orange)
                TipRowView(icon: "bed.double.fill", title: NSLocalizedString("Quality sleep helps with fasting results", comment: ""), description: nil, textSize: textSize, iconColor: .purple)
                Button(action: {
                    showingHealthTips = true
                }) {
                    Text(NSLocalizedString("View More Health Tips", comment: ""))
                        .font(.system(size: textSize - 2))
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 2)
            .sheet(isPresented: $showingHealthTips) {
                PersonalizedHealthTipsView()
                    .environmentObject(userSettings)
            }
        }
    }
    
    struct FastingTimerView_Previews: PreviewProvider {
        static var previews: some View {
            FastingTimerView()
                .environmentObject(UserSettings())
        }
    }
}
