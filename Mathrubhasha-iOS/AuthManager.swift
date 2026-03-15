import Foundation
import FirebaseAuth

@MainActor
final class AuthManager: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var errorMessage: String?

    private var authHandle: AuthStateDidChangeListenerHandle?

    init() {
        authHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signIn(email: String, password: String) async {
        errorMessage = nil
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        errorMessage = nil
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            if let user = Auth.auth().currentUser, !user.isEmailVerified {
                try await user.sendEmailVerification()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resendVerificationEmail() async {
        errorMessage = nil
        do {
            guard let user = Auth.auth().currentUser else { return }
            try await user.sendEmailVerification()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshUser() async {
        errorMessage = nil
        do {
            guard let user = Auth.auth().currentUser else { return }
            try await user.reload()
            self.user = Auth.auth().currentUser
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        errorMessage = nil
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
