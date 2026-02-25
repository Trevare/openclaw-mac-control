import Foundation

enum AuthState: String, Codable {
    case idle
    case awaitingResponse
    case completed
    case failed
}

struct ServerAuthSession: Identifiable, Codable, Equatable {
    let id: UUID
    var serverId: UUID
    var accountAlias: String
    var challenge: String
    var response: String
    var state: AuthState
    var updatedAt: Date

    init(id: UUID = UUID(), serverId: UUID, accountAlias: String, challenge: String = "", response: String = "", state: AuthState = .idle, updatedAt: Date = .now) {
        self.id = id
        self.serverId = serverId
        self.accountAlias = accountAlias
        self.challenge = challenge
        self.response = response
        self.state = state
        self.updatedAt = updatedAt
    }
}
