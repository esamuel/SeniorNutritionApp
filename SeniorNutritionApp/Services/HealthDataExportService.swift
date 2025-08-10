import Foundation
import CoreData
import PDFKit
import SwiftUI

class HealthDataExportService: ObservableObject {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - CSV Export
    
    func exportToCSV() throws -> URL {
        let csvContent = try generateCSVContent()
        let fileName = "HealthData_\(dateFormatter.string(from: Date())).csv"
        return try saveToFile(content: csvContent, fileName: fileName, fileExtension: "csv")
    }
    
    private func generateCSVContent() throws -> String {
        var csvContent = ""
        
        // Add header
        csvContent += "Data Type,Date,Value,Unit,Notes\n"
        
        // Export Weight Data
        let weightEntries = try fetchWeightEntries()
        for entry in weightEntries {
            csvContent += "Weight,\(dateFormatter.string(from: entry.date ?? Date())),\(entry.weight),kg,\n"
        }
        
        // Export Blood Pressure Data
        let bpEntries = try fetchBloodPressureEntries()
        for entry in bpEntries {
            csvContent += "Blood Pressure,\(dateFormatter.string(from: entry.date ?? Date())),\(entry.systolic)/\(entry.diastolic),mmHg,\n"
        }
        
        // Export Heart Rate Data
        let hrEntries = try fetchHeartRateEntries()
        for entry in hrEntries {
            csvContent += "Heart Rate,\(dateFormatter.string(from: entry.date ?? Date())),\(entry.bpm),bpm,\n"
        }
        
        // Export Blood Sugar Data
        let bsEntries = try fetchBloodSugarEntries()
        for entry in bsEntries {
            csvContent += "Blood Sugar,\(dateFormatter.string(from: entry.date ?? Date())),\(entry.glucose),mg/dL,\n"
        }
        
        return csvContent
    }
    
    // MARK: - PDF Export
    
    func exportToPDF(userProfile: UserProfile?) throws -> URL {
        let pdfData = try generatePDFData(userProfile: userProfile)
        let fileName = "HealthReport_\(dateFormatter.string(from: Date())).pdf"
        return try saveToFile(data: pdfData, fileName: fileName, fileExtension: "pdf")
    }
    
