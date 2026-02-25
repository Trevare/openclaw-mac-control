import SwiftUI

struct ConnectionView: View {
    @State private var host = ""
    @State private var username = "root"
    @State private var password = ""

    var body: some View {
        Form {
            TextField("Server IP / Host", text: $host)
            TextField("Login", text: $username)
            SecureField("Password", text: $password)
            Button("Connect") {
                // TODO: OpenClaw connection check
            }
        }
        .padding()
    }
}
