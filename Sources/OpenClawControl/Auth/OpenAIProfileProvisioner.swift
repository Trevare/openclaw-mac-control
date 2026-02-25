import Foundation

enum OpenAIProfileProvisioner {
    static func provision(alias: String, serverHost: String, tokenLikeResponse: String) throws {
        let profileStore = ProfilesStore()
        let keychain = KeychainService.shared
        let keychainService = "openclaw.mac.control.openai"

        var profiles = profileStore.load()
        let profile = OpenAIProfile(alias: alias, emailHint: "", note: "Server: \(serverHost)")
        profiles.insert(profile, at: 0)
        profileStore.save(profiles)
        try keychain.save(service: keychainService, account: profile.id.uuidString, value: tokenLikeResponse)
    }
}
