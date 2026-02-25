import Foundation

struct ServerEndpoint: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var host: String
    var port: Int
    var username: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String, host: String, port: Int = 22, username: String = "root", createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.host = host
        self.port = port
        self.username = username
        self.createdAt = createdAt
    }
}
