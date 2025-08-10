import SwiftUI

struct HealthTipsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var selectedCategory: HealthTipCategory? = nil
    @State private var searchText = ""
    @State private var refreshTrigger = false // Add this to force view refresh
    let healthTipsService = HealthTipsService.shared
    
    private var citationCategories: [CitationCategory] {
        if let category = selectedCategory {
            switch category {
            case .general:
                return [.seniorHealth]
            case .nutrition:
                return [.nutrition]
            case .fasting:
                return [.fasting]
            case .hydration:
                return [.hydration]
            case .activity:
                return [.seniorHealth]
            case .medication:
                return [.medication]
            case .seniorSpecific:
                return [.seniorHealth]
            }
        } else {
            return CitationCategory.allCases
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Doctor Note Banner
                HStack {
                    Image(systemName: "stethoscope")
                        .foregroundColor(.blue)
                    Text("Health tips are for educational purposes only. Always consult your doctor before making changes to your health routine.")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(Color.blue.opacity(0.08))
                .cornerRadius(12)
                .padding([.top, .horizontal])
                
                // Category selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(
                            title: NSLocalizedString("All", comment: "All health tips category"),
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(HealthTipCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.localizedName,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))
                
                Divider()
                
                // Tips list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTips) { tip in
                            HealthTipView(tip: tip)
                                .padding(.horizontal)
                        }
                        
                        // Add citations section
                        CitationsView(categories: citationCategories)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(NSLocalizedString("Health Tips", comment: "Health tips screen title"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: NSLocalizedString("Search health tips", comment: "Search placeholder for health tips"))
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageDidChange"))) { _ in
            // Force view refresh when language changes
            refreshTrigger.toggle()
        }
    }
    
    // Filter tips based on selected category and search text
    private var filteredTips: [HealthTip] {
        var tips = selectedCategory != nil ?
            healthTipsService.getTips(for: selectedCategory!) :
            healthTipsService.allTips
        
        if !searchText.isEmpty {
            tips = tips.filter {
                $0.localizedTitle.localizedCaseInsensitiveContains(searchText) ||
                $0.localizedDescription.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return tips
    }
}

// Category selection button
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.accentColor : Color(.systemGray5))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

// Preview provider for SwiftUI canvas
struct HealthTipsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthTipsView()
    }
} 