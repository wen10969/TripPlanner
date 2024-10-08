//
//  ChangePasswordView.swift
//  TripPlanner3
//
//  Created by stlp on 9/14/24.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Change Password")
                .font(.largeTitle)
                .padding()

            SecureField("Current Password", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Confirm New Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: changePassword) {
                Text("Update Password")
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
        .navigationTitle("Change Password")  // Use the default navigation title
        .navigationBarTitleDisplayMode(.inline)  // Ensure the title is inline for consistency
    }

    private func changePassword() {
        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match."
            return
        }

        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not authenticated."
            return
        }

        // Re-authenticate the user with the current password
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
                return
            }

            // Update to new password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                } else {
                    errorMessage = "Password updated successfully!"
                }
            }
        }
    }
}
