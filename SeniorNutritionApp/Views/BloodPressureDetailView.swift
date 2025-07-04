import SwiftUI
import CoreData
import Charts

struct BloodPressureDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var entries: FetchedResults<BloodPressureEntry>
    
    @State private var showingAddEntry = false
    @State private var selectedEntry: BloodPressureEntry?
    @State private var showingDeleteAlert = false
    @State private var timeRange: TimeRange = .week
    
    init() {
        // Create a fetch request for blood pressure entries sorted by date
        let request: NSFetchRequest<BloodPressureEntry> = BloodPressureEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BloodPressureEntry.date, ascending: false)]
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
        .navigationTitle(NSLocalizedString("Blood Pressure", comment: "Navigation title for Blood Pressure detail view"))
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
                AddBloodPressureView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .sheet(item: $selectedEntry) { entry in
            NavigationView {
                EditBloodPressureView(entry: entry)
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
                    icon: "heart.fill"
                )
                
                statsCard(
                    title: NSLocalizedString("Average", comment: "Average reading label"),
                    value: averageReading,
                    color: averageColor,
                    icon: "chart.bar.fill"
                )
            }
            
            // Blood pressure status message
            if !entries.isEmpty {
                Text(bloodPressureStatusMessage)
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
                bloodPressureChart
                    .frame(height: 250)
                    .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var bloodPressureChart: some View {
        let sortedEntries = filteredEntries.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        let startDate = sortedEntries.first?.date ?? Date().addingTimeInterval(-7*24*60*60) // 1 week ago if empty
        let endDate = sortedEntries.last?.date ?? Date() // Today if empty
        
        return Chart {
            ForEach(sortedEntries) { entry in
                // Systolic point
                PointMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Systolic", entry.systolic)
                )
                .foregroundStyle(.red)
                
                // Diastolic point
                PointMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Diastolic", entry.diastolic)
                )
                .foregroundStyle(.blue)
                
                // Systolic line
                LineMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Systolic", entry.systolic)
                )
                .foregroundStyle(Color.red.opacity(0.8))
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                // Diastolic line
                LineMark(
                    x: .value("Date", entry.date ?? Date()),
                    y: .value("Diastolic", entry.diastolic)
                )
                .foregroundStyle(Color.blue.opacity(0.8))
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            // Normal range areas
            RectangleMark(
                xStart: .value("Start", startDate),
                xEnd: .value("End", endDate),
                yStart: .value("Normal Systolic Min", 90),
                yEnd: .value("Normal Systolic Max", 120)
            )
            .foregroundStyle(.red.opacity(0.1))
            
            RectangleMark(
                xStart: .value("Start", startDate),
                xEnd: .value("End", endDate),
                yStart: .value("Normal Diastolic Min", 60),
                yEnd: .value("Normal Diastolic Max", 80)
            )
            .foregroundStyle(.blue.opacity(0.1))
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
        .chartLegend(position: .bottom, spacing: 20) {
            HStack {
                LegendItem(color: .red, label: NSLocalizedString("Systolic", comment: "Chart legend for systolic blood pressure"))
                LegendItem(color: .blue, label: NSLocalizedString("Diastolic", comment: "Chart legend for diastolic blood pressure"))
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
                Text(NSLocalizedString("No recorded blood pressure entries", comment: "Message when no blood pressure entries are recorded"))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(entries) { entry in
                    bloodPressureRow(entry: entry)
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
    
    private func bloodPressureRow(entry: BloodPressureEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(entry.systolic)/\(entry.diastolic) \(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(bloodPressureColor(systolic: Int(entry.systolic), diastolic: Int(entry.diastolic)))
                
                Text(entry.date ?? Date(), formatter: dateFormatter)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(bloodPressureCategory(systolic: Int(entry.systolic), diastolic: Int(entry.diastolic)))
                .font(.system(size: 14))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    bloodPressureColor(systolic: Int(entry.systolic), diastolic: Int(entry.diastolic))
                        .opacity(0.15)
                )
                .cornerRadius(5)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Helper method to delete an entry
    private func deleteEntry(_ entry: BloodPressureEntry) {
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
            return "\(latest.systolic)/\(latest.diastolic)"
        }
        return NSLocalizedString("N/A", comment: "Not available abbreviation")
    }
    
    private var latestColor: Color {
        if let latest = entries.first {
            return bloodPressureColor(systolic: Int(latest.systolic), diastolic: Int(latest.diastolic))
        }
        return .gray
    }
    
    private var averageReading: String {
        if entries.isEmpty {
            return NSLocalizedString("N/A", comment: "Not available abbreviation")
        }
        
        let avgSystolic = entries.reduce(0) { $0 + Double($1.systolic) } / Double(entries.count)
        let avgDiastolic = entries.reduce(0) { $0 + Double($1.diastolic) } / Double(entries.count)
        
        return "\(Int(avgSystolic))/\(Int(avgDiastolic))"
    }
    
    private var averageColor: Color {
        if entries.isEmpty {
            return .gray
        }
        
        let avgSystolic = entries.reduce(0) { $0 + Int($1.systolic) } / entries.count
        let avgDiastolic = entries.reduce(0) { $0 + Int($1.diastolic) } / entries.count
        
        return bloodPressureColor(systolic: avgSystolic, diastolic: avgDiastolic)
    }
    
    private var bloodPressureStatusMessage: String {
        if let latest = entries.first {
            let category = bloodPressureCategory(systolic: Int(latest.systolic), diastolic: Int(latest.diastolic))
            switch category {
            case NSLocalizedString("Normal", comment: "Blood pressure category: Normal"):
                return NSLocalizedString("Your blood pressure is in the normal range. Keep up the good work!", comment: "Blood pressure status: normal")
            case NSLocalizedString("Elevated", comment: "Blood pressure category: Elevated"):
                return NSLocalizedString("Your blood pressure is elevated. Consider lifestyle changes.", comment: "Blood pressure status: elevated")
            case NSLocalizedString("Stage 1", comment: "Blood pressure category: Stage 1"):
                return NSLocalizedString("Your blood pressure is in hypertension stage 1. Consult your doctor.", comment: "Blood pressure status: hypertension stage 1")
            case NSLocalizedString("Stage 2", comment: "Blood pressure category: Stage 2"):
                return NSLocalizedString("Your blood pressure is in hypertension stage 2. Seek immediate medical attention.", comment: "Blood pressure status: hypertension stage 2")
            case NSLocalizedString("Crisis", comment: "Blood pressure category: Crisis"):
                return NSLocalizedString("Your blood pressure is critically high. Seek immediate medical attention!", comment: "Blood pressure status: crisis")
            default:
                return NSLocalizedString("Track your blood pressure regularly to see insights and trends.", comment: "Blood pressure status: default message")
            }
        }
        return NSLocalizedString("Track your blood pressure regularly to see insights and trends.", comment: "Blood pressure status: default message")
    }
    
    private var filteredEntries: [BloodPressureEntry] {
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
        .sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }
    
    // MARK: - Helper Functions
    
    private func bloodPressureCategory(systolic: Int, diastolic: Int) -> String {
        if systolic >= 180 || diastolic >= 120 {
            return NSLocalizedString("Crisis", comment: "Blood pressure category: Crisis")
        } else if systolic >= 140 || diastolic >= 90 {
            return NSLocalizedString("Stage 2", comment: "Blood pressure category: Stage 2")
        } else if (systolic >= 130 && systolic < 140) || (diastolic >= 80 && diastolic < 90) {
            return NSLocalizedString("Stage 1", comment: "Blood pressure category: Stage 1")
        } else if (systolic >= 120 && systolic < 130) && diastolic < 80 {
            return NSLocalizedString("Elevated", comment: "Blood pressure category: Elevated")
        } else {
            return NSLocalizedString("Normal", comment: "Blood pressure category: Normal")
        }
    }
    
    private func bloodPressureColor(systolic: Int, diastolic: Int) -> Color {
        let category = bloodPressureCategory(systolic: systolic, diastolic: diastolic)
        
        switch category {
        case NSLocalizedString("Normal", comment: "Blood pressure category: Normal"):
            return .green
        case NSLocalizedString("Elevated", comment: "Blood pressure category: Elevated"):
            return .yellow
        case NSLocalizedString("Stage 1", comment: "Blood pressure category: Stage 1"):
            return .orange
        case NSLocalizedString("Stage 2", comment: "Blood pressure category: Stage 2"), NSLocalizedString("Crisis", comment: "Blood pressure category: Crisis"):
            return .red
        default:
            return .gray
        }
    }
}

enum TimeRange {
    case week, month, threeMonths
    
    var dateFormat: Date.FormatStyle {
        switch self {
        case .week:
            return .dateTime.weekday(.abbreviated).day()
        case .month, .threeMonths:
            return .dateTime.month(.abbreviated).day()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

struct EditBloodPressureView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let entry: BloodPressureEntry
    
    @State private var systolic = ""
    @State private var diastolic: String
    @State private var date: Date
    @State private var error: String?
    @FocusState private var systolicFieldIsFocused: Bool
    
    init(entry: BloodPressureEntry) {
        self.entry = entry
        _systolic = State(initialValue: String(entry.systolic))
        _diastolic = State(initialValue: String(entry.diastolic))
        _date = State(initialValue: entry.date ?? Date())
    }
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Blood Pressure", comment: "Section header for blood pressure"))) {
                TextField(NSLocalizedString("Systolic (top)", comment: "Placeholder for systolic blood pressure"), text: $systolic)
                    .keyboardType(.numberPad)
                    .focused($systolicFieldIsFocused)
                TextField(NSLocalizedString("Diastolic (bottom)", comment: "Placeholder for diastolic blood pressure"), text: $diastolic)
                    .keyboardType(.numberPad)
                DatePicker(NSLocalizedString("Date & Time", comment: "Date and time picker label"), selection: $date)
                    .datePickerLTR()
            }
            
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(NSLocalizedString("Edit Reading", comment: "Navigation title for editing blood pressure reading"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(NSLocalizedString("Cancel", comment: "Cancel button text")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(NSLocalizedString("Save", comment: "Save button text")) {
                    saveChanges()
                }
            }
        }
        .onAppear {
            systolicFieldIsFocused = true
        }
    }
    
    private func saveChanges() {
        guard let sys = Int32(systolic), let dia = Int32(diastolic) else {
            error = NSLocalizedString("Please enter valid numbers", comment: "Error message for invalid blood pressure numbers")
            return
        }
        
        entry.systolic = sys
        entry.diastolic = dia
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = NSLocalizedString("Failed to save: \(error.localizedDescription)", comment: "Error message for failed save operation")
        }
    }
}

#Preview {
    NavigationView {
        BloodPressureDetailView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 