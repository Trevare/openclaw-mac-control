import Foundation
import Combine

@MainActor
final class RestoreWizardViewModel: ObservableObject {
    @Published var profiles: [OpenAIProfile] = []
    @Published var currentIndex: Int = 0
    @Published var inputToken: String = ""
    @Published var statusMessage: String = ""

    private let store = ProfilesStore()
    private let keychain = KeychainService.shared
    private let keychainService = "openclaw.mac.control.openai"

    init() {
        profiles = store.load().sorted { $0.createdAt > $1.createdAt }
    }

    var currentProfile: OpenAIProfile? {
        guard !profiles.isEmpty, currentIndex >= 0, currentIndex < profiles.count else { return nil }
        return profiles[currentIndex]
    }

    var progressText: String {
        guard !profiles.isEmpty else { return "0 / 0" }
        return "\(currentIndex + 1) / \(profiles.count)"
    }

    func saveAndNext() {
        guard let profile = currentProfile else { return }
        guard !inputToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            statusMessage = "Вставь токен перед сохранением"
            return
        }

        do {
            try keychain.save(service: keychainService, account: profile.id.uuidString, value: inputToken)
            statusMessage = "Сохранено: \(profile.alias)"
            inputToken = ""
            if currentIndex < profiles.count - 1 {
                currentIndex += 1
            }
        } catch {
            statusMessage = "Ошибка сохранения в Keychain"
        }
    }

    func prev() {
        if currentIndex > 0 { currentIndex -= 1 }
    }

    func next() {
        if currentIndex < profiles.count - 1 { currentIndex += 1 }
    }
}
