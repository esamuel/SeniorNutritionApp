import SwiftUI
import PDFKit
import UIKit

// MARK: - Print Content Views

// Helper function to get localized frequency description
private func localizedFrequency(_ frequency: ScheduleDetails) -> String {
    switch frequency {
    case .daily:
        return NSLocalizedString("Daily", comment: "")
    case .weekly(let days):
        if days.count == 7 {
            return NSLocalizedString("Daily", comment: "")
        } else if days.count == 1, let day = days.first {
            return String(format: NSLocalizedString("Weekly on %@", comment: ""), day.localizedName)
        } else {
            let dayNames = days.sorted { $0.rawValue < $1.rawValue }.map { $0.localizedName }
            return String(format: NSLocalizedString("Weekly on %@", comment: ""), dayNames.joined(separator: ", "))
        }
    case .interval(let days, _):
        return String(format: NSLocalizedString("Every %d days", comment: ""), days)
    case .monthly(let day):
        return String(format: NSLocalizedString("Monthly on day %d", comment: ""), day)
    }
}

// MARK: - Medication Print Content View
struct MedicationPrintContentView: View {
    let medications: [Medication]
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("medication_schedule_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(NSLocalizedString("print_date_label", comment: "") + ": \(formattedDate())")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding(.bottom, 10)
            
            Divider()
                .background(Color.black)
            
            // Medications List
            if medications.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "pills")
                        .font(.system(size: 40))
                        .foregroundColor(.black)
                        .opacity(0.3)
                    
