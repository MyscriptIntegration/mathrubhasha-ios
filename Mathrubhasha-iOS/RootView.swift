import SwiftUI

struct RootView: View {
    @StateObject private var auth = AuthManager()

    var body: some View {
        Group {
            if let user = auth.user {
                if user.isEmailVerified {
                    HomeView()
                } else {
                    VerifyEmailView()
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(auth)
    }
}

#Preview {
    RootView()
}
