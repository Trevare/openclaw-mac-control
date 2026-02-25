import Foundation

struct OpenAIProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var alias: String
    var emailHint: String
    var note: String
    var createdAt: Date

    init(id: UUID = UUID(), alias: String, emailHint: String = "", note: String = "", createdAt: Date = .now) {
        self.id = id
        self.alias = alias
        self.emailHint = emailHint
        self.note = note
        self.createdAt = createdAt
    }
}
