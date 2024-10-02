import SwiftUI

struct SecondView: View {
    @State private var selectedCity: String = "Enter destination"
    @State private var selectedDays: Int = 5
    @State private var selectedTripTypes: Set<String> = []
    @StateObject private var planController = PlanController() // Create PlanController instance

    let daysOptions = [1, 2, 3, 4, 5, 6, 7, 8]
    let cities = ["Los Angeles, USA", "Honolulu, USA", "Paris, France", "Santorini, Greece", "Mumbai, India", "Shanghai, China", "Tokyo, Japan", "New York City, USA", "Cancun, Mexico", "London, England"]

    let elementHeight: CGFloat = 45
    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.75

    let gradientStartColor = Color(UIColor(red: 141/255, green: 172/255, blue: 225/255, alpha: 1))
    let gradientEndColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
    
    var userUID: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 25) {
                    // Blue Gradient Box at the Top
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 300)
                            .edgesIgnoringSafeArea(.top)
                        
                        VStack {
                            Text("Where are you headed?")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.top, 100) // Adjusted padding for better alignment
                            
                            // Destination Menu inside the gradient box
                            Menu {
                                ForEach(cities, id: \.self) { city in
                                    Button(city) {
                                        selectedCity = city
                                        print("Selected City: \(selectedCity)")
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    Text(selectedCity)
                                        .foregroundColor(selectedCity == "Enter destination" ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .frame(width: buttonWidth, height: elementHeight)
                                .background(Color(.white))
                                .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }

                    // Days Picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Days")
                            .font(.title2.bold())
                            .foregroundColor(Color(.systemTeal))

                        Text("How many days will you be gone for?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, (UIScreen.main.bounds.width - buttonWidth) / 2)
                    .padding(.leading, -83)
                    .padding(.bottom, 5)

                    Picker("How many days will you be gone for?", selection: $selectedDays) {
                        ForEach(daysOptions, id: \.self) { day in
                            Text("\(day) Days")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(width: buttonWidth, height: elementHeight)
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 96/255, green: 131/255, blue: 153/255, opacity: 255/255), lineWidth: 3)
                    )
                    .padding(.horizontal)
                    .onChange(of: selectedDays) { newValue in
                        print("Selected Days: \(selectedDays)")
                    }

                    // Trip Type Selection
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Trip Type")
                            .font(.title2.bold())
                            .foregroundColor(Color(.systemTeal))

                        Text("What kind of trip do you want to go on?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, (UIScreen.main.bounds.width - buttonWidth) / 2)
                    .padding(.leading, -74)
                    .padding(.bottom, 5)

                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            tripTypeButton(title: "Adventurous")
                            tripTypeButton(title: "Relaxing")
                        }
                        HStack(spacing: 10) {
                            tripTypeButton(title: "Party")
                            tripTypeButton(title: "Historical")
                        }
                    }
                    .frame(width: buttonWidth)
                    
                    // Correct functionality for "Plan Your Next Trip!" button
                    NavigationLink(
                        destination: ItineraryView(location: selectedCity, days: selectedDays, userUID: userUID, planController: planController)) {
                        Text("Plan Your Next Trip!")
                            .font(.headline)
                            .padding()
                            .frame(width: buttonWidth, height: elementHeight)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Tab Bar
                    HStack {
                        Spacer()
                        TabBarItem(iconName: "briefcase", label: "Past Trips", userUID: userUID)
                        Spacer()
                        TabBarItem(iconName: "globe", label: "Plan Trip", isSelected: true, userUID: userUID)  // Highlight 'Plan Trip' icon
                        Spacer()
                        TabBarItem(iconName: "person", label: "Profile", userUID: userUID)
                        Spacer()
                        TabBarItem(iconName: "gearshape", label: "Settings", userUID: userUID)
                        Spacer()
                    }
                    .frame(height: 80)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }

    private func tripTypeButton(title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding()
            .frame(width: (buttonWidth - 10) / 2, height: elementHeight)
            .background(selectedTripTypes.contains(title) ? Color(red: 96/255, green: 131/255, blue: 153/255) : Color(red: 200/255, green: 228/255, blue: 250/255))
            .foregroundColor(selectedTripTypes.contains(title) ? Color.white : Color.black)
            .cornerRadius(8)
            .onTapGesture {
                if selectedTripTypes.contains(title) {
                    selectedTripTypes.remove(title)
                } else {
                    selectedTripTypes.insert(title)
                }
                print("Selected Trip Types: \(selectedTripTypes)")
            }
    }

    private func TabBarItem(iconName: String, label: String, isSelected: Bool = false, userUID: String) -> some View {
        VStack {
            Image(systemName: iconName)
                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
        }
        .padding(.vertical, 10)
        .background(isSelected ? gradientEndColor.opacity(0.2) : Color.clear)  // Highlight background if selected
        .cornerRadius(10)
        .onTapGesture {
            switch label {
            case "Plan Trip":
                // Do nothing, already on Plan Trip
                break
            case "Profile":
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: ProfileView(userUID: userUID))
                    window.makeKeyAndVisible()
                }
            case "Past Trips":
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: PastTripsView(userUID: userUID))
                    window.makeKeyAndVisible()
                }
            case "Settings":
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: SettingsView(userUID: userUID))
                    window.makeKeyAndVisible()
                }
            default:
                break
            }
        }
    }
}




