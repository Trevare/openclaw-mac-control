import SwiftUI

struct ProfilesView: View {
    @StateObject private var vm = ProfilesViewModel()
    @State private var showAdd = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("OpenAI Profiles")
                    .font(.title3).bold()
                Spacer()
                Button("Add profile") { showAdd = true }
            }

            Text("Алиас и метаданные хранятся локально, токены — в Keychain")
                .foregroundColor(.secondary)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red)
            }

            List {
                ForEach(vm.profiles) { profile in
                    ProfileRow(profile: profile, hasToken: vm.hasToken(profile: profile)) {
                        vm.delete(profile)
                    }
                }
            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $showAdd) {
            AddProfileSheet { alias, emailHint, note, token in
                vm.add(alias: alias, emailHint: emailHint, note: note, token: token)
            }
        }
        .padding()
    }
}

private struct ProfileRow: View {
    let profile: OpenAIProfile
    let hasToken: Bool
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.alias).font(.headline)
                if !profile.emailHint.isEmpty {
                    Text(profile.emailHint).font(.subheadline).foregroundColor(.secondary)
                }
                if !profile.note.isEmpty {
                    Text(profile.note).font(.subheadline)
                }
                Text(hasToken ? "Token: saved" : "Token: missing")
                    .font(.caption)
                    .foregroundColor(hasToken ? .green : .orange)
            }
            Spacer()
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}

private struct AddProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var alias = ""
    @State private var emailHint = ""
    @State private var note = ""
    @State private var token = ""

    let onSave: (String, String, String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Alias (например: OA-1)", text: $alias)
                TextField("Email hint", text: $emailHint)
                TextField("Note", text: $note)
                SecureField("OpenAI token / secret", text: $token)
            }
            .navigationTitle("New OpenAI profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(alias, emailHint, note, token)
                        dismiss()
                    }
                    .disabled(alias.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || token.isEmpty)
                }
            }
        }
        .frame(minWidth: 520, minHeight: 320)
    }
}
