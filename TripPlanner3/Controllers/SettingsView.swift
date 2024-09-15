//
//  SettingsView.swift
//  TripPlanner3
//
//  Created by stlp on 9/14/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: ChangePasswordView()) {
                    Text("Change Password")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: logout) {
                    Text("Logout")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()

                // Tab Bar
                HStack {
                    Spacer()
                    TabBarItem(iconName: "briefcase", label: "Past Trips")
                    Spacer()
                    TabBarItem(iconName: "globe", label: "Plan Trip")
                    Spacer()
                    TabBarItem(iconName: "person", label: "Profile")
                    Spacer()
                    TabBarItem(iconName: "gearshape", label: "Settings", isSelected: true)  // Highlight settings icon
                    Spacer()
                }
                .padding(.bottom)
                .background(Color(.white))
                .cornerRadius(8)
                .shadow(radius: 5)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back")
            })
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            if let window = UIApplication.shared.windows.first {
                // Directly use UIViewController for LoginController
                let navController = UINavigationController(rootViewController: LoginController())
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func TabBarItem(iconName: String, label: String, isSelected: Bool = false) -> some View {
        VStack {
            Image(systemName: iconName)
                .foregroundColor(isSelected ? Color.blue : .gray)
            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? Color.blue : .gray)
        }
        .padding(.vertical, 10)
        .onTapGesture {
            switch label {
            case "Past Trips":
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: PastTripsView())
                    window.makeKeyAndVisible()
                }
            case "Plan Trip":
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: SecondView())
                    window.makeKeyAndVisible()
                }
            case "Profile":
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: ProfileView())
                    window.makeKeyAndVisible()
                }
            default:
                break
            }
        }
    }
}
