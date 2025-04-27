import SwiftUI

/// A view modifier that displays a nutritional alert when a meal with concerns is added
struct NutritionalAlertModifier: ViewModifier {
    @ObservedObject var mealManager: MealManager
    @EnvironmentObject var userSettings: UserSettings
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if mealManager.showingNutritionalAlert, let analysisResult = mealManager.currentAnalysisResult {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                    .onTapGesture {
                        // Optional: allow dismissing by tapping outside
                        // mealManager.dismissNutritionalAlert()
                    }
                
                NutritionalAlertView(
                    isPresented: Binding<Bool>(
                        get: { mealManager.showingNutritionalAlert },
                        set: { if !$0 { mealManager.dismissNutritionalAlert() } }
                    ),
                    analysisResult: analysisResult,
                    onDismiss: {
                        mealManager.dismissNutritionalAlert()
                    }
                )
                .environmentObject(userSettings)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .animation(.easeInOut, value: mealManager.showingNutritionalAlert)
    }
}

// Extension to make it easier to apply the modifier
extension View {
    func withNutritionalAlerts(mealManager: MealManager) -> some View {
        self.modifier(NutritionalAlertModifier(mealManager: mealManager))
    }
} 