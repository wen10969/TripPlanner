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

import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    // my private API key
    let openAI = OpenAI(apiToken: "sk-proj-G5R6LNdl0focpuuETLXKT3BlbkFJPPnj2ZgM7yq5qJK10JU9")
    
    // send a user message
    func sendNewMessage(location: String, filter:String) {
        // the query formatted to send to chatGPT
        let queryMessage = "Give me the top 5 \(filter) tourist activities in \(location), grouped by the same location, no descriptions at all, and do not repeat the same type of activities in the same location."
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
                }
            // in case of not succeed
            case .failure(let failure):
                print(failure)
            }
        }
    }
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
                    Text("Search")
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
                ForEach(chatController.messages) {
                    message in
                    MessageView(message: message)
                        .padding(5)
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
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Rectangle())
                }
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
