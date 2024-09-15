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
    @Published var messages: [Message] = []
    @Published var locationActivities: [LocationActivities] = []
    
    // my private API key
    private let openAI = OpenAI(apiToken: "sk-proj-G5R6LNdl0focpuuETLXKT3BlbkFJPPnj2ZgM7yq5qJK10JU9")
    // use the shared instance of ImageController
    private let imageController = ImageController.shared
    
    // send a user message
    func sendNewMessage(location: String, filter:String, days: Int) {
        // the query formatted in JSON to send to openAI
        let queryMessage = """
                Give me the top \(days) \(filter) tourist activities in \(location).
                Respond in the following JSON format:
                {
                  "locations": [
                    {
                      "location": "Location Name",
                      "activities": ["Activity 1", "Activity 2", ...]
                    }
                  ]
                }
                """
        let userMessage = Message(content: queryMessage, isUser: true)
        self.messages.append(userMessage)
        // gather gpt result
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
    // parse the bot's reply and extract location and activites
    func parseApiReply(_ reply: String) {
        // attempt to convert the reply string into a Data object using UTF-8 encoding
        // if failed, return nil
        guard let data = reply.data(using: .utf8) else {
            return
        }
        do {
            // decode the JSON data into the LocationsResponse structure
            let jsonResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
            // use DispatchGroop to handle Asynchronous Tasks
            // dispatchGroup is used to keep track of multiple asynchronous tasks and notify when all tasks are completed
            let group = DispatchGroup()
            
            // this array temporarily holds the LocationActivities objects until all image URLs are fetched
            var tempLocationActivities: [LocationActivities] = []
            
            // loop Through Locations and Fetch Images
            for location in jsonResponse.locations {
                // indicate an asynchronous task has started
                group.enter()
                // call search function to fetch the image URL
                // then append a new LocationActivities object to tempLocationActivities with the fetched imageUrl
                imageController.search(for: location.location) { imageUrl in
                    tempLocationActivities.append(
                        LocationActivities(location: location.location, activities: location.activities, imageUrl: imageUrl))
                    // indicate that the asynchronous task has finished
                    group.leave()
                }
            }
            //  notify when all tasks are completed
            group.notify(queue: .main) {
                // assign temp array to self.locationActivities
                self.locationActivities = tempLocationActivities
            }
           
            
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
}
/* How String -> Data conversion works
   The 'reply' string is converted to 'Data'.
   The 'data'in Data type is decoded into a 'LocationsResponse' object.
   The 'locations' array from 'LocationsResponse' is mapped to a temp array of 'LocationActivities', which is then assigned to self.locationActivities for use in the SwiftUI view.
 */

// struct to represent the JSON response from the openAI API
struct LocationResponse: Decodable {
    struct Location: Decodable {
        let location: String
        // array of activities in one location
        let activities: [String]
    }
    // array of locations
    let locations: [Location]
}

// struct to represent the location activities
struct LocationActivities: Identifiable {
    var id: UUID = .init()
    var location: String
    var activities: [String]
    // the url of the location image
    var imageUrl: String?
}

// struct to represent a message
struct Message: Identifiable {
    // message id
    var id: UUID = .init()
    var content: String
    // indicate user input or openAI response
    var isUser: Bool
}
