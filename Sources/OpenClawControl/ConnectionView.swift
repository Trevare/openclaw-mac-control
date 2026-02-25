import SwiftUI

struct ConnectionView: View {
    @StateObject private var vm = ServersViewModel()

    @State private var showAddServer = false
    @State private var selectedServer: ServerEndpoint?
    @State private var alias = "OA-1"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Servers & OpenAI Auth")
                    .font(.title3).bold()
                Spacer()
                Button("Add server") { showAddServer = true }
            }

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red)
            }

            HStack(alignment: .top, spacing: 16) {
                GroupBox("Servers") {
                    List {
                        ForEach(vm.servers) { server in
                            Button {
                                selectedServer = server
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(server.name).font(.headline)
                                        Text("\(server.username)@\(server.host):\(server.port)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: vm.passwordSaved(for: server) ? "lock.fill" : "lock.open")
                                        .foregroundColor(vm.passwordSaved(for: server) ? .green : .orange)
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    vm.deleteServer(server)
                                    if selectedServer?.id == server.id { selectedServer = nil }
                                } label: { Text("Delete") }
                            }
                        }
                    }
                    .frame(minWidth: 360, minHeight: 280)
                }

                GroupBox("Auth flow") {
                    VStack(alignment: .leading, spacing: 10) {
                        if let server = selectedServer {
                            Text("Selected: \(server.name)")
                                .font(.headline)
                            Text("1) Нажми Start auth\n2) Выполни команду на сервере\n3) Вставь ответную строку")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            HStack {
                                TextField("Account alias (OA-1...)", text: $alias)
                                Button("Start auth") {
                                    vm.startAuth(server: server, alias: alias)
                                }
                            }
                        } else {
                            Text("Сначала выбери сервер слева")
                                .foregroundColor(.secondary)
                        }

                        Divider()
                        Text("Sessions")
                            .font(.headline)

                        List {
                            ForEach(vm.sessions) { session in
                                AuthSessionRow(session: session, onComplete: { response in
                                    vm.completeAuth(session: session, response: response)
                                })
                            }
                        }
                        .frame(minWidth: 460, minHeight: 280)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddServer) {
            AddServerSheet { name, host, port, username, password in
                vm.addServer(name: name, host: host, port: port, username: username, password: password)
            }
        }
        .padding()
    }
}

private struct AuthSessionRow: View {
    let session: ServerAuthSession
    let onComplete: (String) -> Void
    @State private var response: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.accountAlias).font(.headline)
                Spacer()
                Text(session.state.rawValue).font(.caption)
                    .foregroundColor(session.state == .completed ? .green : .secondary)
            }

            if !session.challenge.isEmpty {
                Text(session.challenge)
                    .font(.caption)
                    .textSelection(.enabled)
                    .padding(8)
                    .background(Color.gray.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            if session.state == .awaitingResponse || session.state == .failed {
                HStack {
                    TextField("Paste OpenAI response/token", text: $response)
                    Button("Save") { onComplete(response) }
                }
            } else if session.state == .completed {
                Text("Saved")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct AddServerSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var host = ""
    @State private var port = 22
    @State private var username = "root"
    @State private var password = ""

    let onSave: (String, String, Int, String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Server name", text: $name)
                TextField("IP / Host", text: $host)
                Stepper("Port: \(port)", value: $port, in: 1...65535)
                TextField("Login", text: $username)
                SecureField("Password", text: $password)
            }
            .navigationTitle("Add server")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(name, host, port, username, password)
                        dismiss()
                    }
                    .disabled(host.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty)
                }
            }
        }
        .frame(minWidth: 560, minHeight: 360)
    }
}
