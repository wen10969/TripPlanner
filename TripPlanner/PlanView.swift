import SwiftUI

// set up the app view
struct PlanView: View {
    @StateObject var planController: PlanController = .init()
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
                    self.planController.sendNewMessage(location: location, filter: filter)
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
//                ForEach(planController.messages) { message in
//                    MessageView(message: message)
//                        .padding(5)
//                }
                // displaying locations and activities
                ForEach(planController.locationActivities) { locationActivity in
                    VStack(alignment: .leading) {
                        // display the location name as a headline
                        Text(locationActivity.location)
                            .font(.headline)
                            .padding(.top, 5)
                            .padding(.bottom, 2)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                        
                        
                        // check if there is a valid image URL for the location
                        if let imageUrl = locationActivity.imageUrl, let url = URL(string: imageUrl) {
                            // use AsyncImage to load the image asynchronously
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    // show a progress view while the image is loading
                                    ProgressView()
                                case .success(let image):
                                    // display the searched image
                                    // make it resizable and scaled to fit within the frame
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: 200)
                                case .failure:
                                    // show a placeholder image if loading the image fails
                                    Image(systemName: "photo")
                                @unknown default:
                                    // handle any unknown state with a placeholder image
                                    Image(systemName: "photo")
                                }
                            }
                        }
                        
                        // display each activitu for the location
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
// can be omit if query and API reply no need to display
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
    PlanView()
}
