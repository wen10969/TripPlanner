//
//  ItineraryView.swift
//  TripPlanner
//
//  Created by Sruthi Padisetty on 9/12/24.
//

import SwiftUI

struct ItineraryView: View {
    var location: String
    var days: Int
    @ObservedObject var planController: PlanController

    let buttonHeight: CGFloat = 120
    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        VStack(spacing: 15) {
            // Header Section with Location and Days
            VStack {
                Text(location)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                Text("\(days) Days")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
            
            // Day Buttons Section
            ScrollView {
                VStack(spacing: 25) {
                    ForEach(1...days, id: \.self) { day in
                        NavigationLink(
                            destination: DayActivityView(day: day, planController: planController)) {
                            HStack {
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Day \(day)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("View Activities")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 15)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 15)
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                            .padding(.top, day == 1 ? 10 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            Spacer()
        }
        .navigationBarTitle("Itinerary Page", displayMode: .inline)
        .onAppear {
            // Only fetch the data once when the activities are empty
            if planController.locationActivities.isEmpty {
                planController.sendNewMessage(location: location, filter: "Relaxing", days: days)
            }
        }
    }
}
