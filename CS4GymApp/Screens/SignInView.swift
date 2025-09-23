
import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var showSignUp: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon + Title
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBlue).opacity(0.12))
                                .frame(width: 92, height: 92)
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        Text("FitTracker")
                            .font(.system(.title, design: .rounded).weight(.semibold))
                    }
                    .padding(.top, 40)
                    
                    // Card
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome Back")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color(.label))
                            Text("Sign in to continue your training")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email").font(.subheadline).foregroundColor(.secondary)
                            HStack(spacing: 10) {
                                Image(systemName: "envelope")
                                    .foregroundColor(.secondary)
                                TextField("Enter your email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password").font(.subheadline).foregroundColor(.secondary)
                            HStack(spacing: 10) {
                                Image(systemName: "lock")
                                    .foregroundColor(.secondary)
                                Group {
                                    if isPasswordVisible {
                                        TextField("Enter your password", text: $password)
                                    } else {
                                        SecureField("Enter your password", text: $password)
                                    }
                                }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.secondary)
                                }
                                .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
                        }
                        
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {}
                                .font(.subheadline)
                        }
                        
                        // Sign In button
                        Button(action: signIn) {
                            HStack {
                                if isSigningIn { ProgressView().tint(.white) }
                                Text("Sign In")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isSignInDisabled ? Color.blue.opacity(0.5) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(isSignInDisabled)
                        
                        // Separator
                        HStack(spacing: 12) {
                            Rectangle().fill(Color(.systemGray4)).frame(height: 1)
                            Text("OR").font(.footnote).foregroundColor(.secondary)
                            Rectangle().fill(Color(.systemGray4)).frame(height: 1)
                        }
                        
                        // Google button (stub)
                        Button(action: continueWithGoogle) {
                            HStack(spacing: 10) {
                                Image(systemName: "g.circle")
                                    .foregroundColor(.red)
                                    .font(.title3)
                                Text("Continue with Google")
                                    .foregroundColor(Color(.label))
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4))
                            )
                        }
                        
                        HStack(spacing: 4) {
                            Text("Don't have an account?").foregroundColor(.secondary)
                            Button("Sign Up") { showSignUp.toggle() }
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 8)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: 560)
                .padding(.vertical, 16)
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    private var isSignInDisabled: Bool {
        email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty || isSigningIn
    }
    
    private func signIn() {
        guard !isSignInDisabled else { return }
        isSigningIn = true
        // Simulate async sign-in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isSigningIn = false
            let savedName = UserDefaults.standard.string(forKey: "displayName")?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let name = savedName, !name.isEmpty {
                NotificationCenter.default.post(name: Notification.Name("didSignIn"), object: nil)
            } else {
                showSignUp = true
            }
        }
    }
    
    private func continueWithGoogle() {
        // Stub for Google sign-in
    }
}

#Preview {
    SignInView()
}


