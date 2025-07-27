import SwiftUI

struct CitationsView: View {
    let categories: [CitationCategory]
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var userSettings: UserSettings
    
    private var citations: [Citation] {
        CitationService.shared.getCitations(for: categories)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(NSLocalizedString("Sources & References", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .padding(.bottom, 4)
            
            if citations.isEmpty {
                Text(NSLocalizedString("No citations available for this section.", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            } else {
                ForEach(citations) { citation in
                    CitationRowView(citation: citation)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

struct CitationRowView: View {
    let citation: Citation
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(citation.title)
                .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                .foregroundColor(.primary)
            
            HStack {
                Text(citation.source)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(citation.date)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                if let url = URL(string: citation.url) {
                    openURL(url)
                }
            }) {
                Text(NSLocalizedString("View Source", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CitationsView(categories: [.nutrition, .fasting])
        .environmentObject(UserSettings())
        .padding()
} 