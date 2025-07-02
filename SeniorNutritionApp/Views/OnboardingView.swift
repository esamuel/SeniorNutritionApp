import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import Foundation

struct OnboardingView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var currentPage = 0
    @Environment(\.presentationMode) private var presentationMode
    let isFirstLaunch: Bool
    
    init(isFirstLaunch: Bool = true) {
        self.isFirstLaunch = isFirstLaunch
    }
    
    // Define pages for onboarding
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Senior Nutrition",
            description: "Your personal nutrition companion designed specifically for seniors, with enhanced accessibility and intuitive navigation.",
            imageName: "heart.fill",
            tips: ["Customizable text size for easier reading", "Language support for English, French, Spanish, and Hebrew", "Simple, uncluttered interface with voice assistance"]
        ),
        OnboardingPage(
            title: "Track Your Meals & Nutrition",
            description: "Monitor your diet with our easy-to-use food tracking system, including nutritional analysis and personalized recommendations.",
            imageName: "fork.knife",
            tips: ["Photo-based meal logging", "Built-in barcode scanner (Premium)", "Voice input for hands-free recording"]
        ),
        OnboardingPage(
            title: "Personalized Fasting Protocols",
            description: "Follow gentle, senior-friendly intermittent fasting schedules with built-in safety features and health monitoring.",
            imageName: "timer",
            tips: ["Multiple preset protocols available", "Real-time progress tracking", "Emergency override with one tap"]
        ),
        OnboardingPage(
            title: "Health Data Tracking",
            description: "Monitor vital health metrics like blood pressure, weight, blood sugar, and heart rate with detailed visualizations and trend analysis.",
            imageName: "heart.text.square",
            tips: ["Easy data entry with voice option", "Visual trends and patterns", "Exportable reports for doctor visits"]
        ),
        OnboardingPage(
            title: "Appointment Management",
            description: "Never miss a medical appointment with our comprehensive calendar system, reminders, and location tracking.",
            imageName: "calendar",
            tips: ["Schedule doctor visits and check-ups", "Get timely reminders", "Store location and provider details"]
        ),
        OnboardingPage(
            title: "Comprehensive Medication Management",
            description: "Keep track of all your medications with automatic reminders and integration with your fasting schedule.",
            imageName: "pill.fill",
            tips: ["Visual pill identification", "Meal requirements tracking", "Smart notifications synchronized with your routine"]
        ),
        OnboardingPage(
            title: "Health Monitoring & Support",
            description: "Track key health metrics and get personalized guidance with continuous support whenever you need it.",
            imageName: "person.fill.questionmark",
            tips: ["Video tutorials and live support", "Health data visualization", "Emergency contact system"]
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Spacer()
                    Button(action: {
                        if isFirstLaunch {
                            userSettings.isOnboardingComplete = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text(NSLocalizedString(isFirstLaunch ? "Skip" : "Close", comment: "Skip or close onboarding"))
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text(NSLocalizedString("Previous", comment: "Go to previous onboarding page"))
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text(NSLocalizedString("Next", comment: "Go to next onboarding page"))
                                .foregroundColor(.blue)
                                .padding()
                        }
                    } else {
                        Button(action: {
                            if isFirstLaunch {
                                userSettings.isOnboardingComplete = true
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text(NSLocalizedString(isFirstLaunch ? "Get Started" : "Return to Profile", comment: "Finish onboarding"))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// Custom view for app logo
struct AppLogoView: View {
    var size: CGFloat = 140
    
    var body: some View {
        // Try different image names that might match the app icon
        if let uiImage = UIImage(named: "AppIcons 2/appstore") {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .cornerRadius(size/7)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        } else if let uiImage = UIImage(named: "appstore") {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .cornerRadius(size/7)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        } else {
            // Fallback icon with app-like styling
            ZStack {
                RoundedRectangle(cornerRadius: size/7)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.yellow.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(width: size, height: size)
                
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.6, height: size * 0.6)
                    .foregroundColor(.red)
            }
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // App logo at the top
                    VStack(spacing: 15) {
                        AppLogoView(size: min(140, geometry.size.width * 0.3))
                            .padding(.top, 20)
                        
                        // Small feature icon below
                        Image(systemName: page.imageName)
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 5)
                    
                    Text(NSLocalizedString(page.title, comment: "Onboarding page title"))
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(NSLocalizedString(page.description, comment: "Onboarding page description"))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(page.tips, id: \.self) { tip in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                Text(NSLocalizedString(tip, comment: "Onboarding tip"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let tips: [String]
}

// Coach mark for highlighting features
struct CoachMark: View {
    @Binding var isShowing: Bool
    let position: CGPoint
    let size: CGSize
    let message: String
    let arrowPosition: ArrowPosition
    
    enum ArrowPosition {
        case top, bottom, left, right
    }
    
    var body: some View {
        if isShowing {
            GeometryReader { geometry in
                ZStack {
                    // Background overlay with hole
                    Path { path in
                        path.addRect(CGRect(origin: .zero, size: geometry.size))
                        path.addRoundedRect(in: CGRect(origin: position, size: size), cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 8, bottomTrailing: 8, topTrailing: 8))
                    }
                    .fill(Color.black.opacity(0.6))
                    .allowsHitTesting(true)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                    
                    // Message bubble
                    VStack {
                        Text(NSLocalizedString(message, comment: "Coach mark message"))
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .position(bubblePosition(in: geometry))
                    
                    // Highlighted element outline
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 3)
                        .frame(width: size.width, height: size.height)
                        .position(x: position.x + size.width/2, y: position.y + size.height/2)
                }
            }
        } else {
            EmptyView()
        }
    }
    
    // Calculate position for the message bubble
    private func bubblePosition(in geometry: GeometryProxy) -> CGPoint {
        switch arrowPosition {
        case .top:
            return CGPoint(x: position.x + size.width/2, y: position.y - 60)
        case .bottom:
            return CGPoint(x: position.x + size.width/2, y: position.y + size.height + 60)
        case .left:
            return CGPoint(x: position.x - 100, y: position.y + size.height/2)
        case .right:
            return CGPoint(x: position.x + size.width + 100, y: position.y + size.height/2)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(UserSettings())
    }
} 