import SwiftUI

struct RestoreWizardView: View {
    @StateObject private var vm = RestoreWizardViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Restore Wizard")
                    .font(.title3).bold()
                Spacer()
                Text(vm.progressText)
                    .foregroundColor(.secondary)
            }

            if let profile = vm.currentProfile {
                GroupBox("Текущий профиль") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Alias: \(profile.alias)")
                        if !profile.emailHint.isEmpty {
                            Text("Email: \(profile.emailHint)")
                                .foregroundColor(.secondary)
                        }
                        if !profile.note.isEmpty {
                            Text("Note: \(profile.note)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                SecureField("Вставь токен для этого профиля", text: $vm.inputToken)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("← Назад") { vm.prev() }
                        .disabled(vm.currentIndex == 0)

                    Button("Пропустить →") { vm.next() }
                        .disabled(vm.currentIndex >= vm.profiles.count - 1)

                    Spacer()

                    Button("Сохранить и далее") { vm.saveAndNext() }
                        .buttonStyle(.borderedProminent)
                }
            } else {
                ContentUnavailableView("Нет профилей", systemImage: "key.fill", description: Text("Сначала добавь профили OpenAI во вкладке OpenAI"))
            }

            if !vm.statusMessage.isEmpty {
                Text(vm.statusMessage)
                    .foregroundColor(.green)
            }

            Spacer()
        }
        .padding()
    }
}
