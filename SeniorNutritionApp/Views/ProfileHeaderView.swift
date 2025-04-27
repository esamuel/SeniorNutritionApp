import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(userSettings.userProfile?.fullName ?? userSettings.userName)
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                // Calculate age from date of birth
                if let dateOfBirth = userSettings.userProfile?.dateOfBirth {
                    let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
                    Text("Age: \(age) years")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.green)
                }
                
                if let gender = userSettings.userProfile?.gender {
                    Text(gender)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.purple)
                }
            }
            .padding(.leading, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
        )
        .padding(.vertical, 10)
    }
} 