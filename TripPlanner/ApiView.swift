//
//  ApiView.swift
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

// Next step !!!!!!!!!!!!!
// 1. adding image to each activity
// 2. waiting for the design to be finilized


import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    @Published var locationActivities: [LocationActivities] = []
    
    // my private API key
    let openAI = OpenAI(apiToken: "sk-proj-G5R6LNdl0focpuuETLXKT3BlbkFJPPnj2ZgM7yq5qJK10JU9")
    
    // send a user message
    func sendNewMessage(location: String, filter:String) {
        // the query formatted in JSON to send to chatGPT
        let queryMessage = """
                Give me the top 5 \(filter) tourist activities in \(location). 
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
        getBotReply(for: queryMessage)
    }
    
    // request a gpt search result
    func getBotReply(for queryMessage: String) {
        let query = ChatQuery(
            messages: [.init(role: .user, content: queryMessage)!],
            model: .gpt3_5Turbo
            )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return
                }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                    // parse the API response
                    self.parseBotReply(message)
                }
            // in case of not succeed
            case .failure(let failure):
                print(failure)
            }
        }
    }
    // Parse the bot's reply and extract location and activites
    func parseBotReply(_ reply: String) {
        // attempt to convert the reply string into a Data object using UTF-8 encoding
        // if failed, return nil
        guard let data = reply.data(using: .utf8) else {
            return
        }
        do {
            // Decode the JSON data into the LocationsResponse structure
            let jsonResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
            // Map the decoded locations to the LocationActivities structure
            self.locationActivities = jsonResponse.locations.map {
                LocationActivities(location: $0.location, activities: $0.activities)
            }
            
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
}
/* How String -> Data conversion works
   The 'reply' string is converted to 'Data'.
   The 'data'in Data type is decoded into a 'LocationsResponse' object.
   The 'locations' array from 'LocationsResponse' is mapped to an array of 'LocationActivities', which is then assigned to self.locationActivities for use in the SwiftUI view.
 */

struct LocationResponse: Decodable {
    struct Location: Decodable {
        let location: String
        let activities: [String]
    }
    let locations: [Location]
}

struct LocationActivities: Identifiable {
    var id: UUID = .init()
    var location: String
    var activities: [String]
}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

// set up the app interface
struct ApiView: View {
    @StateObject var chatController: ChatController = .init()
    @State var location: String = ""
    @State var filter: String = ""
    var body: some View {
        VStack {
            // styling for textfields(location & filter) and the search button
            HStack {
                TextField("Location, State...", text: self.$location)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .frame(width: 220)
                TextField("Filter...", text: self.$filter)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .frame(width: 130)
            }
            .padding()
            HStack {
                Button {
                    self.chatController.sendNewMessage(location: location, filter: filter)
                    location = ""
                    filter = ""
                } label: {
                    Text("Plan My Trip!")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
        }
        Divider()
        // styling for each message and search result
        VStack {
            ScrollView {
                // this part display queryMessage and JSON reply
                // can be omit by commenting it out
                ForEach(chatController.messages) { message in
                    MessageView(message: message)
                        .padding(5)
                }
                // displaying locations and activities
                ForEach(chatController.locationActivities) { locationActivity in
                    VStack(alignment: .leading) {
                        Text(locationActivity.location)
                            .font(.headline)
                            .padding(.top, 5)
                            .padding(.bottom, 2)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                        ForEach(locationActivity.activities, id: \.self) { activity in
                            Text("- \(activity)")
                                .padding(.leading, 10)
                        }
                    }
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

// set up each message's appearance
struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                /*
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                }
                 */
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                    Spacer()
                }
            }
        }
    }
}
 

#Preview {
    ApiView()
}
