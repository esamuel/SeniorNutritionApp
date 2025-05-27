import SwiftUI
import CoreData

struct HealthView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    
    // Sheet presentation states
    @State private var showingBloodPressureInput = false
    @State private var showingHeartRateInput = false
    @State private var showingWeightInput = false
    @State private var showingBloodSugarInput = false
    
    // Core Data fetch requests
    @FetchRequest(
        entity: BloodPressureEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BloodPressureEntry.date, ascending: false)],
        animation: .default)
    private var bpEntries: FetchedResults<BloodPressureEntry>
    
    @FetchRequest(
        entity: BloodSugarEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BloodSugarEntry.date, ascending: false)],
        animation: .default)
    private var bsEntries: FetchedResults<BloodSugarEntry>
    
    @FetchRequest(
        entity: HeartRateEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \HeartRateEntry.date, ascending: false)],
        animation: .default)
    private var hrEntries: FetchedResults<HeartRateEntry>
    
    @FetchRequest(
        entity: WeightEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)],
        animation: .default)
    private var weightEntries: FetchedResults<WeightEntry>
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom segmented control
            HStack {
                segmentButton(title: NSLocalizedString("Overview", comment: ""), tag: 0)
                segmentButton(title: NSLocalizedString("Vitals", comment: ""), tag: 1)
                segmentButton(title: NSLocalizedString("Reports", comment: ""), tag: 2)
            }
            .padding()
            .background(Color(.systemBackground))
            
            TabView(selection: $selectedTab) {
                // Overview Tab
                overviewTab
                    .tag(0)
                
                // Vitals Tab
                vitalsTab
                    .tag(1)
                
                // Reports Tab
                reportsTab
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle(NSLocalizedString("Health", comment: ""))
        .sheet(isPresented: $showingBloodPressureInput) {
            AddBloodPressureView()
        }
        .sheet(isPresented: $showingHeartRateInput) {
            AddHeartRateView()
        }
        .sheet(isPresented: $showingWeightInput) {
            AddWeightView()
        }
        .sheet(isPresented: $showingBloodSugarInput) {
            AddBloodSugarView()
        }
    }
    
    private func segmentButton(title: String, tag: Int) -> some View {
        Button(action: {
            withAnimation {
                selectedTab = tag
            }
        }) {
            Text(title)
                .font(.system(size: userSettings.textSize.size))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(selectedTab == tag ? Color.blue : Color.clear)
                .foregroundColor(selectedTab == tag ? .white : .primary)
                .cornerRadius(8)
        }
    }
    
    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Health Summary Card
                summaryCard
                
                // Recent Activity Card
                activityCard
                
                // Health Goals Card
                goalsCard
            }
            .padding()
        }
    }
    
    private var vitalsTab: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Blood Pressure Card
                NavigationLink(destination: BloodPressureDetailView()) {
                    enhancedVitalsCard(
                        title: NSLocalizedString("Blood Pressure", comment: ""),
                        icon: "heart.circle.fill",
                        color: .red,
                        latestReading: formatBPReading(bpEntries.first),
                        type: .bloodPressure,
                        entries: bpEntries
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Heart Rate Card
                NavigationLink(destination: HeartRateDetailView()) {
                    enhancedVitalsCard(
                        title: NSLocalizedString("Heart Rate", comment: ""),
                        icon: "waveform.path.ecg.rectangle.fill",
                        color: .blue,
                        latestReading: formatHRReading(hrEntries.first),
                        type: .heartRate,
                        entries: hrEntries
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Weight Card
                NavigationLink(destination: WeightDetailView()) {
                    enhancedVitalsCard(
                        title: NSLocalizedString("Weight", comment: ""),
                        icon: "scalemass.fill",
                        color: .green,
                        latestReading: formatWeightReading(weightEntries.first),
                        type: .weight,
                        entries: weightEntries
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Blood Sugar Card
                NavigationLink(destination: BloodSugarDetailView()) {
                    enhancedVitalsCard(
                        title: NSLocalizedString("Blood Sugar", comment: ""),
                        icon: "drop.circle.fill",
                        color: .orange,
                        latestReading: formatBSReading(bsEntries.first),
                        type: .bloodSugar,
                        entries: bsEntries
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
    }
    
    private var reportsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Generate Report Button
                Button(action: {
                    generateHealthReport()
                }) {
                    HStack {
                        Image(systemName: "doc.fill")
                        Text(NSLocalizedString("Generate Health Report", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // Previous Reports Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Previous Reports", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                    
                    if let lastReport = getLastGeneratedReport() {
                        reportRow(report: lastReport)
                    } else {
                        Text(NSLocalizedString("No previous reports available", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(NSLocalizedString("Health Summary", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            if let lastBP = bpEntries.first {
                healthMetricRow(
                    icon: "heart.fill",
                    color: .red,
                    title: "Blood Pressure",
                    value: "\(lastBP.systolic)/\(lastBP.diastolic) mmHg"
                )
            }
            
            if let lastHR = hrEntries.first {
                healthMetricRow(
                    icon: "waveform.path.ecg",
                    color: .orange,
                    title: "Heart Rate",
                    value: "\(lastHR.bpm) BPM"
                )
            }
            
            if let lastWeight = weightEntries.first {
                healthMetricRow(
                    icon: "scalemass",
                    color: .blue,
                    title: "Weight",
                    value: String(format: "%.1f kg", lastWeight.weight)
                )
            }
            
            if let lastBS = bsEntries.first {
                healthMetricRow(
                    icon: "drop.fill",
                    color: .purple,
                    title: "Blood Sugar",
                    value: String(format: "%.1f mg/dL", lastBS.glucose)
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var activityCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(NSLocalizedString("Recent Activity", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            ForEach(getRecentActivities(), id: \.id) { activity in
                HStack {
                    Image(systemName: activity.icon)
                        .foregroundColor(activity.color)
                    Text(activity.description)
                        .font(.system(size: userSettings.textSize.size))
                    Spacer()
                    Text(formatDate(activity.date))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var goalsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(NSLocalizedString("Health Goals", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            if userSettings.userHealthGoals.isEmpty {
                Text(NSLocalizedString("Set your health goals to track progress", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
            } else {
                ForEach(userSettings.userHealthGoals, id: \.self) { goal in
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text(goal)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
            
            Button(action: {
                // Action to add new health goal
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Goal")
                }
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.blue)
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Helper Views and Functions
    private func healthMetricRow(icon: String, color: Color, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .font(.system(size: userSettings.textSize.size))
            Spacer()
            Text(value)
                .font(.system(size: userSettings.textSize.size, weight: .medium))
        }
    }
    
    enum VitalType {
        case bloodPressure, heartRate, weight, bloodSugar
    }
    
    private func enhancedVitalsCard<T>(title: String, icon: String, color: Color, latestReading: String, type: VitalType, entries: FetchedResults<T>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .background(Circle().fill(color).frame(width: 56, height: 56))
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(color)
                Spacer()
                Button(action: {
                    addMeasurement(type: type)
                }) {
                    Label(NSLocalizedString("Add", comment: ""), systemImage: "plus.circle.fill")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(color)
                }
                .background(Color.white)
                .cornerRadius(20)
            }
            
            if !entries.isEmpty {
                Text(latestReading)
                    .font(.system(size: userSettings.textSize.size + 2, weight: .semibold))
                    .foregroundColor(.primary)
            } else {
                Text(NSLocalizedString("No data available", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
            }
            
            Text(NSLocalizedString("Tap to view history and charts", comment: ""))
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)
        }
        .padding()
        .background(color.opacity(0.15))
        .cornerRadius(18)
        .shadow(radius: 2)
    }
    
    private func formatBPReading(_ entry: BloodPressureEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return "\(entry.systolic)/\(entry.diastolic) mmHg"
    }
    
    private func formatHRReading(_ entry: HeartRateEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return "\(entry.bpm) BPM"
    }
    
    private func formatWeightReading(_ entry: WeightEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return String(format: "%.1f kg", entry.weight)
    }
    
    private func formatBSReading(_ entry: BloodSugarEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return String(format: "%.1f mg/dL", entry.glucose)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    struct HealthActivity: Identifiable {
        let id = UUID()
        let icon: String
        let color: Color
        let description: String
        let date: Date
    }
    
    private func getRecentActivities() -> [HealthActivity] {
        var activities: [HealthActivity] = []
        
        // Add blood pressure entries
        bpEntries.prefix(2).forEach { entry in
            activities.append(HealthActivity(
                icon: "heart.fill",
                color: .red,
                description: "Blood Pressure: \(entry.systolic)/\(entry.diastolic) mmHg",
                date: entry.date ?? Date()
            ))
        }
        
        // Add heart rate entries
        hrEntries.prefix(2).forEach { entry in
            activities.append(HealthActivity(
                icon: "waveform.path.ecg",
                color: .orange,
                description: "Heart Rate: \(entry.bpm) BPM",
                date: entry.date ?? Date()
            ))
        }
        
        // Add weight entries
        weightEntries.prefix(2).forEach { entry in
            activities.append(HealthActivity(
                icon: "scalemass",
                color: .blue,
                description: String(format: "Weight: %.1f kg", entry.weight),
                date: entry.date ?? Date()
            ))
        }
        
        // Sort by date
        return activities.sorted(by: { $0.date > $1.date })
    }
    
    private func addMeasurement(type: VitalType) {
        switch type {
        case .bloodPressure:
            showingBloodPressureInput = true
        case .heartRate:
            showingHeartRateInput = true
        case .weight:
            showingWeightInput = true
        case .bloodSugar:
            showingBloodSugarInput = true
        }
    }
    
    private func generateHealthReport() {
        // Implementation for generating health report
    }
    
    private func getLastGeneratedReport() -> Date? {
        // Implementation for getting last report date
        return nil
    }
    
    private func reportRow(report: Date) -> some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.blue)
            Text("Health Report")
                .font(.system(size: userSettings.textSize.size))
            Spacer()
            Text(formatDate(report))
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HealthView()
                .environmentObject(UserSettings())
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
} 