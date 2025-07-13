import SwiftUI
import Charts
#if canImport(UIKit)
import UIKit
#endif

struct NutritionalDashboardView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject private var premiumManager: PremiumManager
    @ObservedObject var mealManager: MealManager
    @State private var selectedDate = Date()
    @State private var showingPremiumUpgrade = false
    @State private var timeRange: TimeRange = .week
    @State private var showingPremiumAlert = false
    @State private var selectedViewMode: ViewMode = .daily
    
    enum ViewMode: String, CaseIterable {
        case daily = "Daily"
        case trends = "Trends"
        
        var localizedName: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // View mode selector
                viewModeSelector
                
                if selectedViewMode == .daily {
                    // Daily view (existing functionality)
                    dailyView
                } else {
                    // Trends view (new functionality)
                    trendsView
                }
            }
            .padding()
        }
        .onAppear {
            Task { @MainActor in
                await mealManager.updateGoalsFromUserSettings(userSettings)
            }
        }
        .onChange(of: selectedDate) { _, _ in
            Task { @MainActor in
                await mealManager.updateGoalsFromUserSettings(userSettings)
            }
        }
        .sheet(isPresented: $showingPremiumUpgrade) {
            PremiumFeaturesView()
                .environmentObject(premiumManager)
        }
        .alert(NSLocalizedString("Premium Feature", comment: ""), isPresented: $showingPremiumAlert) {
            Button(NSLocalizedString("Cancel", comment: ""), role: .cancel) { }
            Button(NSLocalizedString("Upgrade", comment: "")) {
                showingPremiumUpgrade = true
            }
        } message: {
            Text(NSLocalizedString("Extended nutrition analytics history is available with Advanced or Premium subscription. Free users can view up to 7 days of data.", comment: ""))
        }
    }
    
    // View mode selector
    private var viewModeSelector: some View {
        Picker("View Mode", selection: $selectedViewMode) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                Text(mode.localizedName).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Daily view (existing functionality)
    private var dailyView: some View {
        VStack(spacing: 20) {
            // Date selector
            dateSelector
            
            // Daily summary
            dailySummarySection
            
            // Macronutrient breakdown
            macronutrientSection
            
            // Vitamin progress
            vitaminProgressSection
            
            // Mineral progress
            mineralProgressSection
        }
    }
    
    // Trends view (new functionality)
    private var trendsView: some View {
        VStack(spacing: 20) {
            // Time range picker
            timeRangeSelector
            
            // Nutrition trends chart
            nutritionTrendsChart
            
            // Trend insights
            trendInsights
        }
    }
    
    // Time range selector for trends
    private var timeRangeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("Time Range", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            Picker("Time Range", selection: $timeRange) {
                Text(NSLocalizedString("Week", comment: "Time range option: Week")).tag(TimeRange.week)
                
                HStack {
                    Text(NSLocalizedString("Month", comment: "Time range option: Month"))
                    if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                .tag(TimeRange.month)
                .disabled(!premiumManager.hasAccess(to: PremiumFeature.extendedHistory))
                
                HStack {
                    Text(NSLocalizedString("3 Months", comment: "Time range option: Three Months"))
                    if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                .tag(TimeRange.threeMonths)
                .disabled(!premiumManager.hasAccess(to: PremiumFeature.extendedHistory))
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: timeRange) { oldValue, newValue in
                if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) && newValue != .week {
                    timeRange = .week
                    showingPremiumAlert = true
                }
            }
            
            // Premium limitation notice for Free users
            if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text(NSLocalizedString("Free users can view up to 7 days of nutrition analytics. Upgrade for extended history.", comment: ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(NSLocalizedString("Upgrade", comment: "")) {
                        showingPremiumUpgrade = true
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Nutrition trends chart
    private var nutritionTrendsChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("Nutrition Trends", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            if nutritionDataPoints.isEmpty {
                Text(NSLocalizedString("No nutrition data available for the selected time range", comment: ""))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            } else {
                nutritionChart
                    .frame(height: 300)
                    .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Nutrition chart implementation
    private var nutritionChart: some View {
        Chart {
            ForEach(nutritionDataPoints) { dataPoint in
                // Calories line
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Calories", dataPoint.calories)
                )
                .foregroundStyle(.blue)
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                // Calories points
                PointMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Calories", dataPoint.calories)
                )
                .foregroundStyle(.blue)
                .symbolSize(30)
            }
            
            // Goal line for calories
            RuleMark(
                y: .value("Goal", mealManager.nutritionalGoals.dailyCalories)
            )
            .foregroundStyle(.blue.opacity(0.5))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
        }
        .chartXAxis {
            AxisMarks(preset: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: timeRange.dateFormat)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .automatic) { value in
                AxisValueLabel()
                AxisGridLine()
            }
        }
        .chartLegend(position: .bottom) {
            HStack(spacing: 20) {
                LegendItem(color: .blue, label: NSLocalizedString("Calories", comment: ""))
                LegendItem(color: .blue.opacity(0.5), label: NSLocalizedString("Goal", comment: ""), isDashed: true)
            }
        }
    }
    
    // Trend insights
    private var trendInsights: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("Insights", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            VStack(alignment: .leading, spacing: 8) {
                if let insight = nutritionInsight {
                    Text(insight)
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                } else {
                    Text(NSLocalizedString("Add more meals to see nutrition insights and trends.", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Date selector for daily view
    private var dateSelector: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: { moveDate(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: userSettings.textSize.size))
                }
                .disabled(!canNavigateToDate(selectedDate.addingTimeInterval(-24*60*60)))
                
                Text(dateFormatter.string(from: selectedDate))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .frame(maxWidth: .infinity)
                
                Button(action: { moveDate(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: userSettings.textSize.size))
                }
                .disabled(!canNavigateToDate(selectedDate.addingTimeInterval(24*60*60)))
            }
            
            // Premium limitation notice for Free users
            if !premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text(NSLocalizedString("Free users can view up to 7 days of nutrition history. Upgrade for extended access.", comment: ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(NSLocalizedString("Upgrade", comment: "")) {
                        showingPremiumUpgrade = true
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Daily summary section
    private var dailySummarySection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Daily Summary", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("Calories", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                    Text("\(Int(totalNutrition.calories))/\(Int(goals.dailyCalories))")
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: totalNutrition.calories / goals.dailyCalories,
                    color: .blue
                )
                .frame(width: 50, height: 50)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Macronutrient section
    private var macronutrientSection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Macronutrients", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            VStack(spacing: 10) {
                nutrientProgressBar(
                    name: NSLocalizedString("Protein", comment: ""),
                    current: totalNutrition.protein,
                    goal: goals.dailyProtein,
                    unit: "g",
                    color: .blue
                )
                
                nutrientProgressBar(
                    name: NSLocalizedString("Carbs", comment: ""),
                    current: totalNutrition.carbohydrates,
                    goal: goals.dailyCarbohydrates,
                    unit: "g",
                    color: .green
                )
                
                nutrientProgressBar(
                    name: NSLocalizedString("Fat", comment: ""),
                    current: totalNutrition.fat,
                    goal: goals.dailyFat,
                    unit: "g",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Vitamin progress section
    private var vitaminProgressSection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Vitamins", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                vitaminProgressItem(
                    name: NSLocalizedString("Vitamin D", comment: ""),
                    current: totalNutrition.vitaminD,
                    goal: goals.dailyVitaminD,
                    unit: "IU",
                    color: .yellow
                )
                
                vitaminProgressItem(
                    name: NSLocalizedString("Vitamin C", comment: ""),
                    current: totalNutrition.vitaminC,
                    goal: goals.dailyVitaminC,
                    unit: "mg",
                    color: .orange
                )
                
                vitaminProgressItem(
                    name: NSLocalizedString("Vitamin B12", comment: ""),
                    current: totalNutrition.vitaminB12,
                    goal: goals.dailyVitaminB12,
                    unit: "mcg",
                    color: .blue
                )
                
                vitaminProgressItem(
                    name: NSLocalizedString("Folate", comment: ""),
                    current: totalNutrition.folate,
                    goal: goals.dailyFolate,
                    unit: "mcg",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Mineral progress section
    private var mineralProgressSection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Minerals", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                mineralProgressItem(
                    name: NSLocalizedString("Calcium", comment: ""),
                    current: totalNutrition.calcium,
                    goal: goals.dailyCalcium,
                    unit: "mg",
                    color: .gray
                )
                
                mineralProgressItem(
                    name: NSLocalizedString("Iron", comment: ""),
                    current: totalNutrition.iron,
                    goal: goals.dailyIron,
                    unit: "mg",
                    color: .red
                )
                
                mineralProgressItem(
                    name: NSLocalizedString("Magnesium", comment: ""),
                    current: totalNutrition.magnesium,
                    goal: goals.dailyMagnesium,
                    unit: "mg",
                    color: .green
                )
                
                mineralProgressItem(
                    name: NSLocalizedString("Zinc", comment: ""),
                    current: totalNutrition.zinc,
                    goal: goals.dailyZinc,
                    unit: "mg",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // MARK: - Data Structures and Computed Properties
    
    // Nutrition data point for charts
    struct NutritionDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let calories: Double
        let protein: Double
        let carbohydrates: Double
        let fat: Double
        let vitaminC: Double
        let vitaminD: Double
        let calcium: Double
        let iron: Double
    }
    
    // Computed property to get nutrition data points for the selected time range
    private var nutritionDataPoints: [NutritionDataPoint] {
        let now = Date()
        let calendar = Calendar.current
        let filterDate: Date
        
        // Apply premium limitations
        let effectiveTimeRange = premiumManager.hasAccess(to: PremiumFeature.extendedHistory) ? timeRange : .week
        
        switch effectiveTimeRange {
        case .week:
            filterDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            filterDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .threeMonths:
            filterDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        }
        
        // Generate data points for each day in the range
        var dataPoints: [NutritionDataPoint] = []
        var currentDate = filterDate
        
        while currentDate <= now {
            let dayStart = calendar.startOfDay(for: currentDate)
            let totalNutrition = mealManager.totalNutritionForDate(dayStart)
            
            let dataPoint = NutritionDataPoint(
                date: dayStart,
                calories: totalNutrition.calories,
                protein: totalNutrition.protein,
                carbohydrates: totalNutrition.carbohydrates,
                fat: totalNutrition.fat,
                vitaminC: totalNutrition.vitaminC,
                vitaminD: totalNutrition.vitaminD,
                calcium: totalNutrition.calcium,
                iron: totalNutrition.iron
            )
            
            dataPoints.append(dataPoint)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dataPoints
    }
    
    // Computed property for nutrition insights
    private var nutritionInsight: String? {
        guard !nutritionDataPoints.isEmpty else { return nil }
        
        let recentDataPoints = Array(nutritionDataPoints.suffix(7)) // Last 7 days
        let avgCalories = recentDataPoints.reduce(0) { $0 + $1.calories } / Double(recentDataPoints.count)
        let goalCalories = mealManager.nutritionalGoals.dailyCalories
        
        let caloriesDifference = avgCalories - goalCalories
        let percentageDifference = abs(caloriesDifference) / goalCalories * 100
        
        if percentageDifference < 5 {
            return NSLocalizedString("Great job! Your calorie intake is well-balanced and close to your goal.", comment: "Nutrition insight: balanced calories")
        } else if caloriesDifference > 0 {
            return String(format: NSLocalizedString("You're consuming about %.0f calories above your daily goal. Consider adjusting portion sizes or meal choices.", comment: "Nutrition insight: over goal"), caloriesDifference)
        } else {
            return String(format: NSLocalizedString("You're consuming about %.0f calories below your daily goal. Consider adding nutritious snacks or larger portions.", comment: "Nutrition insight: under goal"), abs(caloriesDifference))
        }
    }
    
    // MARK: - Helper Functions
    
    private func moveDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            if canNavigateToDate(newDate) {
                selectedDate = newDate
            }
        }
    }
    
    private func canNavigateToDate(_ date: Date) -> Bool {
        // Always allow navigating to today or future dates
        if date >= Calendar.current.startOfDay(for: Date()) {
            return true
        }
        
        // For past dates, check premium access
        if premiumManager.hasAccess(to: PremiumFeature.extendedHistory) {
            return true
        }
        
        // Free users can only go back 7 days
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return date >= Calendar.current.startOfDay(for: sevenDaysAgo)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private func nutrientProgressBar(name: String, current: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.system(size: userSettings.textSize.size - 2))
                Spacer()
                Text("\(Int(current))/\(Int(goal))\(unit)")
                    .font(.system(size: userSettings.textSize.size - 2))
            }
            
            ProgressView(value: current, total: goal)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
    
    private func vitaminProgressItem(name: String, current: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name)
                .font(.system(size: userSettings.textSize.size - 2))
            
            Text("\(Int(current))/\(Int(goal))\(unit)")
                .font(.system(size: userSettings.textSize.size - 2))
            
            CircularProgressView(progress: current / goal, color: color)
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func mineralProgressItem(name: String, current: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name)
                .font(.system(size: userSettings.textSize.size - 2))
            
            Text("\(Int(current))/\(Int(goal))\(unit)")
                .font(.system(size: userSettings.textSize.size - 2))
            
            CircularProgressView(progress: current / goal, color: color)
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Supporting Views

// Legend item for charts
struct LegendItem: View {
    var color: Color
    var label: String
    var isDashed: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            if isDashed {
                Rectangle()
                    .fill(color)
                    .frame(width: 15, height: 2)
                    .overlay(
                        Rectangle()
                            .stroke(color, style: StrokeStyle(lineWidth: 1, dash: [3]))
                    )
            } else {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// Circular progress view (if not already defined elsewhere)
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
    }
}

// TimeRange enum (if not already defined elsewhere)
 