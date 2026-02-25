import Foundation
import Combine

@MainActor
final class ProfilesViewModel: ObservableObject {
    @Published var profiles: [OpenAIProfile] = []
    @Published var errorMessage: String?

    private let store = ProfilesStore()
    private let keychain = KeychainService.shared
    private let keychainService = "openclaw.mac.control.openai"

    init() {
        profiles = store.load().sorted { $0.createdAt > $1.createdAt }
    }

    func add(alias: String, emailHint: String, note: String, token: String) {
        guard !alias.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let profile = OpenAIProfile(alias: alias.trimmingCharacters(in: .whitespacesAndNewlines), emailHint: emailHint, note: note)
        do {
            try keychain.save(service: keychainService, account: profile.id.uuidString, value: token)
            profiles.insert(profile, at: 0)
            persist()
        } catch {
            errorMessage = "Не удалось сохранить токен в Keychain"
        }
    }

    func update(_ profile: OpenAIProfile, token: String?) {
        guard let idx = profiles.firstIndex(where: { $0.id == profile.id }) else { return }
        profiles[idx] = profile

        if let token, !token.isEmpty {
            do {
                try keychain.save(service: keychainService, account: profile.id.uuidString, value: token)
            } catch {
                errorMessage = "Не удалось обновить токен в Keychain"
            }
        }
        persist()
    }

    func delete(_ profile: OpenAIProfile) {
        profiles.removeAll { $0.id == profile.id }
        keychain.delete(service: keychainService, account: profile.id.uuidString)
        persist()
    }

    func hasToken(_ profile: OpenAIProfile) -> Bool {
        keychain.load(service: keychainService, account: profile.id.uuidString) != nil
    }

    private func persist() {
        store.save(profiles)
    }
}
