import SwiftUI
import UIKit

class MedicationPrintService {
    static let shared = MedicationPrintService()
    
    private init() {}
    
    // Method to explain printing functionality to the user
    func showPrintingInstructions() -> String {
        return """
        Printing Instructions:
        
        1. Make sure your iOS device is connected to a printer
           (Go to iOS Settings > Printers & Scanners to add one)
        
        2. When you select "Print", a sharing menu will appear with printing options
        
        3. Choose "Print" from the menu options
        
        4. Select your printer and print settings
        
        5. Tap "Print" to send the document to your printer
        
        Note: If you don't have a printer, you can save the document as a PDF by using the "Save to Files" option in the sharing menu.
        """
    }
    
    // Method to get PDF data from a SwiftUI view
    private func getPDFData<T: View>(from content: T, height: CGFloat) -> Data? {
        // Convert SwiftUI view to UIView
        let controller = UIHostingController(rootView: content)
        let contentView = controller.view!
        
        // Set a reasonable size for the PDF
        let pageWidth = UIScreen.main.bounds.width * 0.9
        contentView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: height)
        
        // Ensure view has white background
        contentView.backgroundColor = .white
        
        // Allow the view to layout its contents
        contentView.layoutIfNeeded()
        
        // Create PDF renderer with high quality settings
        let rendererFormat = UIGraphicsPDFRendererFormat()
        rendererFormat.documentInfo = [
            kCGPDFContextTitle as String: "Senior Nutrition App Document",
            kCGPDFContextCreator as String: "Senior Nutrition App"
        ]
        
        let pdfRenderer = UIGraphicsPDFRenderer(
            bounds: contentView.bounds,
            format: rendererFormat
        )
        
