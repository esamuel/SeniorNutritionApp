#if os(iOS)
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    // Sample data for demonstration
    @State private var fastingProgress: Double = 0.65
    @State private var nextMealTime: Date = Date().addingTimeInterval(14400) // 4 hours from now
    @State private var nextMedication: Medication? = Medication(
        name: "Blood Pressure Med",
        dosage: "10mg",
        schedule: [Date().addingTimeInterval(7200)], // 2 hours from now
        takeWithFood: true
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    welcomeSection
                    fastingStatusSection
                    quickActionsSection
                    upcomingSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for help button
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel("Get Help")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Welcome section with user name and current status
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Good \(timeOfDay), \(userSettings.userProfile?.firstName ?? userSettings.userName)")
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
            
            if let profile = userSettings.userProfile {
                Text("Age: \(profile.age)")
                    .font(.system(size: userSettings.textSize.size))
            }
            
            Text("Today is \(formattedDate)")
                .font(.system(size: userSettings.textSize.size))
            
            if let nextMed = nextMedication {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.red)
                    Text("Reminder: Take \(nextMed.name) in \(timeUntil(nextMed.schedule[0]))")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Fasting status section
    private var fastingStatusSection: some View {
        VStack(spacing: 15) {
            Text("Fasting Status")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(Color.blue)
                
                Circle()
                    .trim(from: 0.0, to: fastingProgress)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: fastingProgress)
                
                VStack {
                    Text("\(Int(fastingProgress * 100))%")
                        .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                    
                    Text("10:30 remaining")
                        .font(.system(size: userSettings.textSize.size))
                }
            }
            .frame(width: 200, height: 200)
            
            Button(action: {
                // Action to view detailed fasting timer
            }) {
                Text("View Fasting Details")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Quick actions section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                quickActionButton(icon: "plus.circle.fill", title: "Add Meal", action: {})
                quickActionButton(icon: "pill.fill", title: "Log Medicine", action: {})
                quickActionButton(icon: "phone.fill", title: "Get Help", action: {})
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Upcoming section for meals and medications
    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Coming Up Next")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 15) {
                upcomingItem(
                    icon: "fork.knife",
                    title: "Next Meal Window",
                    time: nextMealTime,
                    color: .green
                )
                
                if let med = nextMedication {
                    upcomingItem(
                        icon: "pill.fill",
                        title: med.name,
                        time: med.schedule[0],
                        color: .blue,
                        subtitle: med.takeWithFood ? "Take with food" : nil
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper for quick action buttons
    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // Helper for upcoming items
    private func upcomingItem(icon: String, title: String, time: Date, color: Color, subtitle: String? = nil) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                
                Text(timeUntil(time))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // Helper computed properties
    private var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Morning"
        } else if hour < 17 {
            return "Afternoon"
        } else {
            return "Evening"
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
    
    // Helper method to format time until an event
    private func timeUntil(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date)
        
        if let hour = components.hour, let minute = components.minute {
            if hour > 0 {
                return "\(hour) hour\(hour == 1 ? "" : "s") \(minute) min"
            } else {
                return "\(minute) minute\(minute == 1 ? "" : "s")"
            }
        }
        
        return "Now"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserSettings())
    }
}
#endif 