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
        .navigationTitle("Heart Rate")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddEntry = true }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddHeartRateView()
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(item: $selectedEntry) { entry in
            EditHeartRateView(entry: entry)
                .environment(\.managedObjectContext, viewContext)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let entry = selectedEntry {
                    deleteEntry(entry)
                    selectedEntry = nil
                }
            }
            Button("Cancel", role: .cancel) {
                selectedEntry = nil
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                statsCard(
                    title: "Latest",
                    value: latestReading,
                    color: latestColor,
                    icon: "waveform.path.ecg"
                )
                
                statsCard(
                    title: "Average",
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
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trends")
                .font(.title2)
                .bold()
            
            // Time range picker
            Picker("Time Range", selection: $timeRange) {
                Text("Week").tag(TimeRange.week)
                Text("Month").tag(TimeRange.month)
                Text("3 Months").tag(TimeRange.threeMonths)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 8)
            
            if entries.isEmpty {
                Text("No data available to display chart")
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
        .background(Color.white)
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
                .foregroundStyle(.blue)
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
                LegendItem(color: .blue, label: "Heart Rate (BPM)")
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
            Text("History")
                .font(.title2)
                .bold()
            
            if entries.isEmpty {
                Text("No recorded heart rate entries")
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
        .background(Color.white)
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
        .background(Color(.systemGray6))
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
                return "Your heart rate is in the normal range. Keep up the good work!"
            case "High":
                return "Your heart rate is elevated. If this persists, consider consulting your doctor."
            case "Low":
                return "Your heart rate is lower than normal. If you feel unwell, consult your doctor."
            case "Very High":
                return "Your heart rate is very high. Consider medical attention if accompanied by other symptoms."
            default:
                return "Monitor your heart rate regularly."
            }
        }
        return "Start tracking your heart rate to see insights."
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

struct AddHeartRateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var bpm = ""
    @FocusState private var bpmFieldIsFocused: Bool
    @State private var date = Date()
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Heart Rate")) {
                    TextField("BPM (Beats Per Minute)", text: $bpm)
                        .keyboardType(.numberPad)
                        .focused($bpmFieldIsFocused)
                    DatePicker("Date & Time", selection: $date)
                }
                
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add Heart Rate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.bpmFieldIsFocused = true
                }
            }
        }
    }
    
    private func saveEntry() {
        guard let bpmValue = Int32(bpm), bpmValue > 0 else {
            error = "Please enter a valid number"
            return
        }
        
        let entry = HeartRateEntry(context: viewContext)
        entry.id = UUID()
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
        NavigationView {
            Form {
                Section(header: Text("Heart Rate")) {
                    TextField("BPM (Beats Per Minute)", text: $bpm)
                        .keyboardType(.numberPad)
                    DatePicker("Date & Time", selection: $date)
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