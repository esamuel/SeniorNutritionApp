import SwiftUI

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
                        if userSettings.activeFastingProtocol == .custom {
                            showingCustomProtocol = true
                        } else {
                            showingProtocolPicker = true
                        }
                    }) {
                        HStack {
                            Text(userSettings.activeFastingProtocol.rawValue)
                                .font(.system(size: userSettings.textSize.size))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityLabel("Change Fasting Protocol")
                }
            }
            .sheet(isPresented: $showingProtocolPicker) {
                protocolPickerView
            }
            .sheet(isPresented: $showingLastMealPicker) {
                timePickerView(title: "Last Meal Time", time: Binding(
                    get: { fastingManager.lastMealTime },
                    set: { fastingManager.updateLastMealTime($0) }
                )) {
                    showingLastMealPicker = false
                }
            }
            .sheet(isPresented: $showingNextMealPicker) {
                timePickerView(title: "Next Meal Time", time: Binding(
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
                    title: Text("Emergency Override"),
                    message: Text("This will end your current fast early. Are you sure?"),
                    primaryButton: .destructive(Text("Yes, End Fast")) {
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
            Text(fastingManager.fastingState.title)
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                .foregroundColor(fastingManager.fastingState.color)
            
            ZStack {
                // Complete background circle in gray
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20))
                    .foregroundColor(Color(.systemGray5))
                
                // Fasting period (red)
                Circle()
                    .trim(from: 0, to: calculateFastingPortion())
                    .stroke(fastingManager.fastingState == .fasting ? Color.red : Color.red.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                // Eating period (green)
                Circle()
                    .trim(from: calculateFastingPortion(), to: 1)
                    .stroke(fastingManager.fastingState == .eating ? Color.green : Color.green.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                // Progress indicator
                Circle()
                    .trim(from: 0, to: 0.03)
                    .stroke(style: StrokeStyle(lineWidth: 3))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: calculateProgressDegrees()))
                
                VStack(spacing: 5) {
                    let remaining = calculateRemainingTime()
                    Text(formatTimeString(hours: remaining.hours, minutes: remaining.minutes))
                        .font(.system(size: userSettings.textSize.size + 12, weight: .bold))
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.5), value: fastingManager.currentTime)
                    
                    Text("\(calculatePercentageRemaining())% remain")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.5), value: fastingManager.currentTime)
                    
                    Text(fastingManager.fastingState == .fasting ? "of fasting" : "of eating window")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 250, height: 250)
            .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Last Meal")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingLastMealPicker = true
                    }) {
                        Text(timeFormatter.string(from: fastingManager.lastMealTime))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Next Meal")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingNextMealPicker = true
                    }) {
                        Text(timeFormatter.string(from: fastingManager.nextMealTime))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.blue)
                    }
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
            
            // Fasting and eating windows
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.blue)
                    Text("Fasting Window: \(formatTimeRange(start: fastingManager.lastMealTime, end: fastingManager.nextMealTime))")
                        .font(.system(size: userSettings.textSize.size))
                }
                
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                    Text("Eating Window: \(formatTimeRange(start: fastingManager.nextMealTime, end: fastingManager.lastMealTime))")
                        .font(.system(size: userSettings.textSize.size))
                }
            }
            .padding(.top, 10)
            
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
                
                // Fasting window segment
                let fastingStartPosition = timeToPosition(date: fastingManager.lastMealTime, width: geometry.size.width)
                let fastingEndPosition = timeToPosition(date: fastingManager.nextMealTime, width: geometry.size.width)
                let fastingWidth = fastingEndPosition - fastingStartPosition
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red)
                    .frame(width: fastingWidth, height: 40)
                    .position(x: fastingStartPosition + fastingWidth/2, y: 20)
                
                // Eating window segment
                let eatingStartPosition = fastingEndPosition
                let eatingEndPosition = timeToPosition(date: fastingManager.lastMealTime, width: geometry.size.width) + geometry.size.width
                let eatingWidth = eatingEndPosition - eatingStartPosition
                
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
                if fastingManager.fastingState == .fasting {
                    showingEmergencyAlert = true
                } else {
                    showingLastMealPicker = true
                }
            }) {
                Text(fastingManager.fastingState == .fasting ? "End Fasting Early" : "Start Fasting")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fastingManager.fastingState == .fasting ? Color.red : Color.green)
                    .cornerRadius(12)
            }
            
            if fastingManager.fastingState == .fasting {
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
            .navigationTitle("Select Protocol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
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
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(`protocol`.rawValue)
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
            .shadow(radius: 2)
        }
        
        private var benefitsSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Benefits")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                ForEach(benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(benefit)
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
            }
        }
        
        private var recommendedForSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Recommended For")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                ForEach(recommendedFor, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        Text(recommendation)
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
            }
        }
        
        private var guidelinesSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Guidelines")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                ForEach(guidelines, id: \.self) { guideline in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        Text(guideline)
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
                    "Take medications as prescribed with food if needed"
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
    }
    
    // Custom protocol setup view
    private var customProtocolView: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom Protocol Setup")) {
                    Stepper("Fasting Hours: \(customFastingHours)", value: $customFastingHours, in: 1...23)
                    Stepper("Eating Hours: \(customEatingHours)", value: $customEatingHours, in: 1...23)
                    
                    if customFastingHours + customEatingHours != 24 {
                        Text("Total hours must equal 24")
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Save Protocol") {
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
            .navigationTitle("Custom Protocol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingCustomProtocolSheet = false
                    }
                }
            }
        }
    }
    
    // Time picker view
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
                
                Button(action: {
                    onSave()
                    if title == "Last Meal Time" {
                        showingLastMealPicker = false
                    } else {
                        showingNextMealPicker = false
                    }
                }) {
                    Text("Save")
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
                    Button("Cancel") {
                        if title == "Last Meal Time" {
                            showingLastMealPicker = false
                        } else {
                            showingNextMealPicker = false
                        }
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
        let duration = fastingManager.nextMealTime.timeIntervalSince(Date())
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
    
    // Helper methods
    private func calculateFastingPortion() -> Double {
        Double(userSettings.activeFastingProtocol.fastingHours) / 24.0
    }

    private func calculateRemainingTime() -> (hours: Int, minutes: Int, totalMinutes: Int) {
        let now = Date()
        let calendar = Calendar.current
        
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let lastMealMinutes = calendar.component(.hour, from: fastingManager.lastMealTime) * 60 + calendar.component(.minute, from: fastingManager.lastMealTime)
        
        // Calculate elapsed minutes since last meal
        var elapsedMinutes: Int
        if currentMinutes >= lastMealMinutes {
            elapsedMinutes = currentMinutes - lastMealMinutes
        } else {
            elapsedMinutes = (currentMinutes + 24 * 60) - lastMealMinutes
        }
        
        // Get protocol hours from user settings
        let fastingMinutes = userSettings.activeFastingProtocol.fastingHours * 60
        let eatingMinutes = userSettings.activeFastingProtocol.eatingHours * 60
        let totalCycleMinutes = fastingMinutes + eatingMinutes
        
        // Normalize elapsed minutes to current cycle
        elapsedMinutes = elapsedMinutes % totalCycleMinutes
        
        var remainingMinutes: Int
        
        // Determine which window we're in and calculate remaining time
        if elapsedMinutes < fastingMinutes {
            remainingMinutes = fastingMinutes - elapsedMinutes
        } else {
            remainingMinutes = totalCycleMinutes - elapsedMinutes
        }
        
        let hours = remainingMinutes / 60
        let minutes = remainingMinutes % 60
        
        return (hours, minutes, remainingMinutes)
    }

    private func calculatePercentageRemaining() -> Int {
        let remaining = calculateRemainingTime()
        let totalMinutes = fastingManager.fastingState == .fasting ? 
            userSettings.activeFastingProtocol.fastingHours * 60 : 
            userSettings.activeFastingProtocol.eatingHours * 60
        let percentageRemaining = (Double(remaining.totalMinutes) / Double(totalMinutes)) * 100
        return min(100, max(0, Int(round(percentageRemaining))))
    }

    private func calculateProgressDegrees() -> Double {
        let remaining = calculateRemainingTime()
        let totalMinutes = fastingManager.fastingState == .fasting ? 
            Double(userSettings.activeFastingProtocol.fastingHours * 60) : 
            Double(userSettings.activeFastingProtocol.eatingHours * 60)
        let progress = 1.0 - (Double(remaining.totalMinutes) / totalMinutes)
        
        let fastingPortion = Double(userSettings.activeFastingProtocol.fastingHours) / 24.0
        let fastingDegrees = 360.0 * fastingPortion
        let eatingDegrees = 360.0 - fastingDegrees
        
        let startAngle = -90.0
        let sweepAngle = fastingManager.fastingState == .fasting ? fastingDegrees : eatingDegrees
        
        return startAngle + (sweepAngle * progress)
    }

    private func formatTimeString(hours: Int, minutes: Int) -> String {
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func startFasting() {
        fastingManager.updateLastMealTime(Date())
    }
    
    private func endFasting() {
        fastingManager.updateLastMealTime(Date())
    }
    
    private func formatTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

struct FastingTimerView_Previews: PreviewProvider {
    static var previews: some View {
        FastingTimerView()
            .environmentObject(UserSettings())
    }
} 