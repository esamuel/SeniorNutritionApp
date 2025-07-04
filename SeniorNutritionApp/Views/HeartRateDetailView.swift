import SwiftUI
import CoreData
import Charts

struct HeartRateDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var entries: FetchedResults<HeartRateEntry>
    
    @State private var showingAddEntry = false
    @State private var selectedEntry: HeartRateEntry?
    @State private var showingDeleteAlert = false
    @State private var timeRange: TimeRange = .week
    
    init() {
        // Create a fetch request for heart rate entries sorted by date
        let request: NSFetchRequest<HeartRateEntry> = HeartRateEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HeartRateEntry.date, ascending: false)]
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
        .navigationTitle(NSLocalizedString("Heart Rate", comment: "Navigation title for Heart Rate detail view"))
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
                AddHeartRateView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .sheet(item: $selectedEntry) { entry in
            NavigationView {
                EditHeartRateView(entry: entry)
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
                    icon: "waveform.path.ecg"
                )
                
                statsCard(
                    title: NSLocalizedString("Average", comment: "Average reading label"),
                    value: averageReading,
                    color: averageColor,
                    icon: "chart.bar.fill"
                )
            }
            
            // Heart rate status message
            if !entries.isEmpty {
                Text(heartRateStatusMessage)
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
                heartRateChart
                    .frame(height: 250)
                    .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var heartRateChart: some View {
        let sortedEntries = filteredEntries.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        let startDate = sortedEntries.first?.date ?? Date().addingTimeInterval(-7*24*60*60) // 1 week ago if empty
        let endDate = sortedEntries.last?.date ?? Date() // Today if empty
        
        return Chart {
            ForEach(sortedEntries) { entry in
                // Heart rate point
                PointMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Heart Rate", entry.bpm)
                )
                .foregroundStyle(.blue)
                
                // Heart rate line
                LineMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Heart Rate", entry.bpm)
                )
                .foregroundStyle(Color.blue.opacity(0.8))
                .symbolSize(50)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            // Normal range area for adults over 60
            RectangleMark(
                xStart: .value("Start", startDate),
                xEnd: .value("End", endDate),
                yStart: .value("Normal Min", 60),
                yEnd: .value("Normal Max", 100)
            )
            .foregroundStyle(.green.opacity(0.1))
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
                LegendItem(color: .blue, label: NSLocalizedString("Heart Rate (BPM)", comment: "Chart legend for heart rate"))
                LegendItem(color: .green, label: "Normal Range")
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
                Text(NSLocalizedString("No recorded heart rate entries", comment: "Message when no heart rate entries are recorded"))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(entries) { entry in
                    heartRateRow(entry: entry)
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
    
    private func heartRateRow(entry: HeartRateEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(entry.bpm) BPM")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(heartRateColor(value: Int(entry.bpm)))
                
                Text(entry.date ?? Date(), formatter: dateFormatter)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(heartRateCategory(value: Int(entry.bpm)))
                .font(.system(size: 14))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    heartRateColor(value: Int(entry.bpm))
                        .opacity(0.15)
                )
                .cornerRadius(5)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Helper method to delete an entry
    private func deleteEntry(_ entry: HeartRateEntry) {
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
            return "\(latest.bpm)"
        }
        return "N/A"
    }
    
    private var latestColor: Color {
        if let latest = entries.first {
            return heartRateColor(value: Int(latest.bpm))
        }
        return .gray
    }
    
    private var averageReading: String {
        if entries.isEmpty {
            return "N/A"
        }
        
        let avgBPM = entries.reduce(0) { $0 + Double($1.bpm) } / Double(entries.count)
        return "\(Int(avgBPM))"
    }
    
    private var averageColor: Color {
        if entries.isEmpty {
            return .gray
        }
        
        let avgBPM = entries.reduce(0) { $0 + Int($1.bpm) } / entries.count
        return heartRateColor(value: avgBPM)
    }
    
    private var heartRateStatusMessage: String {
        if let latest = entries.first {
            let category = heartRateCategory(value: Int(latest.bpm))
            switch category {
            case "Normal":
                return NSLocalizedString("Your heart rate is in the normal range. Keep up the good work!", comment: "Heart rate status: normal")
            case "High":
                return NSLocalizedString("Your heart rate is elevated. If this persists, consider consulting your doctor.", comment: "Heart rate status: high")
            case "Low":
                return NSLocalizedString("Your heart rate is lower than normal. Consult your doctor.", comment: "Heart rate status: low")
            case "Very High":
                return NSLocalizedString("Your heart rate is very high. Consider medical attention if accompanied by other symptoms.", comment: "Heart rate status: very high")
            default:
                return NSLocalizedString("Track your heart rate regularly to see insights and trends.", comment: "Heart rate status: default message")
            }
        }
        return NSLocalizedString("Start tracking your heart rate to see insights.", comment: "Heart rate status: start tracking")
    }
    
    private var filteredEntries: [HeartRateEntry] {
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
    
    private func heartRateCategory(value: Int) -> String {
        if value < 60 {
            return "Low"
        } else if value <= 100 {
            return "Normal"
        } else if value <= 130 {
            return "High"
        } else {
            return "Very High"
        }
    }
    
    private func heartRateColor(value: Int) -> Color {
        let category = heartRateCategory(value: value)
        
        switch category {
        case "Normal":
            return .green
        case "High":
            return .orange
        case "Low":
            return .blue
        case "Very High":
            return .red
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

// AddHeartRateView has been moved to its own file

struct EditHeartRateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let entry: HeartRateEntry
    
    @State private var bpm: String
    @State private var date: Date
    @State private var error: String?
    
    init(entry: HeartRateEntry) {
        self.entry = entry
        _bpm = State(initialValue: String(entry.bpm))
        _date = State(initialValue: entry.date ?? Date())
    }
    
    var body: some View {
        Form {
            Section(header: Text("Heart Rate")) {
                TextField("Heart Rate (BPM)", text: $bpm)
                    .keyboardType(.numberPad)
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
        guard let bpmValue = Int32(bpm), bpmValue > 0 else {
            error = "Please enter a valid number"
            return
        }
        
        entry.bpm = bpmValue
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
        HeartRateDetailView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 