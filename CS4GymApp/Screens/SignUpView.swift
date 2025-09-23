

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var displayName: String = ""
    @State private var isSaving: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("Create Account")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text("What should we call you?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                    
                VStack(alignment: .leading, spacing: 10) {
                    Text("Display Name").font(.subheadline).foregroundColor(.secondary)
                    HStack(spacing: 10) {
                        Image(systemName: "person")
                            .foregroundColor(.secondary)
                        TextField("What should we call you?", text: $displayName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
                }
                .padding(.horizontal, 20)
                
                Button(action: saveAndContinue) {
                    HStack {
                        if isSaving { ProgressView().tint(.white) }
                        Text("Continue")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(isContinueDisabled ? Color.blue.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isContinueDisabled)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
    
    private var isContinueDisabled: Bool {
        displayName.trimmingCharacters(in: .whitespaces).isEmpty || isSaving
    }
    
    private func saveAndContinue() {
        guard !isContinueDisabled else { return }
        isSaving = true
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(trimmed, forKey: "displayName")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isSaving = false
            NotificationCenter.default.post(name: Notification.Name("didSignIn"), object: nil)
            dismiss()
        }
    }
}

#Preview {
    SignUpView()
}


