//
//  PastTripsView.swift
//  TripPlanner3
//
//  Created by stlp on 9/14/24.
//

import Foundation
import SwiftUI

struct PastTripsView: View {
    @State private var selectedTab: Tab = .pastTrips

    var body: some View {
        VStack(spacing: 0) {
            if selectedTab == .pastTrips {
                VStack {
                    Text("Past Trips")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    // Placeholder content for past trips list
                    List {
                        Section(header: Text("Recent Trips")) {
                            Text("Trip to Paris - 2024")
                            Text("Trip to New York - 2023")
                            Text("Trip to Tokyo - 2022")
                        }
                    }
                    .listStyle(InsetGroupedListStyle())

                    Spacer()
                }
            } else if selectedTab == .planTrip {
                SecondView()
            } else if selectedTab == .profile {
                ProfileView()
            } else if selectedTab == .settings {
                SettingsView()
            }

            // Custom Tab Bar at the bottom
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
                TabBarItem(iconName: "person", label: "Profile", isSelected: selectedTab == .profile) {
                    selectedTab = .profile
                }
                Spacer()
                TabBarItem(iconName: "gearshape", label: "Settings", isSelected: selectedTab == .settings) {
                    selectedTab = .settings
                }
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.bottom, 8)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Tab Enum to manage different views
enum Tab {
    case pastTrips
    case planTrip
    case profile
    case settings
}

struct TabBarItem: View {
    var iconName: String
    var label: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .foregroundColor(isSelected ? Color.cyan : Color.blue)
            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? Color.cyan : Color.blue)
        }
        .padding(.vertical, 10)
        .onTapGesture {
            action()
        }
    }
}

struct PastTripsView_Previews: PreviewProvider {
    static var previews: some View {
        PastTripsView()
    }
}
