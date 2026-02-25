import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ConnectionView()
                .tabItem { Label("Server", systemImage: "server.rack") }
            ProfilesView()
                .tabItem { Label("OpenAI", systemImage: "key") }
            RestoreWizardView()
                .tabItem { Label("Restore", systemImage: "arrow.triangle.2.circlepath") }
        }
        .frame(minWidth: 900, minHeight: 560)
    }
}