        // Generate PDF data
        return try? pdfRenderer.pdfData { context in
            context.beginPage()
            
            // Set white background for the entire page
            UIColor.white.set()
            context.fill(contentView.bounds)
            
            // Render the content
            contentView.layer.render(in: context.cgContext)
        }
    }
    
    // Method to handle direct printing - presents the system print dialog
    private func printPDF(data: Data) {
        // Get the print controller
        let printController = UIPrintInteractionController.shared
        
        // Configure print job
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = "Senior Nutrition App Document"
        printController.printInfo = printInfo
        
        // Set the PDF data as the printing item
        printController.printingItem = data
        
        // Find the key window to present from
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let _ = windowScene.windows.first?.rootViewController {
            // Present from the root view controller to ensure it appears
            printController.present(animated: true, completionHandler: { (controller, success, error) in
                if let error = error {
                    print("Printing error: \(error.localizedDescription)")
                }
            })
        } else {
            // Fallback to standard presentation if we can't find the root view controller
            printController.present(animated: true) { (controller, success, error) in
                if let error = error {
                    print("Printing error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Private helper to handle all printing and PDF saving
    private func displayPrintSheet<T: View>(for content: T, filename: String, height: CGFloat) {
        guard let pdfData = getPDFData(from: content, height: height) else {
            print("Failed to generate PDF")
            return
        }
        
        // Create temp URL for PDF
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(filename).pdf")
        
        do {
            try pdfData.write(to: tempURL)
            
            // Create activity view controller focused on PDF sharing options
            let activityViewController = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            // Make sure PDF sharing options are not excluded
            activityViewController.excludedActivityTypes = [
                .assignToContact,
                .addToReadingList,
                .markupAsPDF // Exclude this to prevent conflicts as we're already providing a PDF
            ]
            
            // Present the activity view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                
                DispatchQueue.main.async {
                    // For iPad presentation (important for proper display of share sheet)
                    if let popover = activityViewController.popoverPresentationController {
                        popover.sourceView = rootViewController.view
                        popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX, 
                                                   y: rootViewController.view.bounds.midY, 
                                                   width: 0, height: 0)
                        popover.permittedArrowDirections = []
                    }
                    
                    // Add completion handler to check if user saved the PDF
                    activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                        if let error = error {
                            print("Error sharing PDF: \(error.localizedDescription)")
                        }
                    }
                    
                    rootViewController.present(activityViewController, animated: true)
                }
            }
        } catch {
            print("Error writing PDF: \(error.localizedDescription)")
        }
    }
    
    func printMedicationSchedule(medications: [Medication]) {
        let printContent = MedicationPrintContentView(medications: medications)
        let height = CGFloat(medications.count) * 150 + 200
        
        if let pdfData = getPDFData(from: printContent, height: height) {
            // Always use direct printing to ensure the print dialog appears
            printPDF(data: pdfData)
        } else {
            print("Failed to generate PDF for medication schedule")
        }
    }
    
    func printFastingProtocol(protocol fastingProtocol: FastingProtocol) {
        let printContent = FastingProtocolPrintView(fastingProtocol: fastingProtocol)
        if let pdfData = getPDFData(from: printContent, height: 500) {
            // Always use direct printing to ensure the print dialog appears
            printPDF(data: pdfData)
        } else {
            print("Failed to generate PDF for fasting protocol")
        }
    }
    
    func printMealSuggestions() {
        let printContent = MealSuggestionsPrintView()
        if let pdfData = getPDFData(from: printContent, height: 700) {
            // Always use direct printing to ensure the print dialog appears
            printPDF(data: pdfData)
        } else {
            print("Failed to generate PDF for meal suggestions")
        }
    }
    
    func printAppInstructions() {
        let printContent = AppInstructionsPrintView()
        if let pdfData = getPDFData(from: printContent, height: 800) {
            // Always use direct printing to ensure the print dialog appears
            printPDF(data: pdfData)
        } else {
            print("Failed to generate PDF for app instructions")
        }
    }
}

struct MedicationPrintContentView: View {
    let medications: [Medication]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Medication Schedule")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.system(size: 14))
                .padding(.bottom, 20)
            
            ForEach(medications) { medication in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(medication.name)
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                        
                        Text(medication.dosage)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Schedule:")
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(scheduleDescription(for: medication))
                                .font(.system(size: 14))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 3) {
                            Text("Times:")
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(timesDescription(for: medication))
                                .font(.system(size: 14))
                        }
                    }
                    
                    if let notes = medication.notes, !notes.isEmpty {
                        Text("Notes: \(notes)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            
            if medications.isEmpty {
                Text("No medications scheduled")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            
            Spacer()
            
            Text("This schedule was generated by Senior Nutrition App")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
    }
    
    // Helper functions
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private func scheduleDescription(for medication: Medication) -> String {
        switch medication.frequency {
        case .daily:
            return "Daily"
        case .weekly(let days):
            let sortedDays = days.sorted()
            return sortedDays.map { $0.shortName }.joined(separator: ", ")
        case .interval(let days, let startDate):
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return "Every \(days) days (starting \(formatter.string(from: startDate)))"
        case .monthly(let day):
            return "Monthly on day \(day)"
        }
    }
    
    private func timesDescription(for medication: Medication) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        return medication.timesOfDay.map { time in
            let date = Calendar.current.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: Date()) ?? Date()
            return formatter.string(from: date)
        }.joined(separator: ", ")
    }
}

struct FastingProtocolPrintView: View {
    let fastingProtocol: FastingProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Fasting Protocol Guide")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.system(size: 14))
                .padding(.bottom, 20)
            
            // Protocol Summary
            VStack(alignment: .leading, spacing: 10) {
                Text("Your Protocol: \(fastingProtocol.rawValue)")
                    .font(.system(size: 20, weight: .semibold))
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Fasting Hours:")
                            .font(.system(size: 16, weight: .medium))
                        Text("\(fastingProtocol.fastingHours) hours")
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Eating Window:")
                            .font(.system(size: 16, weight: .medium))
                        Text("\(fastingProtocol.eatingHours) hours")
                            .font(.system(size: 16))
                    }
                }
                
                Text(fastingProtocol.localizedDescription)
                    .font(.system(size: 16))
                    .padding(.top, 10)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // General Guide
            VStack(alignment: .leading, spacing: 10) {
                Text("General Fasting Guidelines")
                    .font(.system(size: 18, weight: .semibold))
                
                Divider()
                
                Text("• During fasting periods, drink plenty of water")
                    .font(.system(size: 14))
                
                Text("• Black coffee and tea (no sugar or cream) are allowed during fasting")
                    .font(.system(size: 14))
                
                Text("• Break your fast with a balanced, nutrient-rich meal")
                    .font(.system(size: 14))
                
                Text("• Pay attention to hunger signals and adjust as needed")
                    .font(.system(size: 14))
                
                Text("• Consult with a healthcare provider before starting any fasting regimen")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.top, 5)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Spacer()
            
            Text("This guide was generated by Senior Nutrition App")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
    }
    
    // Helper functions
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