    private func generatePDFData(userProfile: UserProfile?) throws -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Senior Nutrition App",
            kCGPDFContextAuthor: userProfile?.fullName ?? "User",
            kCGPDFContextTitle: "Health Data Report"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            try? drawPDFContent(context: context, pageRect: pageRect, userProfile: userProfile)
        }
        
        return data
    }
    
    private func drawPDFContent(context: UIGraphicsPDFRendererContext, pageRect: CGRect, userProfile: UserProfile?) throws {
        context.beginPage()
        
        var yPosition: CGFloat = 50
        let leftMargin: CGFloat = 50
        let rightMargin: CGFloat = pageRect.width - 50
        
        // Title
        yPosition = drawText("Health Data Report", 
                           fontSize: 24, 
                           isBold: true, 
                           yPosition: yPosition, 
                           leftMargin: leftMargin,
                           rightMargin: rightMargin)
        
        yPosition += 20
        
        // User Information
        if let profile = userProfile {
            yPosition = drawText("Patient Information", 
                               fontSize: 18, 
                               isBold: true, 
                               yPosition: yPosition, 
                               leftMargin: leftMargin,
                               rightMargin: rightMargin)
            
            yPosition = drawText("Name: \(profile.fullName)", 
                               fontSize: 12, 
                               isBold: false, 
                               yPosition: yPosition + 10, 
                               leftMargin: leftMargin,
                               rightMargin: rightMargin)
            
            yPosition = drawText("Age: \(profile.age) years", 
                               fontSize: 12, 
                               isBold: false, 
                               yPosition: yPosition + 5, 
                               leftMargin: leftMargin,
                               rightMargin: rightMargin)
            
            yPosition = drawText("Gender: \(profile.gender)", 
                               fontSize: 12, 
                               isBold: false, 
                               yPosition: yPosition + 5, 
                               leftMargin: leftMargin,
                               rightMargin: rightMargin)
            
            if let bmi = profile.calculateBMI() {
                yPosition = drawText("BMI: \(String(format: "%.1f", bmi))", 
                                   fontSize: 12, 
                                   isBold: false, 
                                   yPosition: yPosition + 5, 
                                   leftMargin: leftMargin,
                                   rightMargin: rightMargin)
            }
            
            yPosition += 20
        }
        
        // Weight Data Section
        yPosition = try drawHealthDataSection(title: "Weight Measurements", 
                                            data: try fetchWeightEntries(), 
                                            yPosition: yPosition,
                                            leftMargin: leftMargin,
                                            rightMargin: rightMargin,
                                            pageRect: pageRect,
                                            context: context)
        
        // Blood Pressure Data Section
        yPosition = try drawHealthDataSection(title: "Blood Pressure Readings", 
                                            data: try fetchBloodPressureEntries(), 
                                            yPosition: yPosition,
                                            leftMargin: leftMargin,
                                            rightMargin: rightMargin,
                                            pageRect: pageRect,
                                            context: context)
        
        // Heart Rate Data Section
        yPosition = try drawHealthDataSection(title: "Heart Rate Measurements", 
                                            data: try fetchHeartRateEntries(), 
                                            yPosition: yPosition,
                                            leftMargin: leftMargin,
                                            rightMargin: rightMargin,
                                            pageRect: pageRect,
                                            context: context)
        
        // Blood Sugar Data Section
        yPosition = try drawHealthDataSection(title: "Blood Sugar Readings", 
                                            data: try fetchBloodSugarEntries(), 
                                            yPosition: yPosition,
                                            leftMargin: leftMargin,
                                            rightMargin: rightMargin,
                                            pageRect: pageRect,
                                            context: context)
        
        // Medical Disclaimer
        yPosition = drawMedicalDisclaimer(yPosition: yPosition + 30, 
                                        leftMargin: leftMargin,
                                        rightMargin: rightMargin,
                                        pageRect: pageRect,
                                        context: context)
    }
    
    private func drawHealthDataSection<T>(title: String, 
                                        data: [T], 
                                        yPosition: CGFloat,
                                        leftMargin: CGFloat,
                                        rightMargin: CGFloat,
                                        pageRect: CGRect,
                                        context: UIGraphicsPDFRendererContext) throws -> CGFloat {
        var currentY = yPosition
        
        // Check if new page is needed
        if currentY > pageRect.height - 200 {
            context.beginPage()
            currentY = 50
        }
        
        // Section title
        currentY = drawText(title, 
                          fontSize: 16, 
                          isBold: true, 
                          yPosition: currentY, 
                          leftMargin: leftMargin,
                          rightMargin: rightMargin)
        
        currentY += 10
        
        if data.isEmpty {
            currentY = drawText("No data available", 
                              fontSize: 10, 
                              isBold: false, 
                              yPosition: currentY, 
                              leftMargin: leftMargin,
                              rightMargin: rightMargin)
        } else {
            // Draw data entries (limit to last 20 entries)
            let limitedData = Array(data.prefix(20))
            for entry in limitedData {
                let entryText = formatEntryForPDF(entry: entry)
                currentY = drawText(entryText, 
                                  fontSize: 10, 
                                  isBold: false, 
                                  yPosition: currentY + 5, 
                                  leftMargin: leftMargin,
                                  rightMargin: rightMargin)
                
                // Check if new page is needed
                if currentY > pageRect.height - 100 {
                    context.beginPage()
                    currentY = 50
                }
            }
            
            if data.count > 20 {
                currentY = drawText("... and \(data.count - 20) more entries", 
                                  fontSize: 10, 
                                  isBold: false, 
                                  yPosition: currentY + 5, 
                                  leftMargin: leftMargin,
                                  rightMargin: rightMargin)
            }
        }
        
        return currentY + 20
    }
    
    private func formatEntryForPDF(entry: Any) -> String {
        if let weightEntry = entry as? WeightEntry {
            let dateStr = dateFormatter.string(from: weightEntry.date ?? Date())
            return "\(dateStr): \(String(format: "%.1f", weightEntry.weight)) kg"
        } else if let bpEntry = entry as? BloodPressureEntry {
            let dateStr = dateFormatter.string(from: bpEntry.date ?? Date())
            return "\(dateStr): \(bpEntry.systolic)/\(bpEntry.diastolic) mmHg"
        } else if let hrEntry = entry as? HeartRateEntry {
            let dateStr = dateFormatter.string(from: hrEntry.date ?? Date())
            return "\(dateStr): \(hrEntry.bpm) bpm"
        } else if let bsEntry = entry as? BloodSugarEntry {
            let dateStr = dateFormatter.string(from: bsEntry.date ?? Date())
            return "\(dateStr): \(String(format: "%.1f", bsEntry.glucose)) mg/dL"
        }
        return "Unknown entry"
    }
    
    private func drawText(_ text: String, 
                         fontSize: CGFloat, 
                         isBold: Bool, 
                         yPosition: CGFloat, 
                         leftMargin: CGFloat,
                         rightMargin: CGFloat) -> CGFloat {
        let font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let textRect = CGRect(x: leftMargin, 
                             y: yPosition, 
                             width: rightMargin - leftMargin, 
                             height: fontSize + 10)
        
        text.draw(in: textRect, 
                 withAttributes: [NSAttributedString.Key.font: font])
        
        return yPosition + fontSize + 5
    }
    
    private func drawMedicalDisclaimer(yPosition: CGFloat,
                                     leftMargin: CGFloat,
                                     rightMargin: CGFloat,
                                     pageRect: CGRect,
                                     context: UIGraphicsPDFRendererContext) -> CGFloat {
        var currentY = yPosition
        
        // Check if new page is needed
        if currentY > pageRect.height - 150 {
            context.beginPage()
            currentY = 50
        }
        
        let disclaimer = """
        MEDICAL DISCLAIMER:
        This report is generated from user-entered data and is for informational purposes only. 
        It should not be used as a substitute for professional medical advice, diagnosis, or treatment. 
        Always consult with your healthcare provider before making any medical decisions based on this data.
        
        Generated by Senior Nutrition App on \(dateFormatter.string(from: Date()))
        """
        
        let font = UIFont.systemFont(ofSize: 8)
        let textRect = CGRect(x: leftMargin, 
                             y: currentY, 
                             width: rightMargin - leftMargin, 
                             height: 100)
        
        disclaimer.draw(in: textRect, 
                       withAttributes: [
                        NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: UIColor.gray
                       ])
        
        return currentY + 100
    }
    
    // MARK: - Core Data Fetch Methods
    
    private func fetchWeightEntries() throws -> [WeightEntry] {
        let request: NSFetchRequest<WeightEntry> = WeightEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    private func fetchBloodPressureEntries() throws -> [BloodPressureEntry] {
        let request: NSFetchRequest<BloodPressureEntry> = BloodPressureEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BloodPressureEntry.date, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    private func fetchHeartRateEntries() throws -> [HeartRateEntry] {
        let request: NSFetchRequest<HeartRateEntry> = HeartRateEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HeartRateEntry.date, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    private func fetchBloodSugarEntries() throws -> [BloodSugarEntry] {
        let request: NSFetchRequest<BloodSugarEntry> = BloodSugarEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BloodSugarEntry.date, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    // MARK: - File Saving Utilities
    
    private func saveToFile(content: String, fileName: String, fileExtension: String) throws -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
    
    private func saveToFile(data: Data, fileName: String, fileExtension: String) throws -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileURL)
        return fileURL
    }
    
    // MARK: - Formatters
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - Export Options

enum ExportFormat: String, CaseIterable, Identifiable {
    case csv = "CSV"
    case pdf = "PDF"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .csv:
            return NSLocalizedString("CSV (Spreadsheet)", comment: "CSV export format")
        case .pdf:
            return NSLocalizedString("PDF (Report)", comment: "PDF export format")
        }
    }
    
    var description: String {
        switch self {
        case .csv:
            return NSLocalizedString("Export data in spreadsheet format for analysis", comment: "CSV format description")
        case .pdf:
            return NSLocalizedString("Export formatted health report with charts", comment: "PDF format description")
        }
    }
}

// MARK: - Export Date Range

enum ExportDateRange: String, CaseIterable, Identifiable {
    case lastWeek = "Last Week"
    case lastMonth = "Last Month" 
    case lastThreeMonths = "Last 3 Months"
    case lastSixMonths = "Last 6 Months"
    case lastYear = "Last Year"
    case allData = "All Data"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return NSLocalizedString(self.rawValue, comment: "Export date range")
    }
    
    var dateRange: (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .lastWeek:
            let start = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return (start, now)
        case .lastMonth:
            let start = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return (start, now)
        case .lastThreeMonths:
            let start = calendar.date(byAdding: .month, value: -3, to: now) ?? now
            return (start, now)
        case .lastSixMonths:
            let start = calendar.date(byAdding: .month, value: -6, to: now) ?? now
            return (start, now)
        case .lastYear:
            let start = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return (start, now)
        case .allData:
            return (Date.distantPast, now)
        }
    }
}