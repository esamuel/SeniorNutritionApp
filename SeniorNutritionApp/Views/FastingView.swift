import SwiftUI

struct FastingView: View {
    @State private var fastingTips: [HealthTip] = []
    private let healthTipsService = HealthTipsService.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Fasting timer and other fasting-related UI would go here
                
                // Health Tips Section - specifically fasting-related tips
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Health Tips")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink(destination: HealthTipsView()) {
                            Text("View More")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(fastingTips) { tip in
                            HealthTipView(tip: tip)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Other fasting view sections would go here
            }
            .padding(.vertical)
        }
        .onAppear {
            // Get fasting-specific health tips
            fastingTips = healthTipsService.getRandomTips(
                count: 2,
                category: .fasting
            )
        }
        .navigationTitle("Fasting Timer")
    }
}

// Preview provider for SwiftUI canvas
struct FastingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FastingView()
        }
    }
} 