struct MealSuggestionsPrintView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Healthy Meal Suggestions")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.system(size: 14))
                .padding(.bottom, 20)
            
            // Breakfast suggestions
            mealCategorySection(
                title: "Breakfast Ideas",
                meals: [
                    "Oatmeal with berries and nuts",
                    "Greek yogurt with granola and honey",
                    "Veggie omelette with whole grain toast",
                    "Smoothie with spinach, banana, and protein powder",
                    "Whole grain cereal with milk and fruit"
                ]
            )
            
            // Lunch suggestions
            mealCategorySection(
                title: "Lunch Ideas",
                meals: [
                    "Quinoa salad with vegetables and chickpeas",
                    "Turkey and avocado wrap with side salad",
                    "Lentil soup with whole grain bread",
                    "Grilled chicken salad with olive oil dressing",
                    "Tuna sandwich on whole grain bread with vegetables"
                ]
            )
            
            // Dinner suggestions
            mealCategorySection(
                title: "Dinner Ideas",
                meals: [
                    "Baked salmon with roasted vegetables",
                    "Grilled chicken with sweet potato and broccoli",
                    "Bean and vegetable stir fry with brown rice",
                    "Whole grain pasta with tomato sauce and vegetables",
                    "Lean beef stew with carrots, potatoes, and peas"
                ]
            )
            
            // Snack suggestions
            mealCategorySection(
                title: "Healthy Snacks",
                meals: [
                    "Apple slices with almond butter",
                    "Handful of mixed nuts and dried fruit",
                    "Carrot sticks with hummus",
                    "Greek yogurt with berries",
                    "Whole grain crackers with cheese"
                ]
            )
            
            Spacer()
            
            Text("This guide was generated by Senior Nutrition App")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
    }
    
    // Helper function for meal category section
    private func mealCategorySection(title: String, meals: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            
            Divider()
            
            ForEach(meals, id: \.self) { meal in
                HStack(alignment: .top) {
                    Text("•")
                        .font(.system(size: 14))
                    
                    Text(meal)
                        .font(.system(size: 14))
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Helper functions
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

struct AppInstructionsPrintView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Senior Nutrition App Instructions")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.system(size: 14))
                .padding(.bottom, 20)
            
            // Main sections
            instructionSection(
                title: "Medication Management",
                steps: [
                    "Tap the 'Medications' tab at the bottom of the screen",
                    "To add a new medication, tap the '+' button",
                    "Fill in the medication details: name, dosage, schedule, etc.",
                    "Tap 'Save' to create the medication reminder",
                    "To edit or delete a medication, tap on it from the list"
                ]
            )
            
            instructionSection(
                title: "Fasting Timer",
                steps: [
                    "Tap the 'Fasting' tab at the bottom of the screen",
                    "Select your fasting protocol from the dropdown menu",
                    "Tap 'Start Fast' to begin your fasting timer",
                    "The app will notify you when your fasting period is complete",
                    "Tap 'End Fast' when you break your fast"
                ]
            )
            
            instructionSection(
                title: "Nutrition Tracking",
                steps: [
                    "Tap the 'Nutrition' tab at the bottom of the screen",
                    "To add a meal, tap the '+' button",
                    "Enter the meal details or select from suggestions",
                    "View your nutrition summary and recommendations",
                    "Track your progress over time with the charts"
                ]
            )
            
            instructionSection(
                title: "App Settings",
                steps: [
                    "Tap the 'Settings' tab at the bottom of the screen",
                    "Adjust text size for better readability",
                    "Toggle high contrast mode if needed",
                    "Set up voice assistance options",
                    "Configure notification preferences"
                ]
            )
            
            Spacer()
            
            Text("For further assistance, please contact support@seniornutritionapp.com")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
    }
    
    // Helper function for instruction section
    private func instructionSection(title: String, steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            
            Divider()
            
            ForEach(0..<steps.count, id: \.self) { index in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .font(.system(size: 14, weight: .medium))
                        .frame(width: 25, alignment: .leading)
                    
                    Text(steps[index])
                        .font(.system(size: 14))
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Helper functions
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
} 