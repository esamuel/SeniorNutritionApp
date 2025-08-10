import SwiftUI
import CoreData

struct DataExportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var premiumManager = PremiumManager.shared
    
    @State private var selectedFormat: ExportFormat = .pdf
    @State private var selectedDateRange: ExportDateRange = .lastMonth
    @State private var isExporting = false
    @State private var exportError: String?
    @State private var exportedFileURL: URL?
    @State private var showingShareSheet = false
    @State private var showingUpgradeSheet = false
    
    private var exportService: HealthDataExportService {
        HealthDataExportService(viewContext: viewContext)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Premium Feature Header
                if !premiumManager.hasFullAccess {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.purple)
                                .font(.title2)
                            
                            Text("Premium Feature")
                                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                .foregroundColor(.purple)
                        }
                        
                        Text("Data export is available for premium subscribers")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showingUpgradeSheet = true
                        }) {
                            Text("Upgrade to Premium")
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                }
                
                if premiumManager.hasFullAccess {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Export Format Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Export Format")
                                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                
                                ForEach(ExportFormat.allCases) { format in
                                    ExportFormatCard(
                                        format: format,
                                        isSelected: selectedFormat == format,
                                        onSelect: { selectedFormat = format }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            
                            // Date Range Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Date Range")
                                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 12) {
                                    ForEach(ExportDateRange.allCases) { range in
                                        DateRangeCard(
                                            range: range,
                                            isSelected: selectedDateRange == range,
                                            onSelect: { selectedDateRange = range }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Data Preview
                            DataPreviewSection()
                                .padding(.horizontal)
                            
                            // Export Button
                            Button(action: performExport) {
                                HStack {
                                    if isExporting {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    
                                    Text(isExporting ? "Exporting..." : "Export Data")
                                }
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isExporting ? Color.gray : Color.blue)
                                .cornerRadius(12)
                            }
                            .disabled(isExporting)
                            .padding(.horizontal)
                            
                            // Medical Disclaimer
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                    Text("Medical Disclaimer")
                                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                                        .foregroundColor(.orange)
                                }
                                
                                Text("This exported data is for personal records and healthcare provider consultation only. It should not be used for self-diagnosis or treatment decisions.")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Export Health Data")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .alert("Export Error", isPresented: .constant(exportError != nil)) {
                Button("OK") {
                    exportError = nil
                }
            } message: {
                Text(exportError ?? "")
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = exportedFileURL {
                    ShareSheet(activityItems: [url])
                }
            }
            .sheet(isPresented: $showingUpgradeSheet) {
                PremiumFeaturesView()
            }
        }
    }
    
    private func performExport() {
        guard premiumManager.hasFullAccess else {
            showingUpgradeSheet = true
            return
        }
        
        isExporting = true
        exportError = nil
        
        Task {
            do {
                let fileURL: URL
                
                switch selectedFormat {
                case .csv:
                    fileURL = try exportService.exportToCSV()
                case .pdf:
                    fileURL = try exportService.exportToPDF(userProfile: userSettings.userProfile)
                }
                
                await MainActor.run {
                    exportedFileURL = fileURL
                    showingShareSheet = true
                    isExporting = false
                }
                
            } catch {
                await MainActor.run {
                    exportError = "Failed to export data: \(error.localizedDescription)"
                    isExporting = false
                }
            }
        }
    }
}

struct ExportFormatCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let format: ExportFormat
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(format.displayName)
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(format.description)
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct DateRangeCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let range: ExportDateRange
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Text(range.displayName)
                .font(.system(size: userSettings.textSize.size - 1, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

struct DataPreviewSection: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var weightCount = 0
    @State private var bpCount = 0
    @State private var hrCount = 0
    @State private var bsCount = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data Summary")
                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            
            VStack(spacing: 8) {
                DataCountRow(icon: "scalemass", title: "Weight Entries", count: weightCount, color: .blue)
                DataCountRow(icon: "heart.fill", title: "Blood Pressure", count: bpCount, color: .red)
                DataCountRow(icon: "waveform.path.ecg", title: "Heart Rate", count: hrCount, color: .pink)
                DataCountRow(icon: "drop.fill", title: "Blood Sugar", count: bsCount, color: .orange)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .onAppear {
            updateDataCounts()
        }
    }
    
    private func updateDataCounts() {
        // Count Weight Entries
        let weightRequest: NSFetchRequest<WeightEntry> = WeightEntry.fetchRequest()
        weightCount = (try? viewContext.count(for: weightRequest)) ?? 0
        
        // Count Blood Pressure Entries
        let bpRequest: NSFetchRequest<BloodPressureEntry> = BloodPressureEntry.fetchRequest()
        bpCount = (try? viewContext.count(for: bpRequest)) ?? 0
        
        // Count Heart Rate Entries
        let hrRequest: NSFetchRequest<HeartRateEntry> = HeartRateEntry.fetchRequest()
        hrCount = (try? viewContext.count(for: hrRequest)) ?? 0
        
        // Count Blood Sugar Entries
        let bsRequest: NSFetchRequest<BloodSugarEntry> = BloodSugarEntry.fetchRequest()
        bsCount = (try? viewContext.count(for: bsRequest)) ?? 0
    }
}

struct DataCountRow: View {
    @EnvironmentObject private var userSettings: UserSettings
    let icon: String
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    DataExportView()
        .environmentObject(UserSettings())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}