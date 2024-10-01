//
//  DayActivityView.swift
//  TripPlanner
//
//  Created by Sruthi Padisetty on 9/12/24.
//

import SwiftUI

// displayed when user clicks on a day from itinerary view
struct DayActivityView: View {
    var location: String  // name of location (city, country)
    var dayActivities: DayActivities  // activities for the specific day

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Header Section with Location and Day
                VStack(alignment: .leading) {
                    // Display the city, country
                    Text(location)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.top, 30)

                    // display the day number below the location
                    Text("Day \(dayActivities.day)")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Left align the whole VStack
                .padding(.leading, 20) // Add padding for a better left alignment appearance
                .padding(.bottom, 20)
                
                // Display the day number centered above the summary
                Text("Day \(dayActivities.day)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.teal)  // teal
                    .padding(.bottom, 10)

                // Display the day's summary at the top
                Text(dayActivities.summary)
                    .font(.headline)
                    .padding(.horizontal, 20)

                // iterate through the locations the user will visit in a day
                // has index for numbering
                ForEach(Array(dayActivities.locations.enumerated()), id: \.element.id) { index, locationActivity in
                    VStack(alignment: .leading) {
                        // Display the location name with numbering and in a teal color
                        Text("\(index + 1)) \(locationActivity.location)")
                            .font(.title2)
                            .foregroundColor(.teal) // teal
                            .bold()
                            .padding(.bottom, 5)
                        
                            .lineLimit(1) // Try to keep it on one line
                            .minimumScaleFactor(0.8) // Adjust the text scale if needed to fit in one line

                        // Display the address of the location
                        Text(locationActivity.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)

                        // Check if an image URL exists and display it
                        if let imageUrl = locationActivity.imageUrl, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)  // lets image take the maximum available width
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    Image(systemName: "photo")
                                }
                            }
                            .padding(.bottom, 20)
                        }

                        // displays the detailed description for the location under the image
                        Text(locationActivity.description)
                            .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 20) // aligns content with header text
                    .padding(.bottom, 20)
                }
                Spacer()
            }
        }
    }
}

