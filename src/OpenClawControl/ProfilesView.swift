import SwiftUI

struct ProfilesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OpenAI Profiles")
                .font(.title3).bold()
            Text("MVP: profile list + secure token storage in Keychain")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}
