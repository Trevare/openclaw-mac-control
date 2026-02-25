import Foundation

final class ServersStore {
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = base.appendingPathComponent("OpenClawControl", isDirectory: true)
        try? fileManager.createDirectory(at: appDir, withIntermediateDirectories: true)
        self.fileURL = appDir.appendingPathComponent("servers.json")
    }

    func load() -> [ServerEndpoint] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([ServerEndpoint].self, from: data)) ?? []
    }

    func save(_ servers: [ServerEndpoint]) {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? enc.encode(servers) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}
