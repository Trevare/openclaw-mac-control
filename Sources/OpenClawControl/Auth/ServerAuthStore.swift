import Foundation

final class ServerAuthStore {
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = base.appendingPathComponent("OpenClawControl", isDirectory: true)
        try? fileManager.createDirectory(at: appDir, withIntermediateDirectories: true)
        self.fileURL = appDir.appendingPathComponent("auth_sessions.json")
    }

    func load() -> [ServerAuthSession] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([ServerAuthSession].self, from: data)) ?? []
    }

    func save(_ sessions: [ServerAuthSession]) {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? enc.encode(sessions) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}
