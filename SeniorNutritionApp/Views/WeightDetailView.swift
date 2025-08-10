import SwiftUI
import CoreData
import Charts

struct WeightDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var premiumManager: PremiumManager
    @FetchRequest private var entries: FetchedResults<WeightEntry>
    
    @State private var showingAddEntry = false
    @State private var selectedEntry: WeightEntry?
    @State private var showingDeleteAlert = false
    @State private var showingPremiumAlert = false
    @State private var timeRange: TimeRange = .week
    @State private var showingPremiumUpgrade = false
    
    init() {
        // Create a fetch request for weight entries sorted by date
        let request: NSFetchRequest<WeightEntry> = WeightEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)]
        _entries = FetchRequest(fetchRequest: request, animation: .default)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with stats
                headerView
                
                // Chart section
                chartSection
                
                // History section
                historySection
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Weight", comment: "Navigation title for Weight detail view"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddEntry = true }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            NavigationView {
                AddWeightView()
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(userSettings)
            }
        }
        .sheet(item: $selectedEntry) { entry in
            NavigationView {
                EditWeightView(entry: entry)
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(userSettings)
            }
        }
        .sheet(isPresented: $showingPremiumUpgrade) {
            PremiumFeaturesView()
                .environmentObject(premiumManager)
        }
        .alert(NSLocalizedString("Premium Feature", comment: ""), isPresented: $showingPremiumAlert) {
            Button(NSLocalizedString("Cancel", comment: ""), role: .cancel) { }
            Button(NSLocalizedString("Upgrade", comment: "")) {
                showingPremiumUpgrade = true
            }
        } message: {
            Text(NSLocalizedString("Extended analytics history is available with Premium subscription. Free users can view up to 7 days of data.", comment: ""))
        }
        .alert(NSLocalizedString("Delete Entry", comment: "Alert title for deleting entry"), isPresented: $showingDeleteAlert) {
            Button(NSLocalizedString("Delete", comment: "Delete button text"), role: .destructive) {
                if let entry = selectedEntry {
                    deleteEntry(entry)
                    selectedEntry = nil
                }
            }
            Button(NSLocalizedString("Cancel", comment: "Cancel button text"), role: .cancel) {
                selectedEntry = nil
            }
        } message: {
            Text(NSLocalizedString("Are you sure you want to delete this entry? This action cannot be undone.", comment: "Delete confirmation message"))
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                statsCard(
                    title: NSLocalizedString("Latest", comment: "Latest reading label"),
                    value: latestReading,
                    color: .green,
                    icon: "scalemass.fill"
                )
                
                statsCard(
                    title: NSLocalizedString("Trend", comment: "Trend label"),
                    value: weightTrend,
                    color: trendColor,
                    icon: "arrow.up.right"
                )
            }
            
            // Weight insights message
            if entries.count > 1 {
                Text(weightInsightsMessage)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
            }
        }
    }
    
    private func statsCard(title: String, value: String, color: Color, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("Trends", comment: "Trends section title"))
                .font(.title2)
                .bold()
            
            // Time range picker with premium limitations
            VStack(alignment: .leading, spacing: 8) {
                Picker("Time Range", selection: $timeRange) {
                    Text(NSLocalizedString("Week", comment: "Time range option: Week")).tag(TimeRange.week)
                    
                    HStack {
                        Text(NSLocalizedString("Month", comment: "Time range option: Month"))
                        if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                    }
                    .tag(TimeRange.month)
                    .disabled(!premiumManager.hasAccess(to: PremiumFeature.extendedHistory))
                    
                    HStack {
                        Text(NSLocalizedString("3 Months", comment: "Time range option: Three Months"))
                        if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                    }
                    .tag(TimeRange.threeMonths)
                    .disabled(!premiumManager.hasAccess(to: PremiumFeature.extendedHistory))
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: timeRange) { oldValue, newValue in
                    if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) && newValue != .week {
                        timeRange = .week
                        showingPremiumAlert = true
                    }
                }
                
                // Premium limitation notice for Free users
                if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        Text(NSLocalizedString("Free users can view up to 7 days of analytics. Upgrade for extended history.", comment: ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(NSLocalizedString("Upgrade", comment: "")) {
                            showingPremiumUpgrade = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 8)
            
            if entries.isEmpty {
                Text(NSLocalizedString("No data available to display chart", comment: "Message when no chart data is available"))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            } else {
                weightChart
                    .frame(height: 250)
                    .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var weightChart: some View {
        let sortedEntries = filteredEntries.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        
        // Calculate min and max weights for Y-axis range
        let weights = sortedEntries.map { $0.weight }
        let minWeight = (weights.min() ?? 0) - 1 // Add 1kg padding below
        let maxWeight = (weights.max() ?? 100) + 1 // Add 1kg padding above
        let weightRange = maxWeight - minWeight
        
        return Chart(sortedEntries) { entry in
            LineMark(
                x: .value("Date", entry.date ?? Date()),
                y: .value("Weight", entry.weight)
            )
            .foregroundStyle(Color.green.opacity(0.8))
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            PointMark(
                x: .value("Date", entry.date ?? Date()),
                y: .value("Weight", entry.weight)
            )
            .foregroundStyle(Color.green.opacity(0.8))
            .symbolSize(50)
        }
        .chartXAxis {
            AxisMarks(preset: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: self.timeRange.dateFormat)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(values: .stride(by: max(0.5, weightRange / 10))) { value in // More frequent marks
                AxisValueLabel {
                    if let weight = value.as(Double.self) {
                        Text(String(format: "%.1f", weight))
                            .foregroundColor(.primary)
                    }
                }
                AxisGridLine()
            }
        }
        .chartYScale(domain: minWeight...maxWeight) // Custom Y-axis range
        .chartLegend(position: .bottom) {
            HStack(spacing: 20) {
                LegendItem(color: .green, label: NSLocalizedString("Weight (kg/lbs)", comment: "Chart legend for weight"))
            }
        }
    }
    
    private struct LegendItem: View {
        var color: Color
        var label: String
        
        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("History", comment: "History section title"))
                .font(.title2)
                .bold()
            
            if entries.isEmpty {
                Text(NSLocalizedString("Tap to view history and charts", comment: "Instruction to view history"))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(entries) { entry in
                    weightRow(entry: entry)
                        .contextMenu {
                            Button {
                                selectedEntry = entry
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                selectedEntry = entry
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            selectedEntry = entry
                        }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func weightRow(entry: WeightEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%.1f kg", entry.weight))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(entry.date ?? Date(), formatter: dateFormatter)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let previousEntry = getPreviousEntry(for: entry) {
                let diff = entry.weight - previousEntry.weight
                let isGain = diff > 0
                
                Text(String(format: "%@%.1f", isGain ? "+" : "", diff))
                    .font(.system(size: 14))
                    .foregroundColor(isGain ? .red : .green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        (isGain ? Color.red : Color.green)
                            .opacity(0.15)
                    )
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Helper method to delete an entry
    private func deleteEntry(_ entry: WeightEntry) {
        viewContext.delete(entry)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
    
    // Get the previous entry for comparison
    private func getPreviousEntry(for entry: WeightEntry) -> WeightEntry? {
        let sortedEntries = entries.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        if let index = sortedEntries.firstIndex(where: { $0.id == entry.id }),
           index + 1 < sortedEntries.count {
            return sortedEntries[index + 1]
        }
        return nil
    }
    
    // MARK: - Computed Properties
    
    private var latestReading: String {
        if let latest = entries.first {
            return String(format: "%.1f kg", latest.weight)
        }
        return "N/A"
    }
    
    private var weightTrend: String {
        if entries.count > 1 {
            let sortedEntries = entries.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            if sortedEntries.count >= 2 {
                let latest = sortedEntries[0].weight
                let previous = sortedEntries[1].weight
                let diff = latest - previous
                return String(format: "%@%.1f kg", diff >= 0 ? "+" : "", diff)
            }
        }
        return "No change"
    }
    
    private var trendColor: Color {
        if entries.count > 1 {
            let sortedEntries = entries.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            if sortedEntries.count >= 2 {
                let latest = sortedEntries[0].weight
                let previous = sortedEntries[1].weight
                let diff = latest - previous
                return diff > 0 ? .red : (diff < 0 ? .green : .gray)
            }
        }
        return .gray
    }
    
    private var weightInsightsMessage: String {
        let sortedEntries = entries.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        if sortedEntries.count >= 2 {
            let latest = sortedEntries[0].weight
            let previous = sortedEntries[1].weight
            let diff = latest - previous
            
            if abs(diff) < 0.5 {
                return NSLocalizedString("Your weight has been stable recently. Good job maintaining consistency!", comment: "Weight insights message")
            } else if diff > 0 {
                return String(format: NSLocalizedString("You've gained %.1f kg recently. Monitor your intake if this wasn't intended.", comment: "Weight insights message"), diff)
            } else {
                return String(format: NSLocalizedString("You've lost %.1f kg recently. If intentional, good progress!", comment: "Weight insights message"), abs(diff))
            }
        }
        return NSLocalizedString("Track your weight regularly to see insights and trends.", comment: "Weight insights message")
    }
    
    private var filteredEntries: [WeightEntry] {
        let now = Date()
        let calendar = Calendar.current
        let filterDate: Date
        
        // Apply premium limitations
        let effectiveTimeRange = premiumManager.hasAccess(to: PremiumFeature.extendedHistory) ? timeRange : .week
        
        switch effectiveTimeRange {
        case .week:
            filterDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            filterDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .threeMonths:
            filterDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        }
        
        return entries.filter { entry in
            guard let date = entry.date else { return false }
            return date >= filterDate
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

// AddWeightView has been moved to its own file

struct EditWeightView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    let entry: WeightEntry
    
    @State private var weight: String
    @State private var date: Date
    @State private var error: String?
    @FocusState private var weightFieldIsFocused: Bool
    
    init(entry: WeightEntry) {
        self.entry = entry
        _weight = State(initialValue: String(format: "%.1f", entry.weight))
        _date = State(initialValue: entry.date ?? Date())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Weight")) {
                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
                    .focused($weightFieldIsFocused)
                DatePicker("Date & Time", selection: $date)
                    .datePickerLTR()
            }
            
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Edit Reading")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
                }
            }
        }
        .onAppear {
            weightFieldIsFocused = true
        }
    }
    
    private func saveChanges() {
        guard let weightValue = Double(weight), weightValue > 0 else {
            error = "Please enter a valid number"
            return
        }
        
        entry.weight = weightValue
        entry.date = date
        
        do {
            try viewContext.save()
            
            // Update user profile with the latest weight if this is the most recent entry
            let request = WeightEntry.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)]
            request.fetchLimit = 1
            
            if let latestEntry = try viewContext.fetch(request).first,
               latestEntry.id == entry.id,
               var profile = userSettings.userProfile {
                profile.weight = weightValue
                userSettings.updateProfile(profile)
            }
            
            dismiss()
        } catch {
            self.error = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationView {
        WeightDetailView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 