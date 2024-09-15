//
//  ChangeEmailView.swift
//  TripPlanner3
//
//  Created by stlp on 9/14/24.
//
import SwiftUI
import FirebaseAuth

struct ChangeEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPassword: String = ""
    @State private var newEmail: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Change Email")
                .font(.largeTitle)
                .padding()

            SecureField("Current Password", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("New Email", text: $newEmail)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: changeEmail) {
                Text("Update Email")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding(.top)  // To provide padding from top without back button
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Change Email")  // Use the default navigation title
        .navigationBarTitleDisplayMode(.inline)  // Ensure the title is inline for consistency
    }

    private func changeEmail() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not authenticated."
            return
        }

        guard !newEmail.isEmpty else {
            errorMessage = "New email cannot be empty."
            return
        }

        // Re-authenticate the user with the current password
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
                return
            }

            // Update to new email
            user.updateEmail(to: newEmail) { error in
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                } else {
                    errorMessage = "Email updated successfully!"
                }
            }
        }
    }
}
