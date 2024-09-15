//
//  PastTripsView.swift
//  TripPlanner3
//
//  Created by stlp on 9/14/24.
//

// PastTripsView.swift
import SwiftUI

struct PastTripsView: View {
    let gradientStartColor = Color(UIColor(red: 141/255, green: 172/255, blue: 225/255, alpha: 1))
    let gradientEndColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
    
    @State private var selectedTab: Tab = .pastTrips // Manage the active tab state

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Blue Gradient Box at the Top
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 300)
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack {
                        Spacer().frame(height: 70)  // Adjust spacing to align title

                        // Title inside the gradient box
                        Text("Past Trips")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 30) // Adjusted padding for better alignment
                    }
                }

                // Content Section Below the Gradient
                VStack(spacing: 20) {
                    Text("Recent Trips")
                        .font(.headline)
                        .padding(.top, 20)
                        .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1))) // Adjust label color

                    List {
                        Section(header: Text("Recent Trips")) {
                            Text("Trip to Paris - 2024")
                            Text("Trip to New York - 2023")
                            Text("Trip to Tokyo - 2022")
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(height: 300) // Adjust list height as needed
                }
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)

                Spacer()

                // Tab Bar
                VStack {
                    Spacer()  // Pushes the tab bar to the bottom

                    HStack {
                        Spacer()
                        TabBarItem(iconName: "briefcase", label: "Past Trips", isSelected: selectedTab == .pastTrips) {
                            selectedTab = .pastTrips
                        }
                        Spacer()
                        TabBarItem(iconName: "globe", label: "Plan Trip", isSelected: selectedTab == .planTrip) {
                            selectedTab = .planTrip
                        }
                        Spacer()
                        TabBarItem(iconName: "person.fill", label: "Profile", isSelected: selectedTab == .profile) {
                            selectedTab = .profile
                        }
                        Spacer()
                        TabBarItem(iconName: "gearshape", label: "Settings", isSelected: selectedTab == .settings) {
                            selectedTab = .settings
                        }
                        Spacer()
                    }
                    .frame(height: 72)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.bottom, 0)  // Ensure it is touching the bottom edge
                }
                .edgesIgnoringSafeArea(.bottom)  // Ensure the tab bar extends to the bottom and touches it
            }
            .navigationBarTitleDisplayMode(.inline) // Keeps the navigation title style consistent
            .navigationBarHidden(true) // Hide navigation bar in this view to show only the gradient title

            // Conditionally switch views based on selected tab
            if selectedTab == .planTrip {
                SecondView()  // Show Plan Trip page (SecondView)
            } else if selectedTab == .profile {
                ProfileView()  // Show Profile page
            } else if selectedTab == .settings {
                SettingsView()  // Show Settings page
            }
        }
    }

    // Tab Bar Item View
    private func TabBarItem(iconName: String, label: String, isSelected: Bool = false, action: @escaping () -> Void) -> some View {
        VStack {
            Image(systemName: iconName)
                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
        }
        .padding(.vertical, 10)
        .background(isSelected ? gradientEndColor.opacity(0.2) : Color.clear)  // Highlight background if selected
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
    }
}

// Enum to manage different tabs
enum Tab {
    case pastTrips
    case planTrip
    case profile
    case settings
}
