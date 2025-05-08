import SwiftUI

// Print preview view for medication schedules
struct MedicationPrintPreview: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("Medication Schedule")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            if userSettings.medications.isEmpty {
                Text("No medications to display")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(userSettings.medications) { medication in
                            medicationCard(medication)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            Text("Printed from Senior Nutrition App")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .foregroundColor(.black) // Force black text for PDF
    }
    
    private func medicationCard(_ medication: Medication) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(medication.name)
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
                
                Text(medication.dosage)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Schedule:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(scheduleDescription(for: medication))
                        .font(.subheadline)
                }
                
                Spacer()
                
                if let shape = medication.shape {
                    Text(shape.rawValue)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            if let notes = medication.notes, !notes.isEmpty {
                Text("Notes: \(notes)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    // Helper function for formatting the date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    // Helper function for formatting the schedule
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
            return "Every \(days) days (from \(formatter.string(from: startDate)))"
        case .monthly(let day):
            return "Monthly on day \(day)"
        }
    }
}

// Print preview view for fasting protocol
struct FastingProtocolPreview: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("Fasting Protocol Guide")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Your Protocol: \(userSettings.activeFastingProtocol.rawValue)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Fasting Hours:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(userSettings.activeFastingProtocol.fastingHours) hours")
                            .font(.body)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Eating Window:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(userSettings.activeFastingProtocol.eatingHours) hours")
                            .font(.body)
                    }
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                Text(userSettings.activeFastingProtocol.description)
                    .font(.body)
                    .padding(.top, 8)
                
                Text("General Fasting Guidelines:")
                    .font(.headline)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    bulletPoint("Stay hydrated during fasting periods")
                    bulletPoint("Break your fast with a small, balanced meal")
                    bulletPoint("Monitor how you feel and adjust as needed")
                    bulletPoint("Consult with your doctor before starting any fasting regimen")
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .padding()
            
            Spacer()
            
            Text("Printed from Senior Nutrition App")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .foregroundColor(.black) // Force black text for PDF
    }
    
    // Helper function for formatting the date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// Print preview view for meal suggestions
struct MealSuggestionsPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("Healthy Meal Suggestions")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    mealCategory(title: "Breakfast Ideas", items: [
                        "Oatmeal with berries and nuts",
                        "Greek yogurt with honey and granola",
                        "Vegetable omelet with whole grain toast"
                    ])
                    
                    mealCategory(title: "Lunch Ideas", items: [
                        "Quinoa salad with vegetables",
                        "Grilled chicken with steamed vegetables",
                        "Lentil soup with whole grain bread"
                    ])
                    
                    mealCategory(title: "Dinner Ideas", items: [
                        "Baked salmon with roasted vegetables",
                        "Lean beef stir-fry with brown rice",
                        "Vegetable pasta with tomato sauce"
                    ])
                    
                    mealCategory(title: "Healthy Snacks", items: [
                        "Apple slices with peanut butter",
                        "Carrot sticks with hummus",
                        "Greek yogurt with berries"
                    ])
                }
                .padding()
            }
            
            Spacer()
            
            Text("Printed from Senior Nutrition App")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .foregroundColor(.black) // Force black text for PDF
    }
    
    // Helper function for formatting the date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private func mealCategory(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top) {
                    Text("•")
                        .padding(.trailing, 5)
                    Text(item)
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Print preview view for app instructions
struct AppInstructionsPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("App Instructions")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Date: \(formattedDate())")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    instructionSection(title: "Medication Management", steps: [
                        "Add medications through the Medications tab",
                        "Set up reminders for each medication",
                        "Track your medication history",
                        "Update dosages and schedules as needed"
                    ])
                    
                    instructionSection(title: "Fasting Timer", steps: [
                        "Select your fasting protocol",
                        "Start and end your fasts with the timer",
                        "View your fasting history",
                        "Track your progress over time"
                    ])
                    
                    instructionSection(title: "Nutrition Tracking", steps: [
                        "Log your meals and snacks",
                        "Get nutritional insights",
                        "View personalized recommendations",
                        "Monitor your dietary patterns"
                    ])
                    
                    instructionSection(title: "Settings", steps: [
                        "Customize text size",
                        "Enable high contrast mode if needed",
                        "Set up voice assistance",
                        "Configure notification preferences"
                    ])
                }
                .padding()
            }
            
            Spacer()
            
            Text("Printed from Senior Nutrition App")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .foregroundColor(.black) // Force black text for PDF
    }
    
    // Helper function for formatting the date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private func instructionSection(title: String, steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            ForEach(0..<steps.count, id: \.self) { index in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .frame(width: 20, alignment: .leading)
                    Text(steps[index])
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct PrintPreviewViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MedicationPrintPreview()
                .environmentObject(UserSettings())
            
            FastingProtocolPreview()
                .environmentObject(UserSettings())
            
            MealSuggestionsPreview()
            
            AppInstructionsPreview()
        }
    }
}
#endif 