import SwiftUI

struct WaterView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var showingCustomAmount = false
    @State private var customAmount: String = ""
    @State private var dailyProgress: Double = 0.0 // This would normally be stored/retrieved
    @State private var dailyGoal: Double = 2000.0 // Default 2000ml, would be customizable
    
    // Preset amounts in milliliters
    private let presetAmounts = [150, 250, 500]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(dailyProgress / dailyGoal, 1.0)))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: dailyProgress)
                    
                    VStack {
                        Text(String(format: "%.0f", dailyProgress))
                            .font(.system(size: userSettings.textSize.size + 10, weight: .bold))
                        Text("ml")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                        Text(String(format: NSLocalizedString("of %.0f ml", comment: ""), dailyGoal))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)
                
                // Quick Add Buttons
                VStack(spacing: 15) {
                    Text(NSLocalizedString("Quick Add", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 10) {
                        ForEach(presetAmounts, id: \.self) { amount in
                            Button(action: {
                                addWater(amount: Double(amount))
                            }) {
                                Text("\(amount)ml")
                                    .font(.system(size: userSettings.textSize.size))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    Button(action: {
                        showingCustomAmount = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text(NSLocalizedString("Add Custom Amount", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                }
                .padding()
                
                // Today's Log
                VStack(spacing: 15) {
                    Text(NSLocalizedString("Today's Log", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if dailyProgress == 0 {
                        Text(NSLocalizedString("No water intake logged today", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        // This would show actual log entries
                        Text(String(format: NSLocalizedString("Total: %.0f ml", comment: ""), dailyProgress))
                            .font(.system(size: userSettings.textSize.size))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Hydration Tips
                VStack(spacing: 15) {
                    Text(NSLocalizedString("Hydration Tips", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(NSLocalizedString("Remember to drink water regularly throughout the day", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .navigationTitle(NSLocalizedString("Water Tracking", comment: ""))
        .sheet(isPresented: $showingCustomAmount) {
            customAmountSheet
        }
    }
    
    private var customAmountSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(NSLocalizedString("Enter amount in milliliters", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                
                TextField(NSLocalizedString("Amount", comment: ""), text: $customAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: userSettings.textSize.size))
                    .padding()
                
                Button(action: {
                    if let amount = Double(customAmount) {
                        addWater(amount: amount)
                        showingCustomAmount = false
                        customAmount = ""
                    }
                }) {
                    Text(NSLocalizedString("Add", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle(NSLocalizedString("Add Custom Amount", comment: ""))
            .navigationBarItems(trailing: Button(NSLocalizedString("Cancel", comment: "")) {
                showingCustomAmount = false
            })
        }
    }
    
    private func addWater(amount: Double) {
        withAnimation {
            dailyProgress += amount
        }
    }
}

struct WaterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WaterView()
                .environmentObject(UserSettings())
        }
    }
} 