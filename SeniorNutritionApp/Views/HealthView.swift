import SwiftUI
import CoreData

struct HealthView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    @State private var refreshID = UUID()
    @State private var activities: [HealthActivity] = []
    
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
            HStack {
                segmentButton(title: NSLocalizedString("Overview", comment: "Segmented control tab for health overview"), tag: 0)
                segmentButton(title: NSLocalizedString("Vitals", comment: "Segmented control tab for vital signs"), tag: 1)
                segmentButton(title: NSLocalizedString("Reports", comment: "Segmented control tab for health reports"), tag: 2)
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
        .id(refreshID)
        .navigationTitle(NSLocalizedString("Health", comment: "Navigation title for Health view"))
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
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageDidChange"))) { _ in
            self.refreshID = UUID()
            self.activities = getRecentActivities()
        }
        .onAppear {
            self.activities = getRecentActivities()
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
            VStack(spacing: 20) {
                // Blood Pressure Card
                vitalsCard(
                    title: NSLocalizedString("Blood Pressure", comment: "Title for Blood Pressure vital card"),
                    icon: "heart.fill",
                    color: .red,
                    latestReading: formatBPReading(bpEntries.first),
                    type: .bloodPressure
                )
                
                // Heart Rate Card
                vitalsCard(
                    title: NSLocalizedString("Heart Rate", comment: "Title for Heart Rate vital card"),
                    icon: "waveform.path.ecg",
                    color: .orange,
                    latestReading: formatHRReading(hrEntries.first),
                    type: .heartRate
                )
                
                // Weight Card
                vitalsCard(
                    title: NSLocalizedString("Weight", comment: "Title for Weight vital card"),
                    icon: "scalemass",
                    color: .blue,
                    latestReading: formatWeightReading(weightEntries.first),
                    type: .weight
                )
                
                // Blood Sugar Card
                vitalsCard(
                    title: NSLocalizedString("Blood Sugar", comment: "Title for Blood Sugar vital card"),
                    icon: "drop.fill",
                    color: .purple,
                    latestReading: formatBSReading(bsEntries.first),
                    type: .bloodSugar
                )
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
                        Text(NSLocalizedString("Generate Health Report", comment: "Button to generate health report"))
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
                    Text(NSLocalizedString("Previous Reports", comment: "Section title for previous health reports"))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                    
                    if let lastReport = getLastGeneratedReport() {
                        reportRow(report: lastReport)
                    } else {
                        Text(NSLocalizedString("No previous reports available", comment: "Message when no previous reports are found"))
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
            Text(NSLocalizedString("Health Summary", comment: "Title for health summary card"))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            if let lastBP = bpEntries.first {
                healthMetricRow(
                    icon: "heart.fill",
                    color: .red,
                    title: NSLocalizedString("Blood Pressure", comment: "Label for blood pressure"),
                    value: "\(lastBP.systolic)/\(lastBP.diastolic) \(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))"
                )
            }
            
            if let lastHR = hrEntries.first {
                healthMetricRow(
                    icon: "waveform.path.ecg",
                    color: .orange,
                    title: NSLocalizedString("Heart Rate", comment: "Label for heart rate"),
                    value: "\(lastHR.bpm) \(NSLocalizedString("BPM", comment: "Unit for beats per minute"))"
                )
            }
            
            if let lastWeight = weightEntries.first {
                healthMetricRow(
                    icon: "scalemass",
                    color: .blue,
                    title: NSLocalizedString("Weight", comment: "Label for weight"),
                    value: String(format: "%.1f %@", lastWeight.weight, NSLocalizedString("kg", comment: "Unit for kilogram"))
                )
            }
            
            if let lastBS = bsEntries.first {
                healthMetricRow(
                    icon: "drop.fill",
                    color: .purple,
                    title: NSLocalizedString("Blood Sugar", comment: "Label for blood sugar"),
                    value: String(format: "%.1f %@", lastBS.glucose, NSLocalizedString("mg/dL", comment: "Unit for milligrams per deciliter"))
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
            Text(NSLocalizedString("Recent Activity", comment: "Title for recent activity section"))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            ForEach(activities) { activity in
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
                    Text(NSLocalizedString("Add New Goal", comment: "Button to add a new health goal"))
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
    
    private func vitalsCard(title: String, icon: String, color: Color, latestReading: String, type: VitalType) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
            }
            
            Text(latestReading)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.primary)
            
            Button(action: {
                addMeasurement(type: type)
            }) {
                Text(NSLocalizedString("Add Measurement", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func formatBPReading(_ entry: BloodPressureEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return "\(entry.systolic)/\(entry.diastolic) \(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))"
    }
    
    private func formatHRReading(_ entry: HeartRateEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return "\(entry.bpm) \(NSLocalizedString("BPM", comment: "Unit for beats per minute"))"
    }
    
    private func formatWeightReading(_ entry: WeightEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return String(format: "%.1f %@", entry.weight, NSLocalizedString("kg", comment: "Unit for kilogram"))
    }
    
    private func formatBSReading(_ entry: BloodSugarEntry?) -> String {
        guard let entry = entry else { return NSLocalizedString("No data available", comment: "") }
        return String(format: "%.1f %@", entry.glucose, NSLocalizedString("mg/dL", comment: "Unit for milligrams per deciliter"))
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
                description: "\(NSLocalizedString("Blood Pressure", comment: "Label for blood pressure")): \(entry.systolic)/\(entry.diastolic) \(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))",
                date: entry.date ?? Date()
            ))
        }
        
        // Add heart rate entries
        hrEntries.prefix(2).forEach { entry in
            activities.append(HealthActivity(
                icon: "waveform.path.ecg",
                color: .orange,
                description: "\(NSLocalizedString("Heart Rate", comment: "Label for heart rate")): \(entry.bpm) \(NSLocalizedString("BPM", comment: "Unit for beats per minute"))",
                date: entry.date ?? Date()
            ))
        }
        
        // Add weight entries
        weightEntries.prefix(2).forEach { entry in
            activities.append(HealthActivity(
                icon: "scalemass",
                color: .blue,
                description: String(format: "\(NSLocalizedString("Weight", comment: "Label for weight")): %.1f %@", entry.weight, NSLocalizedString("kg", comment: "Unit for kilogram")),
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
            Text(NSLocalizedString("Health Report", comment: "Title for health report"))
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