import SwiftUI

struct HelpSection: View {
    @EnvironmentObject private var userSettings: UserSettings
    let title: String
    let content: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        
                        Text(item)
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct HelpSectionHeader: View {
    @EnvironmentObject private var userSettings: UserSettings
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            .foregroundColor(.primary)
    }
}

struct HelpStepView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let step: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(step)
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .frame(width: 30, height: 30)
                .background(Color.accentColor.opacity(0.2))
                .foregroundColor(.accentColor)
                .clipShape(Circle())
            
            Text(description)
                .font(.system(size: userSettings.textSize.size))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct HelpTipView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let tip: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .frame(width: 30, height: 30)
                .foregroundColor(.yellow)
            
            Text(tip)
                .font(.system(size: userSettings.textSize.size))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct HelpInfoView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                Text(description)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
