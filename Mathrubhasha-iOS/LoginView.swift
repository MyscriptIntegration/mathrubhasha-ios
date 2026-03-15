import SwiftUI

enum AuthMode: String, CaseIterable {
    case signIn = "Sign In"
    case signUp = "Sign Up"
}

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var mode: AuthMode = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Mathrubhasha")
                .font(.largeTitle)
                .bold()

            Picker("", selection: $mode) {
                ForEach(AuthMode.allCases, id: \.self) { m in
                    Text(m.rawValue).tag(m)
                }
            }
            .pickerStyle(.segmented)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let msg = auth.errorMessage {
                Text(msg)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    isLoading = true
                    let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    if mode == .signIn {
                        await auth.signIn(email: e, password: password)
                    } else {
                        await auth.signUp(email: e, password: password)
                    }
                    isLoading = false
                }
            } label: {
                Text(isLoading ? "Please wait..." : mode.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading || email.isEmpty || password.isEmpty)

            if mode == .signUp {
                Text("We’ll email you a verification link. You must verify before entering the app.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
