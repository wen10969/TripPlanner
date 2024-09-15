//
//  DayActivityView.swift
//  TripPlanner
//
//  Created by Sruthi Padisetty on 9/12/24.
//


import SwiftUI

struct DayActivityView: View {
    var day: Int
    @ObservedObject var planController: PlanController
    
    var body: some View {
        VStack {
            if planController.locationActivities.count >= day {
                let activity = planController.locationActivities[day - 1]
                
                Text(activity.location)
                    .font(.title)
                    .padding(.bottom, 10)
                
                // Check if an image URL exists and display it
                if let imageUrl = activity.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            Image(systemName: "photo")
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // Display the activities for the day
                ForEach(activity.activities, id: \.self) { activity in
                    Text("- \(activity)")
                        .padding(.vertical, 2)
                }
            } else {
                Text("No activities found for this day.")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Day \(day) Activities")
    }
}
