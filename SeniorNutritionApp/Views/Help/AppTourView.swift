import SwiftUI
import Foundation

struct AppTourView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var currentStep = 0
    @State private var showingTour = true
    
    // Tour steps content
    private let tourSteps = [
        TourStep(
            title: "Welcome to Senior Nutrition App",
            description: "This guided tour will help you learn how to use the app's main features.",
            icon: "hand.wave.fill",
            color: .blue
        ),
        TourStep(
            title: "Home Screen",
            description: "The Home screen shows your daily summary, including nutrition, water intake, and active fasting timers.",
            icon: "house.fill",
            color: .indigo
        ),
        TourStep(
            title: "Nutrition Tracking",
            description: "Track your meals and monitor nutritional intake with the Nutrition tab.",
            icon: "fork.knife",
            color: .green
        ),
        TourStep(
            title: "Water Tracking",
            description: "Stay hydrated by logging your water intake in the Water tab.",
            icon: "drop.fill",
            color: .blue
        ),
        TourStep(
            title: "Fasting Timer",
            description: "Use the Fasting Timer to track your fasting periods and eating windows.",
            icon: "timer",
            color: .orange
        ),
        TourStep(
            title: "More Options",
            description: "Access medications, health tips, help resources, and emergency contacts from the More tab.",
            icon: "ellipsis.circle.fill",
            color: .purple
        ),
        TourStep(
            title: "Accessibility Features",
            description: "Customize text size, enable voice commands, and adjust other settings to make the app easier to use.",
            icon: "accessibility",
            color: .teal
        ),
        TourStep(
            title: "Ready to Start!",
            description: "You've completed the tour. Tap 'Finish' to start using the app.",
            icon: "checkmark.circle.fill",
            color: .green
        )
    ]
    
    var body: some View {
        ZStack {
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if !showingTour {
                        // Header
                        HelpComponents.HelpTopic(
                            title: NSLocalizedString("App Tour", comment: ""),
                            description: NSLocalizedString("Take a guided tour of the app", comment: ""),
                            content: ""
                        )
                        
                        // Tour sections
                        ForEach(tourSteps.indices, id: \.self) { index in
                            tourStepView(step: tourSteps[index], index: index)
                        }
                        
                        // Restart tour button
                        Button(action: {
                            currentStep = 0
                            showingTour = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.blue)
                                Text(NSLocalizedString("Restart Tour", comment: ""))
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("App Tour", comment: ""))
            
            // Interactive tour overlay
            if showingTour {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack {
                            Spacer()
                            
                            // Tour content
                            VStack(spacing: 20) {
                                Image(systemName: tourSteps[currentStep].icon)
                                    .font(.system(size: 50))
                                    .foregroundColor(tourSteps[currentStep].color)
                                
                                Text(NSLocalizedString(tourSteps[currentStep].title, comment: ""))
                                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                                    .multilineTextAlignment(.center)
                                
                                Text(NSLocalizedString(tourSteps[currentStep].description, comment: ""))
                                    .font(.system(size: userSettings.textSize.size))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                // Progress indicators
                                HStack(spacing: 8) {
                                    ForEach(0..<tourSteps.count, id: \.self) { index in
                                        Circle()
                                            .fill(currentStep == index ? tourSteps[currentStep].color : Color.gray.opacity(0.5))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.top, 10)
                                
                                // Navigation buttons
                                HStack(spacing: 20) {
                                    if currentStep > 0 {
                                        Button(action: {
                                            withAnimation {
                                                currentStep -= 1
                                            }
                                        }) {
                                            Text(NSLocalizedString("Previous", comment: ""))
                                                .font(.system(size: userSettings.textSize.size))
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(width: 120)
                                                .background(Color.gray)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    Button(action: {
                                        withAnimation {
                                            if currentStep < tourSteps.count - 1 {
                                                currentStep += 1
                                            } else {
                                                showingTour = false
                                            }
                                        }
                                    }) {
                                        Text(currentStep < tourSteps.count - 1 ? 
                                             NSLocalizedString("Next", comment: "") : 
                                             NSLocalizedString("Finish", comment: ""))
                                            .font(.system(size: userSettings.textSize.size))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 120)
                                            .background(tourSteps[currentStep].color)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.top, 20)
                            }
                            .padding(30)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                    )
            }
        }
    }
    
    private func tourStepView(step: TourStep, index: Int) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: step.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(step.color)
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(index + 1). \(NSLocalizedString(step.title, comment: ""))")
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                
                Text(NSLocalizedString(step.description, comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Tour step model
struct TourStep {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct AppTourView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppTourView()
                .environmentObject(UserSettings())
        }
    }
}
