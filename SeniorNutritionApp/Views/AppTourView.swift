import SwiftUI

struct AppTourView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @State private var currentPage = 0
    
    let tourPages = [
        TourPage(
            icon: "heart.fill",
            iconColor: .red,
            title: "Welcome to Senior Nutrition",
            description: "Your personal companion for healthy aging. Track nutrition, manage medications, and monitor your health with ease.",
            backgroundColor: .blue
        ),
        TourPage(
            icon: "fork.knife",
            iconColor: .orange,
            title: "Personalized Nutrition",
            description: "Log your meals, analyze nutritional content, and get personalized recommendations to support your health goals.",
            backgroundColor: .green
        ),
        TourPage(
            icon: "drop.fill",
            iconColor: .blue,
            title: "Water Tracking",
            description: "Stay hydrated with easy water logging, customizable goals, and smart reminders throughout your day.",
            backgroundColor: .cyan
        ),
        TourPage(
            icon: "timer",
            iconColor: .orange,
            title: "Fasting Timer",
            description: "Manage intermittent fasting schedules with visual timers, progress tracking, and customizable protocols.",
            backgroundColor: .purple
        ),
        TourPage(
            icon: "pill.fill",
            iconColor: .red,
            title: "Medication Management",
            description: "Never miss a dose with smart reminders, medication tracking, and easy refill alerts.",
            backgroundColor: .pink
        ),
        TourPage(
            icon: "heart.text.square",
            iconColor: .green,
            title: "Health Monitoring",
            description: "Track blood pressure, blood sugar, weight, and heart rate with detailed history and trends.",
            backgroundColor: .mint
        ),
        TourPage(
            icon: "accessibility",
            iconColor: .blue,
            title: "Accessibility & Support",
            description: "Large text options, voice assistance, comprehensive help, and emergency contacts for your safety.",
            backgroundColor: .indigo
        ),
        TourPage(
            icon: "star.fill",
            iconColor: .yellow,
            title: "Premium Features",
            description: "Unlock advanced analytics, unlimited meal tracking, detailed reports, and priority support.",
            backgroundColor: .orange
        ),
        TourPage(
            icon: "checkmark.circle.fill",
            iconColor: .green,
            title: "Ready to Get Started",
            description: "Set up your profile, add your first meal, and begin your journey to better health today!",
            backgroundColor: .green
        )
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    tourPages[currentPage].backgroundColor.opacity(0.1),
                    tourPages[currentPage].backgroundColor.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page indicator
                HStack {
                    ForEach(0..<tourPages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? tourPages[currentPage].backgroundColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                // Tour content
                TabView(selection: $currentPage) {
                    ForEach(0..<tourPages.count, id: \.self) { index in
                        TourPageView(page: tourPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                // Bottom buttons
                HStack {
                    if currentPage < tourPages.count - 1 {
                        Button("Skip") {
                            markTourCompleted()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: userSettings.textSize.size, weight: .medium))
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(tourPages[currentPage].backgroundColor)
                        .cornerRadius(25)
                    } else {
                        Button("Get Started") {
                            markTourCompleted()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(tourPages[currentPage].backgroundColor)
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func markTourCompleted() {
        userSettings.markAppTourCompleted()
    }
}

struct TourPageView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let page: TourPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundColor(page.iconColor)
                .padding(40)
                .background(
                    Circle()
                        .fill(page.backgroundColor.opacity(0.1))
                        .frame(width: 160, height: 160)
                )
            
            // Content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(size: userSettings.textSize.size + 6, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text(page.description)
                    .font(.system(size: userSettings.textSize.size))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct TourPage {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let backgroundColor: Color
}

struct AppTourView_Previews: PreviewProvider {
    static var previews: some View {
        AppTourView()
            .environmentObject(UserSettings())
    }
} 