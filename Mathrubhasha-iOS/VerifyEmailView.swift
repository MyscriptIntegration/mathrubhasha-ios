import SwiftUI

struct VerifyEmailView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var isRefreshing = false
    @State private var isSending = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Verify your email")
                .font(.title)
                .bold()

            Text("We sent a verification link to your email. Verify it, then come back and tap ‘I Verified’.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            if let email = auth.user?.email {
                Text(email)
                    .font(.callout)
                    .bold()
            }

            if let msg = auth.errorMessage {
                Text(msg)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button(isSending ? "Sending..." : "Resend email") {
                Task {
                    isSending = true
                    await auth.resendVerificationEmail()
                    isSending = false
                }
            }
            .disabled(isSending)

            Button(isRefreshing ? "Checking..." : "I Verified") {
                Task {
                    isRefreshing = true
                    await auth.refreshUser()
                    isRefreshing = false
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isRefreshing)

            Button("Sign out") {
                auth.signOut()
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    VerifyEmailView()
        .environmentObject(AuthManager())
}
