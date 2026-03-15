import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Home (Individual)")
                    .font(.title)
                    .bold()

                Text(auth.user?.email ?? "")
                    .foregroundColor(.secondary)

                Button("Sign out") {
                    auth.signOut()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Mathrubhasha")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
