//
//  PlanController.swift
//  TripPlanner
//
//  Created by Wen Li on 6/23/24.
//
//  Reference List:
//  How to Use ChatGPT in Swift on Youtube
//  https://www.youtube.com/watch?app=desktop&v=fkg3UzopiHY
//
//  Package Dependencies
//  OpenAI - https://github.com/MacPaw/OpenAI.git

import SwiftUI
import OpenAI


// this class is repsonsible for handling user input, querying the API,
// parsing the responses, and fetching relevant images for each location
class PlanController: ObservableObject {
    @Published var messages: [Message] = []  // array of messages exchanged with the API
    @Published var locationActivities: [LocationActivities] = []  // Activities for each location
    @Published var locationActivitiesByDay: [DayActivities] = []  // activities for each day
    @Published var hasGeneratedActivities: Bool = false  // flag that tracks if activities have been generated
    
    
    // new API key
    private let openAI = OpenAI(apiToken: "temp")

    
    // use the shared instance of ImageController
    private let imageController = ImageController.shared
    
    
    // sends a new message to the API to generate the trips details from user input from SecondView
    func sendNewMessage(location: String, filter: String, days: Int) {
        // query to send to the API
        let queryMessage = """
        Plan a \(days)-day \(filter) trip in \(location). Each day should include several activity locations that are close to each other. Provide the location's name, a detailed description of what the traveler will do at that location, and the location's address. The address can't be in the description. Include useful tips and fun facts. For longer activities, include fewer activity locations for that day. Provide a very descriptive summary of the day's plan at the start in the same order as the locations are listed for each day. Respond in the following JSON format:
        {
          "days": [
            {
              "day": 1,
              "summary": "A very descriptive summary of the day's activities.",
              "locations": [
                {
                  "location": "Location Name 1",
                  "description": "A detailed paragraph describing the activity the traveler will be doing at that location, including any useful tips and fun facts.",
                  "address": "Full address of the location."
                },
                {
                  "location": "Location Name 2",
                  "description": "A detailed paragraph describing the activity the traveler will be doing at that location, including any useful tips and fun facts.",
                  "address": "Full address of the location."
                }
              ]
            },
            ...
          ]
        }
        """
        // making a Message instance to represent the user's query
        let userMessage = Message(content: queryMessage, isUser: true)
        // append the message to the messages array
        self.messages.append(userMessage)
        // call the API to get a reply from the query message that was sent
        getApiReply(for: queryMessage)
    }

    
    
    // request a gpt search result
    func getApiReply(for queryMessage: String) {
        // create a ChatQuery object with the user message and the model to use
        let query = ChatQuery(
            messages: [.init(role: .user, content: queryMessage)!],
            model: .gpt3_5Turbo
            )
        
        // send the query to the api
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                // ensure there's at least one choice in the response
                guard let choice = success.choices.first else { return }
                // extract the content of the message
                guard let message = choice.message.content?.string else { return }
                // use the main thread to update the UI
                DispatchQueue.main.async {
                    // append the api response to the messages array
                    self.messages.append(Message(content: message, isUser: false))
                    // parse the API response
                    self.parseApiReply(message)
                }
            // in case of failure, print out the error
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    // parses the API's response and updates the activities for the location
    func parseApiReply(_ reply: String) {
        // converting the API's reply string to data for JSON decoding
        guard let data = reply.data(using: .utf8) else {
            return
        }
        do {
            // decode the JSON into a LocationResponse object
            let jsonResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
            // manages asynchronous image loading
            let group = DispatchGroup()
            
            // a temp array that stores the day activities
            var tempDayActivities: [DayActivities] = []
            
            // iterate through each day
            for day in jsonResponse.days {
                // temp array that stores activities for each location in the day
                var tempLocationActivities: [LocationActivities] = []
                
                // iterate through each location
                for location in day.locations {
                    // enter the dispatch group
                    group.enter()
                    // search for an image URL based on the location name
                    imageController.search(for: location.location) { imageUrl in
                        // create LocationActivities object and append it to the temp array
                        tempLocationActivities.append(
                            LocationActivities(
                                location: location.location, // location name
                                description: location.description, // location description
                                address: location.address, // location address
                                imageUrl: imageUrl // location image URL
                            )
                        )
                        // leave the dispatch group after the asynchornous task is completed
                        group.leave()
                    }
                }
                
                // notify the main queue when all images have been fetched for the day
                group.notify(queue: .main) {
                    // appending the day's activities to temp array
                    tempDayActivities.append(DayActivities(day: day.day, summary: day.summary, locations: tempLocationActivities))
                }
            }
            
            // notify the main queue when all of the days for the city have been processed
            group.notify(queue: .main) {
                // updating the main activities array from the temp one
                self.locationActivitiesByDay = tempDayActivities
                // all activities have been generated so the flag is now true
                self.hasGeneratedActivities = true
            }
            
        } catch {
            // if JSON parsing fails
            print("Failed to parse JSON: \(error)")
        }
    }
}

/* How String -> Data conversion works
   The 'reply' string is converted to 'Data'.
   The 'data'in Data type is decoded into a 'LocationsResponse' object.
   The 'locations' array from 'LocationsResponse' is mapped to a temp array of 'LocationActivities', which is then assigned to self.locationActivities for use in the SwiftUI view.
 */


// struct to represent the decoded JSON response for the location activities
struct LocationResponse: Decodable {
    struct Day: Decodable {
        let day: Int  // day number
        let summary: String  // summary for all the activities done in a day
        let locations: [Location]  // list of activities for the day
    }
    
    struct Location: Decodable {
        let location: String  // location name
        let description: String  // location activity descriptions
        let address: String // Add this field to store the address
    }
    
    let days: [Day]  // array for number of days in the trip
}


// struct to represent a message
struct Message: Identifiable {
    // message id
    var id: UUID = .init()
    var content: String
    // indicate user input or openAI response
    var isUser: Bool
}

// struct to represent the activities for a specific day
struct DayActivities: Identifiable {
    var id: UUID = .init()  // identifier for the day
    var day: Int  // day number
    var summary: String  // summary for the day's activities
    var locations: [LocationActivities]  // array of activities for the day
}

// struct to represent the activities for a specific location
struct LocationActivities: Identifiable {
    var id: UUID = .init()  // identifier for the location
    var location: String  // location name
    var description: String  // activity description
    var address: String  // address of the location
    var imageUrl: String?  // optional URL for the image of the location
}


