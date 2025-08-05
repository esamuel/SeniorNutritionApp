import SwiftUI

struct HealthTipView: View {
    let tip: HealthTip
    var showIcon: Bool = true
    var compact: Bool = false
    var showCitations: Bool = true
    @State private var showingCitations = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 4 : 8) {
            HStack(spacing: 12) {
                if showIcon {
                    Image(systemName: tip.icon)
                        .font(compact ? .body : .title2)
                        .foregroundColor(.accentColor)
                        .frame(width: compact ? 24 : 32, height: compact ? 24 : 32)
                }
                
                Text(tip.localizedTitle)
                    .font(compact ? .headline : .title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Citations button - required for Apple Review compliance
                if showCitations && !tip.citations.isEmpty {
                    Button(action: {
                        showingCitations = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel("View medical sources")
                }
            }
            
            Text(tip.localizedDescription)
                .font(compact ? .subheadline : .body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(compact ? 2 : nil)
        }
        .padding(compact ? 12 : 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showingCitations) {
            HealthTipCitationsView(citations: tip.citations, tipTitle: tip.localizedTitle)
        }
    }
}

// MARK: - Health Tip Citations View for Apple Review compliance
struct HealthTipCitationsView: View {
    let citations: [MedicalCitation]
    let tipTitle: String
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(NSLocalizedString("Medical sources for health information provided in this tip:", comment: "Citation explanation text"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    ForEach(citations) { citation in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(citation.formattedReference)
                                .font(.footnote)
                                .foregroundColor(.primary)
                            
                            if let url = citation.url {
                                Link(NSLocalizedString("View Source", comment: "Link to view citation source"), destination: URL(string: url)!)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                    Text(NSLocalizedString("health_disclaimer", comment: "Health information disclaimer"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle(NSLocalizedString("Medical Sources", comment: "Navigation title for medical sources"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "Done button")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct HealthTipsCarousel: View {
    let tips: [HealthTip]
    var showHeader: Bool = true
    var compact: Bool = false
    var onViewMoreTapped: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if showHeader {
                HStack {
                    Text(NSLocalizedString("Health Tips", comment: ""))
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if let action = onViewMoreTapped {
                        Button(action: action) {
                            Text(NSLocalizedString("View More", comment: "Button to view more health tips"))
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tips) { tip in
                        HealthTipView(tip: tip, showIcon: true, compact: compact)
                            .frame(width: compact ? 260 : 300)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 4) // Add padding to avoid shadow clipping
            }
        }
    }
}

// Preview provider for SwiftUI canvas
struct HealthTipView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HealthTipView(
                tip: HealthTip(
                    title: "Stay Hydrated",
                    description: "Drink plenty of water during your fast to stay hydrated",
                    category: .fasting,
                    icon: "drop.fill"
                )
            )
            
            HealthTipView(
                tip: HealthTip(
                    title: "Stay Hydrated",
                    description: "Drink plenty of water during your fast to stay hydrated",
                    category: .fasting,
                    icon: "drop.fill"
                ),
                compact: true
            )
            
            HealthTipsCarousel(
                tips: [
                    HealthTip(
                        title: "Stay Hydrated",
                        description: "Drink plenty of water during your fast to stay hydrated",
                        category: .fasting, 
                        icon: "drop.fill"
                    ),
                    HealthTip(
                        title: "Listen to Your Body",
                        description: "If you feel unwell, end your fast immediately",
                        category: .fasting,
                        icon: "ear.fill"
                    )
                ]
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 