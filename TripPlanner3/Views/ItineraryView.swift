//
//  ItineraryView.swift
//  TripPlanner3
//
//  Created by stlp on 9/14/24.
//

import SwiftUI

// For the itinerary page display right after user input
struct ItineraryView: View {
    var location: String  // name of the location
    var days: Int  // number of days for the trip
    @ObservedObject var planController: PlanController

    // height and width of the buttons for each day
    let buttonHeight: CGFloat = 120
    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.85
    
    var body: some View {
        VStack(spacing: 15) {
            // Header Section with Location and Days
            VStack(alignment: .leading) {
                // Location text and align it to the left
                Text(location)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.top, 30)
                
                // Display the number of days below the location
                Text("\(days) Days")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Left align the whole VStack
            .padding(.leading, 20) // Add padding for a better left alignment appearance
            .padding(.bottom, 20)  // bottom padding for spacing
            
            // Day Buttons Section
            ScrollView {
                VStack(spacing: 25) {
                    // loop through activities ny each day
                    ForEach(planController.locationActivitiesByDay) { dayActivities in
                        // screen navigates to DayActivityView when the day button is pressed
                        NavigationLink(
                            destination: DayActivityView(location: location, dayActivities: dayActivities)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    // display the day number on the button
                                    Text("Day \(dayActivities.day)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    // displays extra 'view activites' text but can be changed
                                    Text("View Activities")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 15)
                                
                                Spacer()
                                
                                // right arrow on button
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 15)
                            }
                            // button sizing and color details
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                            // add top padding for the first button only
                            .padding(.top, dayActivities.day == 1 ? 10 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            Spacer()
        }
        
        .onAppear {
            // Only fetch the data once if not already generated
            if !planController.hasGeneratedActivities {
                planController.sendNewMessage(location: location, filter: "Relaxing", days: days)
            }
        }
    }
}