                    Text(NSLocalizedString("no_medications_added", comment: ""))
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(medications, id: \.id) { medication in
                        medicationRow(medication)
                    }
                }
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 5) {
                Divider()
                    .background(Color.black)
                
                Text(NSLocalizedString("print_footer_text", comment: ""))
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
    }
    
    private func medicationRow(_ medication: Medication) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Medication Name
            Text(medication.name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            // Details Grid
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(NSLocalizedString("dosage_label", comment: "") + ":")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(medication.dosage)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                HStack {
                    Text(NSLocalizedString("frequency_label", comment: "") + ":")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(localizedFrequency(medication.frequency))
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                HStack {
                    Text(NSLocalizedString("times_label", comment: "") + ":")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(medication.timesOfDay.map { String(format: "%02d:%02d", $0.hour, $0.minute) }.joined(separator: ", "))
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                if let notes = medication.notes, !notes.isEmpty {
                    HStack(alignment: .top) {
                        Text(NSLocalizedString("notes_label", comment: "") + ":")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 80, alignment: .leading)
                        
                        Text(notes)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(15)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

// MARK: - Fasting Protocol Print View
struct FastingProtocolPrintView: View {
    let fastingProtocol: FastingProtocol
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("fasting_guide_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(NSLocalizedString("print_date_label", comment: "") + ": \(formattedDate())")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding(.bottom, 10)
            
            Divider()
                .background(Color.black)
            
            // Protocol Details
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("selected_protocol_label", comment: ""))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(fastingProtocol.localizedTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(fastingProtocol.localizedDescription)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .opacity(0.8)
                }
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
                
                // Guidelines Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(NSLocalizedString("fasting_guidelines_title", comment: ""))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(fastingProtocol.guidelines.filter { !$0.isEmpty }, id: \.self) { guideline in
                            HStack(alignment: .top, spacing: 10) {
                                Text("•")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(NSLocalizedString(guideline, comment: ""))
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
                
                // Benefits Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(NSLocalizedString("fasting_benefits_title", comment: ""))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(fastingProtocol.benefits.filter { !$0.isEmpty }, id: \.self) { benefit in
                            HStack(alignment: .top, spacing: 10) {
                                Text("•")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(NSLocalizedString(benefit, comment: ""))
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 5) {
                Divider()
                    .background(Color.black)
                
                Text(NSLocalizedString("print_footer_text", comment: ""))
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

// MARK: - Meal Suggestions Print View
struct MealSuggestionsPrintView: View {
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("meal_suggestions_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(NSLocalizedString("print_date_label", comment: "") + ": \(formattedDate())")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding(.bottom, 10)
            
            Divider()
                .background(Color.black)
            
            // Meal Categories
            VStack(alignment: .leading, spacing: 20) {
                mealCategory(
                    title: NSLocalizedString("breakfast_ideas_title", comment: ""),
                    icon: "🌅",
                    items: [
                        NSLocalizedString("breakfast_suggestion_1", comment: ""),
                        NSLocalizedString("breakfast_suggestion_2", comment: ""),
                        NSLocalizedString("breakfast_suggestion_3", comment: ""),
                        NSLocalizedString("breakfast_suggestion_4", comment: "")
                    ]
                )
                
                mealCategory(
                    title: NSLocalizedString("lunch_ideas_title", comment: ""),
                    icon: "☀️",
                    items: [
                        NSLocalizedString("lunch_suggestion_1", comment: ""),
                        NSLocalizedString("lunch_suggestion_2", comment: ""),
                        NSLocalizedString("lunch_suggestion_3", comment: ""),
                        NSLocalizedString("lunch_suggestion_4", comment: "")
                    ]
                )
                
                mealCategory(
                    title: NSLocalizedString("dinner_ideas_title", comment: ""),
                    icon: "🌙",
                    items: [
                        NSLocalizedString("dinner_suggestion_1", comment: ""),
                        NSLocalizedString("dinner_suggestion_2", comment: ""),
                        NSLocalizedString("dinner_suggestion_3", comment: ""),
                        NSLocalizedString("dinner_suggestion_4", comment: "")
                    ]
                )
                
                mealCategory(
                    title: NSLocalizedString("snack_ideas_title", comment: ""),
                    icon: "🍎",
                    items: [
                        NSLocalizedString("snack_suggestion_1", comment: ""),
                        NSLocalizedString("snack_suggestion_2", comment: ""),
                        NSLocalizedString("snack_suggestion_3", comment: ""),
                        NSLocalizedString("snack_suggestion_4", comment: "")
                    ]
                )
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 5) {
                Divider()
                    .background(Color.black)
                
                Text(NSLocalizedString("print_footer_text", comment: ""))
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
    }
    
    private func mealCategory(title: String, icon: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(items.filter { !$0.isEmpty }, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("•")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(15)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

// MARK: - App Instructions Print View
struct AppInstructionsPrintView: View {
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Header
            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: NSLocalizedString("app_instructions_title_personalized", comment: ""), userName))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(NSLocalizedString("print_date_label", comment: "") + ": \(formattedDate())")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding(.bottom, 10)
            
            Divider()
                .background(Color.black)
            
            // Instruction Sections
            VStack(alignment: .leading, spacing: 20) {
                instructionSection(
                    title: NSLocalizedString("medication_management_title", comment: ""),
                    icon: "💊",
                    steps: [
                        NSLocalizedString("medication_step_1", comment: ""),
                        NSLocalizedString("medication_step_2", comment: ""),
                        NSLocalizedString("medication_step_3", comment: ""),
                        NSLocalizedString("medication_step_4", comment: ""),
                        NSLocalizedString("medication_step_5", comment: "")
                    ]
                )
                
                instructionSection(
                    title: NSLocalizedString("fasting_timer_title", comment: ""),
                    icon: "⏰",
                    steps: [
                        NSLocalizedString("fasting_step_1", comment: ""),
                        NSLocalizedString("fasting_step_2", comment: ""),
                        NSLocalizedString("fasting_step_3", comment: ""),
                        NSLocalizedString("fasting_step_4", comment: ""),
                        NSLocalizedString("fasting_step_5", comment: "")
                    ]
                )
                
                instructionSection(
                    title: NSLocalizedString("nutrition_tracking_title", comment: ""),
                    icon: "🥗",
                    steps: [
                        NSLocalizedString("nutrition_step_1", comment: ""),
                        NSLocalizedString("nutrition_step_2", comment: ""),
                        NSLocalizedString("nutrition_step_3", comment: ""),
                        NSLocalizedString("nutrition_step_4", comment: ""),
                        NSLocalizedString("nutrition_step_5", comment: "")
                    ]
                )
                
                instructionSection(
                    title: NSLocalizedString("app_settings_title", comment: ""),
                    icon: "⚙️",
                    steps: [
                        NSLocalizedString("settings_step_1", comment: ""),
                        NSLocalizedString("settings_step_2", comment: ""),
                        NSLocalizedString("settings_step_3", comment: ""),
                        NSLocalizedString("settings_step_4", comment: ""),
                        NSLocalizedString("settings_step_5", comment: "")
                    ]
                )
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 5) {
                Divider()
                    .background(Color.black)
                
                Text(NSLocalizedString("print_support_contact", comment: ""))
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
    }
    
    private func instructionSection(title: String, icon: String, steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<steps.filter({ !$0.isEmpty }).count, id: \.self) { index in
                    let step = steps.filter({ !$0.isEmpty })[index]
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1).")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 25, alignment: .leading)
                        
                        Text(step)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(15)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

// MARK: - MedicationPrintService
class MedicationPrintService: ObservableObject {
    static let shared = MedicationPrintService()
    
    private init() {}
    
    // Method to get PDF data from a SwiftUI view
    @MainActor
    private func getPDFData<Content: View>(from view: Content) -> Data? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2.0
        
        // Use uiImage instead of pdf for iOS compatibility
        if let uiImage = renderer.uiImage {
            return uiImage.pngData()
        }
        return nil
    }
    
    // Print medication schedule
    @MainActor
    func printMedicationSchedule(medications: [Medication], userName: String) {
        let printView = MedicationPrintContentView(medications: medications, userName: userName)
        
        guard let pdfData = getPDFData(from: printView) else {
            print("Failed to generate PDF data")
            return
        }
        
        let printController = UIPrintInteractionController.shared
        printController.printingItem = pdfData
        
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.jobName = "Medication Schedule"
        printController.printInfo = printInfo
        
        printController.present(animated: true) { controller, completed, error in
            if let error = error {
                print("Print error: \(error.localizedDescription)")
            }
        }
    }
    
    // Print fasting protocol guide
    @MainActor
    func printFastingProtocolGuide(fastingProtocol: FastingProtocol, userName: String) {
        let printView = FastingProtocolPrintView(fastingProtocol: fastingProtocol, userName: userName)
        
        guard let pdfData = getPDFData(from: printView) else {
            print("Failed to generate PDF data")
            return
        }
        
        let printController = UIPrintInteractionController.shared
        printController.printingItem = pdfData
        
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.jobName = "Fasting Protocol Guide"
        printController.printInfo = printInfo
        
        printController.present(animated: true) { controller, completed, error in
            if let error = error {
                print("Print error: \(error.localizedDescription)")
            }
        }
    }
    
    // Print meal suggestions
    @MainActor
    func printMealSuggestions(userName: String) {
        let printView = MealSuggestionsPrintView(userName: userName)
        
        guard let pdfData = getPDFData(from: printView) else {
            print("Failed to generate PDF data")
            return
        }
        
        let printController = UIPrintInteractionController.shared
        printController.printingItem = pdfData
        
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.jobName = "Meal Suggestions"
        printController.printInfo = printInfo
        
        printController.present(animated: true) { controller, completed, error in
            if let error = error {
                print("Print error: \(error.localizedDescription)")
            }
        }
    }
    
    // Print app instructions
    @MainActor
    func printAppInstructions(userName: String) {
        let printView = AppInstructionsPrintView(userName: userName)
        
        guard let pdfData = getPDFData(from: printView) else {
            print("Failed to generate PDF data")
            return
        }
        
        let printController = UIPrintInteractionController.shared
        printController.printingItem = pdfData
        
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.jobName = "App Instructions"
        printController.printInfo = printInfo
        
        printController.present(animated: true) { controller, completed, error in
            if let error = error {
                print("Print error: \(error.localizedDescription)")
            }
        }
    }
}