import SwiftUI

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
            title: "Welcome to Your Health App",
            description: "We've designed this app specifically for seniors to make healthy eating and fasting simple.",
            imageName: "person.fill.checkmark",
            tips: ["Large text for easy reading", "Simple navigation", "Help available anytime"]
        ),
        OnboardingPage(
            title: "Track Your Meals",
            description: "Easily record what you eat with simple options tailored for you.",
            imageName: "fork.knife",
            tips: ["Take photos of your meals", "Scan barcodes for packaged foods", "Use voice input instead of typing"]
        ),
        OnboardingPage(
            title: "Fasting Made Simple",
            description: "Follow gentle fasting schedules designed specifically for seniors.",
            imageName: "timer",
            tips: ["Easy to read timer", "Clear eating windows", "Emergency override button"]
        ),
        OnboardingPage(
            title: "Medication Management",
            description: "Never miss a dose with our simple medication tracker.",
            imageName: "pill.fill",
            tips: ["Reminders when to take medications", "Shows if meds should be taken with food", "Coordinates with your fasting schedule"]
        ),
        OnboardingPage(
            title: "Help When You Need It",
            description: "We're always here to help if you have any questions.",
            imageName: "person.fill.questionmark",
            tips: ["Video tutorials", "Phone support", "Print instructions for offline reference"]
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
                        Text(isFirstLaunch ? "Skip" : "Close")
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
                            Text("Previous")
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
                            Text("Next")
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
                            Text(isFirstLaunch ? "Get Started" : "Return to Profile")
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

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(page.tips, id: \.self) { tip in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                        Text(tip)
                    }
                }
            }
            .padding()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let tips: [String]
}

// Help popup for use throughout the app
struct ContextualHelpView: View {
    @Binding var isShowing: Bool
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                    
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isShowing = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                
                // Content
                Text(message)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Button
                Button(action: {
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Text("Got It")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(30)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 15)
            .padding(40)
        }
    }
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
                        Text(message)
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