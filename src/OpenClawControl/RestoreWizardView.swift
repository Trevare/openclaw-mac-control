import SwiftUI

struct RestoreWizardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Restore Wizard")
                .font(.title3).bold()
            Text("Step-by-step восстановление OpenAI-профилей")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}
