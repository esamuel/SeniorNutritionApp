// TipRowView reusable UI component
import SwiftUI

struct TipRowView: View {
    let icon: String?
    let title: String
    let description: String?
    let textSize: CGFloat
    var iconColor: Color = .green

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 20)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: textSize, weight: .medium))
                    .foregroundColor(.primary)
                if let description = description {
                    Text(description)
                        .font(.system(size: textSize - 2))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

#if DEBUG
struct TipRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TipRowView(icon: "drop.fill", title: "Stay Hydrated", description: "Drink water regularly during the day", textSize: 18)
            TipRowView(icon: nil, title: "Protein is Essential", description: "Aim for 1-1.2g per kg body weight", textSize: 18)
        }
        .padding()
    }
}
#endif 