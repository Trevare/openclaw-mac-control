import Foundation
import Combine

@MainActor
final class ServersViewModel: ObservableObject {
    @Published var servers: [ServerEndpoint] = []
    @Published var sessions: [ServerAuthSession] = []
    @Published var errorMessage: String?

    private let serversStore = ServersStore()
    private let authStore = ServerAuthStore()
    private let keychain = KeychainService.shared
    private let pwdService = "openclaw.mac.control.server.password"

    init() {
        servers = serversStore.load().sorted { $0.createdAt > $1.createdAt }
        sessions = authStore.load().sorted { $0.updatedAt > $1.updatedAt }
    }

    func addServer(name: String, host: String, port: Int, username: String, password: String) {
        guard !host.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let item = ServerEndpoint(name: name.isEmpty ? host : name, host: host, port: port, username: username)
        do {
            try keychain.save(service: pwdService, account: item.id.uuidString, value: password)
            servers.insert(item, at: 0)
            persistServers()
        } catch {
            errorMessage = "Не удалось сохранить пароль сервера в Keychain"
        }
    }

    func deleteServer(_ server: ServerEndpoint) {
        servers.removeAll { $0.id == server.id }
        sessions.removeAll { $0.serverId == server.id }
        keychain.delete(service: pwdService, account: server.id.uuidString)
        persistServers()
        persistSessions()
    }

    func passwordSaved(for server: ServerEndpoint) -> Bool {
        keychain.load(service: pwdService, account: server.id.uuidString) != nil
    }

    func startAuth(server: ServerEndpoint, alias: String) {
        guard !alias.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let command = "ssh \(server.username)@\(server.host) -p \(server.port) 'openclaw models auth login --provider openai-codex'"
        var s = ServerAuthSession(serverId: server.id, accountAlias: alias, challenge: command, state: .awaitingResponse)
        s.updatedAt = .now
        sessions.insert(s, at: 0)
        persistSessions()
    }

    func completeAuth(session: ServerAuthSession, response: String) {
        guard let idx = sessions.firstIndex(where: { $0.id == session.id }) else { return }
        guard let server = servers.first(where: { $0.id == session.serverId }) else { return }
        guard !response.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Вставь ответную строку от OpenAI"
            return
        }

        sessions[idx].response = response
        sessions[idx].state = .completed
        sessions[idx].updatedAt = .now

        do {
            try OpenAIProfileProvisioner.provision(alias: session.accountAlias, serverHost: server.host, tokenLikeResponse: response)
        } catch {
            sessions[idx].state = .failed
            errorMessage = "Не удалось сохранить профиль OpenAI"
        }
        persistSessions()
    }

    private func persistServers() { serversStore.save(servers) }
    private func persistSessions() { authStore.save(sessions) }
}
