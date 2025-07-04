import SwiftUI
import CoreData
import Charts

struct BloodSugarDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var entries: FetchedResults<BloodSugarEntry>
    
    @State private var showingAddEntry = false
    @State private var selectedEntry: BloodSugarEntry?
    @State private var showingDeleteAlert = false
    @State private var timeRange: TimeRange = .week
    
    init() {
        // Create a fetch request for blood sugar entries sorted by date
        let request: NSFetchRequest<BloodSugarEntry> = BloodSugarEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BloodSugarEntry.date, ascending: false)]
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
        .navigationTitle(NSLocalizedString("Blood Sugar", comment: "Navigation title for Blood Sugar detail view"))
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
                AddBloodSugarView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .sheet(item: $selectedEntry) { entry in
            NavigationView {
                EditBloodSugarView(entry: entry)
                    .environment(\.managedObjectContext, viewContext)
            }
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
                    color: latestColor,
                    icon: "drop.fill"
                )
                
                statsCard(
                    title: NSLocalizedString("Average", comment: "Average reading label"),
                    value: averageReading,
                    color: averageColor,
                    icon: "chart.bar.fill"
                )
            }
            
            // Blood sugar status message
            if !entries.isEmpty {
                Text(bloodSugarStatusMessage)
                    .font(.system(size: 16))
                    .foregroundColor(latestColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(latestColor.opacity(0.1))
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
            
            // Time range picker
            Picker(NSLocalizedString("Time Range", comment: "Time range picker label"), selection: $timeRange) {
                Text(NSLocalizedString("Week", comment: "Time range option: Week")).tag(TimeRange.week)
                Text(NSLocalizedString("Month", comment: "Time range option: Month")).tag(TimeRange.month)
                Text(NSLocalizedString("3 Months", comment: "Time range option: Three Months")).tag(TimeRange.threeMonths)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 8)
            
            if entries.isEmpty {
                Text(NSLocalizedString("No data available to display chart", comment: "Message when no chart data is available"))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                bloodSugarChart
                    .frame(height: 250)
                    .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var bloodSugarChart: some View {
        let sortedEntries = filteredEntries.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        let startDate = sortedEntries.first?.date ?? Date().addingTimeInterval(-7*24*60*60) // 1 week ago if empty
        let endDate = sortedEntries.last?.date ?? Date() // Today if empty
        
        return Chart {
            ForEach(sortedEntries) { entry in
                // Blood sugar point
                PointMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Blood Sugar", entry.glucose)
                )
                .foregroundStyle(.orange)
                
                // Blood sugar line
                LineMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Blood Sugar", entry.glucose)
                )
                .foregroundStyle(Color.purple.opacity(0.8))
                .symbolSize(50)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            // Normal range area
            RectangleMark(
                xStart: .value("Start", startDate),
                xEnd: .value("End", endDate),
                yStart: .value("Normal Min", 70),
                yEnd: .value("Normal Max", 100)
            )
            .foregroundStyle(.green.opacity(0.1))
            
            // Pre-diabetic range
            RectangleMark(
                xStart: .value("Start", startDate),
                xEnd: .value("End", endDate),
                yStart: .value("Pre-diabetic Min", 100),
                yEnd: .value("Pre-diabetic Max", 125)
            )
            .foregroundStyle(.yellow.opacity(0.1))
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
            AxisMarks(preset: .automatic) { value in
                AxisValueLabel()
                AxisGridLine()
            }
        }
        .chartLegend(position: .bottom) {
            HStack(spacing: 20) {
                LegendItem(color: .orange, label: NSLocalizedString("Blood Sugar", comment: "Chart legend for blood sugar"))
                LegendItem(color: .green, label: "Normal")
                LegendItem(color: .yellow, label: "Pre-diabetic")
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
                Text(NSLocalizedString("No recorded blood sugar entries", comment: "Message when no blood sugar entries are recorded"))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(entries) { entry in
                    bloodSugarRow(entry: entry)
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
    
    private func bloodSugarRow(entry: BloodSugarEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(entry.glucose)) mg/dL")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(bloodSugarColor(value: entry.glucose))
                
                Text(entry.date ?? Date(), formatter: dateFormatter)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(bloodSugarCategory(value: entry.glucose))
                .font(.system(size: 14))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    bloodSugarColor(value: entry.glucose)
                        .opacity(0.15)
                )
                .cornerRadius(5)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Helper method to delete an entry
    private func deleteEntry(_ entry: BloodSugarEntry) {
        viewContext.delete(entry)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
    
    // MARK: - Computed Properties
    
    private var latestReading: String {
        if let latest = entries.first {
            return "\(Int(latest.glucose))"
        }
        return "N/A"
    }
    
    private var latestColor: Color {
        if let latest = entries.first {
            return bloodSugarColor(value: latest.glucose)
        }
        return .gray
    }
    
    private var averageReading: String {
        if entries.isEmpty {
            return "N/A"
        }
        
        let avgGlucose = entries.reduce(0) { $0 + $1.glucose } / Double(entries.count)
        return "\(Int(avgGlucose))"
    }
    
    private var averageColor: Color {
        if entries.isEmpty {
            return .gray
        }
        
        let avgGlucose = entries.reduce(0) { $0 + $1.glucose } / Double(entries.count)
        return bloodSugarColor(value: avgGlucose)
    }
    
    private var bloodSugarStatusMessage: String {
        if let latest = entries.first {
            let category = bloodSugarCategory(value: latest.glucose)
            switch category {
            case "Normal":
                return NSLocalizedString("Your blood sugar is in the normal range. Keep up the good work!", comment: "Blood sugar status: normal")
            case "Pre-diabetic":
                return NSLocalizedString("Your blood sugar is in the pre-diabetic range. Consider lifestyle changes.", comment: "Blood sugar status: pre-diabetic")
            case "Diabetic":
                return NSLocalizedString("Your blood sugar is in the diabetic range. Consult your doctor for guidance.", comment: "Blood sugar status: diabetic")
            case "Low":
                return NSLocalizedString("Your blood sugar is low. Consider eating something with carbohydrates.", comment: "Blood sugar status: low")
            case "Very Low":
                return NSLocalizedString("Your blood sugar is very low. Seek medical attention if you feel unwell.", comment: "Blood sugar status: very low")
            default:
                return NSLocalizedString("Monitor your blood sugar regularly.", comment: "Blood sugar status: monitor regularly")
            }
        }
        return NSLocalizedString("Start tracking your blood sugar to see insights.", comment: "Blood sugar status: start tracking")
    }
    
    private var filteredEntries: [BloodSugarEntry] {
        let now = Date()
        let calendar = Calendar.current
        let filterDate: Date
        
        switch timeRange {
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
    
    // MARK: - Helper Functions
    
    private func bloodSugarCategory(value: Double) -> String {
        if value < 54 {
            return "Very Low"
        } else if value < 70 {
            return "Low"
        } else if value <= 100 {
            return "Normal"
        } else if value <= 125 {
            return "Pre-diabetic"
        } else {
            return "Diabetic"
        }
    }
    
    private func bloodSugarColor(value: Double) -> Color {
        let category = bloodSugarCategory(value: value)
        
        switch category {
        case "Normal":
            return .green
        case "Pre-diabetic":
            return .yellow
        case "Diabetic":
            return .red
        case "Low":
            return .orange
        case "Very Low":
            return .purple
        default:
            return .gray
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()



struct EditBloodSugarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let entry: BloodSugarEntry
    
    @State private var glucose: String
    @State private var date: Date
    @State private var error: String?
    
    init(entry: BloodSugarEntry) {
        self.entry = entry
        _glucose = State(initialValue: String(format: "%.0f", entry.glucose))
        _date = State(initialValue: entry.date ?? Date())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Blood Sugar")) {
                TextField("Blood Sugar (mg/dL)", text: $glucose)
                    .keyboardType(.decimalPad)
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
    }
    
    private func saveChanges() {
        guard let glucoseValue = Double(glucose), glucoseValue > 0 else {
            error = "Please enter a valid number"
            return
        }
        
        entry.glucose = glucoseValue
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationView {
        BloodSugarDetailView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 