import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "wrench.and.screwdriver.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            Text("Coming Soon")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("This feature is currently under development.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Feature Not Available")
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceholderView()
        }
    }
}
