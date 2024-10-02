//
//  ProfileView.swift
//  TripPlanner3
//
//  Created by stlp on 9/13/24.
//

//import SwiftUI
//import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ProfileView: View {
//    @State private var username: String = ""
//    @State private var email: String = ""
//    @State private var profileImageUrl: String = ""
//    @State private var isEditing: Bool = false
//    @State private var image: UIImage? = nil
//    @State private var showingImagePicker = false
//    @State private var loading: Bool = true
//    @State private var errorMessage: String? = nil
//    @State private var showRemovePictureAlert = false
//
//    let elementHeight: CGFloat = 45
//    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.85
//
//    var body: some View {
//        VStack {
//            Spacer().frame(height: 60)
//
//            if loading {
//                ProgressView("Loading...")
//                    .progressViewStyle(CircularProgressViewStyle())
//            } else {
//                VStack {
//                    ZStack {
//                        if let image = image {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 100, height: 100)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                        } else {
//                            Text(initials(for: username))
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .frame(width: 100, height: 100)
//                                .background(Circle().fill(Color(red: 0.16, green: 0.5, blue: 0.62)))
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                        }
//
//                        Button(action: {
//                            showingImagePicker = true
//                        }) {
//                            Image(systemName: "pencil.circle.fill")
//                                .foregroundColor(.blue)
//                                .background(Circle().fill(Color.white))
//                                .offset(x: 35, y: 35)
//                        }
//                    }
//                    .padding(.bottom, 20)
//                    .sheet(isPresented: $showingImagePicker) {
//                        ImagePicker(selectedImage: $image)
//                    }
//
//                    if image != nil {
//                        Button(action: {
//                            showRemovePictureAlert = true
//                        }) {
//                            Text("Remove Picture")
//                                .foregroundColor(.red)
//                        }
//                        .alert(isPresented: $showRemovePictureAlert) {
//                            Alert(
//                                title: Text("Remove Picture"),
//                                message: Text("Are you sure you want to remove your profile picture?"),
//                                primaryButton: .destructive(Text("Remove")) {
//                                    removeProfilePicture()
//                                },
//                                secondaryButton: .cancel()
//                            )
//                        }
//                    }
//                }
//
//                VStack(alignment: .leading, spacing: 20) {
//                    ProfileRow(icon: "person.fill", label: "Name", text: $username)
//                    ProfileRow(icon: "envelope.fill", label: "E-Mail", text: $email, editable: false)
//                }
//                .padding(.horizontal, 20)
//
//                Spacer()
//
//                Button(action: {
//                    saveProfileChanges()
//                }) {
//                    Text("Save Changes")
//                        .font(.headline)
//                        .padding()
//                        .frame(width: buttonWidth, height: elementHeight)
//                        .background(Color(red: 0.16, green: 0.5, blue: 0.62))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding(.top, 20)
//
//                Spacer()
//            }
//        }
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [Color(red: 0.19, green: 0.65, blue: 0.78, opacity: 0.3), Color.white]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        )
//        .edgesIgnoringSafeArea(.all)
//        .onAppear(perform: loadUserData)
//    }
//
//    private func loadUserData() {
//        AuthService.shared.fetchUser { user, error in
//            if let error = error {
//                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
//                self.loading = false
//                return
//            }
//            
//            if let user = user {
//                self.username = user.username
//                self.email = user.email
//                self.profileImageUrl = user.profileImageUrl
//                self.loading = false
//                loadProfileImage(from: self.profileImageUrl)
//            } else {
//                self.errorMessage = "User data not found."
//                self.loading = false
//            }
//        }
//    }
//
//    private func saveProfileChanges() {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        // Update user profile data with the new username and profile image URL
//        AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: self.profileImageUrl) { error in
//            if let error = error {
//                print("Error updating user data: \(error.localizedDescription)")
//                return
//            }
//            print("User data saved successfully.")
//        }
//
//        // If there's a new image, upload it
//        if let image = image {
//            AuthService.shared.saveProfileImage(image: image, userUID: userUID) { urlString, error in
//                if let error = error {
//                    print("Error uploading image: \(error.localizedDescription)")
//                    return
//                }
//                
//                if let urlString = urlString {
//                    self.profileImageUrl = urlString
//                    print("Profile image uploaded and URL saved successfully.")
//                }
//            }
//        }
//    }
//
//    private func removeProfilePicture() {
//        image = nil
//
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        storageRef.delete { error in
//            if let error = error {
//                print("Error removing image: \(error.localizedDescription)")
//            } else {
//                AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: "") { error in
//                    if let error = error {
//                        print("Error removing profile image URL: \(error.localizedDescription)")
//                    } else {
//                        print("Profile image removed successfully.")
//                    }
//                }
//            }
//        }
//    }
//
//    private func loadProfileImage(from urlString: String) {
//        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading profile image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.image = uiImage
//                }
//            }
//        }.resume()
//    }
//
//    private func initials(for name: String) -> String {
//        let components = name.split(separator: " ")
//        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
//        return String(initials.prefix(2)).uppercased()
//    }
//}

//
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ProfileView: View {
//    @State private var username: String = ""
//    @State private var email: String = ""
//    @State private var bio: String = ""
//    @State private var profileImage: UIImage? = nil
//    @State private var isEditing: Bool = false
//    @State private var showingImagePicker = false
//    @State private var loading: Bool = true
//    @State private var errorMessage: String? = nil
//    @State private var showRemovePictureAlert = false
//
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color(red: 0.19, green: 0.65, blue: 0.78), Color(red: 0.84, green: 0.94, blue: 1.0)]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                ProfileHeaderView(profileImage: $profileImage, username: username, showingImagePicker: $showingImagePicker, isEditing: $isEditing)
//
//                Spacer().frame(height: 30)
//
//                if loading {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    VStack(alignment: .leading, spacing: 20) {
//                        PersonalInfoRow(icon: "person.fill", label: "Name", text: $username, editable: isEditing)
//                        PersonalInfoRow(icon: "envelope.fill", label: "E-Mail", text: $email, editable: false)
//                        PersonalInfoRow(icon: "info.circle.fill", label: "Bio", text: $bio, editable: isEditing)
//                    }
//                    .padding(.horizontal, 30)
//
//                    if isEditing {
//                        Button(action: saveProfileChanges) {
//                            Text("Save Changes")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                        .onTapGesture {
//                            isEditing = false
//                        }
//                    } else {
//                        Button(action: {
//                            isEditing.toggle()
//                        }) {
//                            Text("Edit Profile")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                    }
//                }
//
//                Spacer()
//
//                // Tab Bar
//                HStack {
//                    Spacer()
//                    TabBarItem(iconName: "briefcase", label: "Past Trips", destination: AnyView(SecondView()))
//                    Spacer()
//                    TabBarItem(iconName: "globe", label: "Plan Trip", destination: AnyView(SecondView()))
//                    Spacer()
//                    TabBarItem(iconName: "person", label: "Profile", destination: AnyView(ProfileView()))
//                    Spacer()
//                    TabBarItem(iconName: "gearshape", label: "Settings", destination: AnyView(SettingsView()))
//                    Spacer()
//                }
//                .padding(.bottom)
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(radius: 5)
//            }
//        }
//        .onAppear(perform: loadUserData)
//        .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(selectedImage: $profileImage)
//        }
//    }
//
//    private func saveProfileChanges() {
//        // Save profile changes logic here, including saving the new profile image to Firebase
//        if let newImage = profileImage {
//            // Call function to upload image
//            uploadProfileImage(newImage)
//        }
//        isEditing = false  // Dismiss editing mode
//    }
//
//    private func uploadProfileImage(_ image: UIImage) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
//
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                return
//            }
//
//            storageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Error getting download URL: \(error.localizedDescription)")
//                    return
//                }
//
//                if let urlString = url?.absoluteString {
//                    self.updateUserProfileImageUrl(urlString)
//                }
//            }
//        }
//    }
//
//    private func updateUserProfileImageUrl(_ urlString: String) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let db = Firestore.firestore()
//        db.collection("users").document(userUID).updateData([
//            "profileImageUrl": urlString
//        ]) { error in
//            if let error = error {
//                print("Error updating profile image URL: \(error.localizedDescription)")
//                return
//            }
//
//            print("Profile image URL updated successfully.")
//        }
//    }
//
//    private func loadUserData() {
//        AuthService.shared.fetchUser { user, error in
//            if let error = error {
//                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
//                self.loading = false
//                return
//            }
//            
//            if let user = user {
//                self.username = user.username
//                self.email = user.email
//                self.bio = user.bio ?? ""
//                self.loading = false
//                loadProfileImage(from: user.profileImageUrl)
//            } else {
//                self.errorMessage = "User data not found."
//                self.loading = false
//            }
//        }
//    }
//
//    private func loadProfileImage(from urlString: String) {
//        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading profile image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = uiImage
//                }
//            }
//        }.resume()
//    }
//
//    private func TabBarItem(iconName: String, label: String, destination: AnyView) -> some View {
//        VStack {
//            Image(systemName: iconName)
//            Text(label)
//                .font(.footnote)
//        }
//        .padding(.vertical, 10)
//        .foregroundColor(.blue)
//        .onTapGesture {
//            if let window = UIApplication.shared.windows.first {
//                window.rootViewController = UIHostingController(rootView: destination)
//                window.makeKeyAndVisible()
//            }
//        }
//    }
//}

//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ProfileView: View {
//    @State private var username: String = ""
//    @State private var email: String = ""
//    @State private var bio: String = ""
//    @State private var profileImage: UIImage? = nil
//    @State private var isEditing: Bool = false
//    @State private var showingImagePicker = false
//    @State private var loading: Bool = true
//    @State private var errorMessage: String? = nil
//    @State private var showRemovePictureAlert = false
//
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color(red: 0.19, green: 0.65, blue: 0.78), Color(red: 0.84, green: 0.94, blue: 1.0)]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                // Profile Header View with Image Picker
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.blue.opacity(0.8))
//                        .frame(height: 200)
//                        .padding(.horizontal)
//
//                    if let image = profileImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                            .padding(.top, -50)
//                    } else {
//                        Text(initials(for: username))
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                            .frame(width: 100, height: 100)
//                            .background(Circle().fill(Color.gray))
//                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                            .padding(.top, -50)
//                    }
//
//                    if isEditing {
//                        Button(action: {
//                            showingImagePicker = true
//                        }) {
//                            Image(systemName: "pencil.circle.fill")
//                                .font(.system(size: 24))
//                                .foregroundColor(.blue)
//                                .background(Circle().fill(Color.white))
//                                .offset(x: 40, y: -30)
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//                .sheet(isPresented: $showingImagePicker) {
//                    ImagePicker(selectedImage: $profileImage)
//                }
//
//                // Option to Remove Profile Picture
//                if isEditing && profileImage != nil {
//                    Button(action: {
//                        showRemovePictureAlert = true
//                    }) {
//                        Text("Remove Picture")
//                            .foregroundColor(.red)
//                    }
//                    .alert(isPresented: $showRemovePictureAlert) {
//                        Alert(
//                            title: Text("Remove Picture"),
//                            message: Text("Are you sure you want to remove your profile picture?"),
//                            primaryButton: .destructive(Text("Remove")) {
//                                removeProfilePicture()
//                            },
//                            secondaryButton: .cancel()
//                        )
//                    }
//                }
//
//                Spacer().frame(height: 30)
//
//                if loading {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    VStack(alignment: .leading, spacing: 20) {
//                        PersonalInfoRow(icon: "person.fill", label: "Name", text: $username, editable: isEditing)
//                        PersonalInfoRow(icon: "envelope.fill", label: "E-Mail", text: $email, editable: false)
//                        PersonalInfoRow(icon: "info.circle.fill", label: "Bio", text: $bio, editable: isEditing)
//                    }
//                    .padding(.horizontal, 30)
//
//                    if isEditing {
//                        Button(action: saveProfileChanges) {
//                            Text("Save Changes")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                        .onTapGesture {
//                            isEditing = false
//                        }
//                    } else {
//                        Button(action: {
//                            isEditing.toggle()
//                        }) {
//                            Text("Edit Profile")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                    }
//                }
//
//                Spacer()
//
//                // Tab Bar
//                HStack {
//                    Spacer()
//                    TabBarItem(iconName: "briefcase", label: "Past Trips", destination: AnyView(SecondView()))
//                    Spacer()
//                    TabBarItem(iconName: "globe", label: "Plan Trip", destination: AnyView(SecondView()))
//                    Spacer()
//                    TabBarItem(iconName: "person", label: "Profile", destination: AnyView(ProfileView()))
//                    Spacer()
//                    TabBarItem(iconName: "gearshape", label: "Settings", destination: AnyView(SettingsView()))
//                    Spacer()
//                }
//                .padding(.bottom)
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(radius: 5)
//            }
//        }
//        .onAppear(perform: loadUserData)
//    }
//
//    private func saveProfileChanges() {
//        // Save profile changes logic here, including saving the new profile image to Firebase
//        if let newImage = profileImage {
//            uploadProfileImage(newImage)
//        }
//        isEditing = false  // Dismiss editing mode
//    }
//
//    private func uploadProfileImage(_ image: UIImage) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
//
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                return
//            }
//
//            storageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Error getting download URL: \(error.localizedDescription)")
//                    return
//                }
//
//                if let urlString = url?.absoluteString {
//                    self.updateUserProfileImageUrl(urlString)
//                }
//            }
//        }
//    }
//
//    private func updateUserProfileImageUrl(_ urlString: String) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let db = Firestore.firestore()
//        db.collection("users").document(userUID).updateData([
//            "profileImageUrl": urlString
//        ]) { error in
//            if let error = error {
//                print("Error updating profile image URL: \(error.localizedDescription)")
//                return
//            }
//
//            print("Profile image URL updated successfully.")
//        }
//    }
//
//    private func loadUserData() {
//        AuthService.shared.fetchUser { user, error in
//            if let error = error {
//                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
//                self.loading = false
//                return
//            }
//            
//            if let user = user {
//                self.username = user.username
//                self.email = user.email
//                self.bio = user.bio ?? ""
//                self.loading = false
//                loadProfileImage(from: user.profileImageUrl)
//            } else {
//                self.errorMessage = "User data not found."
//                self.loading = false
//            }
//        }
//    }
//
//    private func loadProfileImage(from urlString: String) {
//        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading profile image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = uiImage
//                }
//            }
//        }.resume()
//    }
//
//    private func removeProfilePicture() {
//        profileImage = nil
//
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        storageRef.delete { error in
//            if let error = error {
//                print("Error removing image: \(error.localizedDescription)")
//            } else {
//                AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: "") { error in
//                    if let error = error {
//                        print("Error removing profile image URL: \(error.localizedDescription)")
//                    } else {
//                        print("Profile image removed successfully.")
//                    }
//                }
//            }
//        }
//    }
//
//    private func TabBarItem(iconName: String, label: String, destination: AnyView) -> some View {
//        VStack {
//            Image(systemName: iconName)
//            Text(label)
//                .font(.footnote)
//        }
//        .padding(.vertical, 10)
//        .foregroundColor(.blue)
//        .onTapGesture {
//            if let window = UIApplication.shared.windows.first {
//                window.rootViewController = UIHostingController(rootView: destination)
//                window.makeKeyAndVisible()
//            }
//        }
//    }
//
//    private func initials(for name: String) -> String {
//        let components = name.split(separator: " ")
//        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
//        return String(initials.prefix(2)).uppercased()
//    }
//}

//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ProfileView: View {
//    @State private var username: String = ""
//    @State private var email: String = ""
//    @State private var bio: String = ""
//    @State private var profileImage: UIImage? = nil
//    @State private var isEditing: Bool = false
//    @State private var showingImagePicker = false
//    @State private var loading: Bool = true
//    @State private var errorMessage: String? = nil
//    @State private var showRemovePictureAlert = false
//
//    // Refined gradient colors to match your screenshot more closely
//    let gradientStartColor = Color(UIColor(red: 141/255, green: 172/255, blue: 225/255, alpha: 1))
//    let gradientEndColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
//    let borderColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
//
//    var body: some View {
//        ZStack {
//            Color.white
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                // Gradient Background Box at the Top with More Rounded Corners
//                ZStack {
//                    RoundedRectangle(cornerRadius: 30, style: .continuous)  // Increased corner radius for more rounded appearance
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                        )
//                        .frame(height: 300)
//                        .edgesIgnoringSafeArea(.top)
//                    
//                    VStack {
//                        Spacer().frame(height: 80)
//                        
//                        if let image = profileImage {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 100, height: 100)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                .padding(.top, -50)
//                        } else {
//                            Text(initials(for: username))
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .frame(width: 100, height: 100)
//                                .background(Circle().fill(Color.gray))
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                .padding(.top, -50)
//                        }
//
//                        if isEditing {
//                            Button(action: {
//                                showingImagePicker = true
//                            }) {
//                                Image(systemName: "pencil.circle.fill")
//                                    .font(.system(size: 24))
//                                    .foregroundColor(.blue)
//                                    .background(Circle().fill(Color.white))
//                                    .offset(x: 40, y: -30)
//                            }
//                        }
//                    }
//                }
//                .padding(.bottom, 30)
//
//                // Profile Information Section
//                if isEditing && profileImage != nil {
//                    Button(action: {
//                        showRemovePictureAlert = true
//                    }) {
//                        Text("Remove Picture")
//                            .foregroundColor(.red)
//                    }
//                    .alert(isPresented: $showRemovePictureAlert) {
//                        Alert(
//                            title: Text("Remove Picture"),
//                            message: Text("Are you sure you want to remove your profile picture?"),
//                            primaryButton: .destructive(Text("Remove")) {
//                                removeProfilePicture()
//                            },
//                            secondaryButton: .cancel()
//                        )
//                    }
//                }
//
//                Spacer().frame(height: 30)
//
//                if loading {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    VStack(alignment: .leading, spacing: 20) {  // Adjusted alignment for labels
//                        PersonalInfoRow(icon: "person.fill", label: "Name", text: $username, editable: isEditing, borderColor: borderColor)
//                        PersonalInfoRow(icon: "envelope.fill", label: "E-Mail", text: $email, editable: false, borderColor: borderColor)
//                        PersonalInfoRow(icon: "info.circle.fill", label: "Bio", text: $bio, editable: isEditing, borderColor: borderColor)
//                    }
//                    .padding(.horizontal, 30)
//                    .font(.system(size: 16))  // Unified font size
//                    .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1)))  // Label color
//
//                    if isEditing {
//                        Button(action: saveProfileChanges) {
//                            Text("Save Changes")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                        .onTapGesture {
//                            isEditing = false
//                        }
//                    } else {
//                        Button(action: {
//                            isEditing.toggle()
//                        }) {
//                            Text("Edit Profile")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                    }
//                }
//
//                Spacer()
//
//                // Tab Bar with Highlighted Profile Icon
//                HStack {
//                    Spacer()
//                    TabBarItem(iconName: "briefcase", label: "Past Trips", destination: AnyView(SecondView()))
//                    Spacer()
//                    TabBarItem(iconName: "globe", label: "Plan Trip", destination: AnyView(SecondView()))
//                    Spacer()
//                    TabBarItem(iconName: "person.fill", label: "Profile", destination: AnyView(ProfileView()), isSelected: true)  // Highlight profile icon
//                    Spacer()
//                    TabBarItem(iconName: "gearshape", label: "Settings", destination: AnyView(SettingsView()))
//                    Spacer()
//                }
//                .padding(.bottom)
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(radius: 5)
//            }
//        }
//        .onAppear(perform: loadUserData)
//    }
//
//    private func saveProfileChanges() {
//        if let newImage = profileImage {
//            uploadProfileImage(newImage)
//        }
//        isEditing = false
//    }
//
//    private func uploadProfileImage(_ image: UIImage) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
//
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                return
//            }
//
//            storageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Error getting download URL: \(error.localizedDescription)")
//                    return
//                }
//
//                if let urlString = url?.absoluteString {
//                    self.updateUserProfileImageUrl(urlString)
//                }
//            }
//        }
//    }
//
//    private func updateUserProfileImageUrl(_ urlString: String) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let db = Firestore.firestore()
//        db.collection("users").document(userUID).updateData([
//            "profileImageUrl": urlString
//        ]) { error in
//            if let error = error {
//                print("Error updating profile image URL: \(error.localizedDescription)")
//                return
//            }
//
//            print("Profile image URL updated successfully.")
//        }
//    }
//
//    private func loadUserData() {
//        AuthService.shared.fetchUser { user, error in
//            if let error = error {
//                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
//                self.loading = false
//                return
//            }
//            
//            if let user = user {
//                self.username = user.username
//                self.email = user.email
//                self.bio = user.bio ?? ""
//                self.loading = false
//                loadProfileImage(from: user.profileImageUrl)
//            } else {
//                self.errorMessage = "User data not found."
//                self.loading = false
//            }
//        }
//    }
//
//    private func loadProfileImage(from urlString: String) {
//        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading profile image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = uiImage
//                }
//            }
//        }.resume()
//    }
//
//    private func removeProfilePicture() {
//        profileImage = nil
//
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        storageRef.delete { error in
//            if let error = error {
//                print("Error removing image: \(error.localizedDescription)")
//            } else {
//                AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: "") { error in
//                    if let error = error {
//                        print("Error removing profile image URL: \(error.localizedDescription)")
//                    } else {
//                        print("Profile image removed successfully.")
//                    }
//                }
//            }
//        }
//    }
//
//    private func TabBarItem(iconName: String, label: String, destination: AnyView, isSelected: Bool = false) -> some View {
//        VStack {
//            Image(systemName: iconName)
//                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
//            Text(label)
//                .font(.footnote)
//                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
//        }
//        .padding(.vertical, 10)
//        .background(isSelected ? gradientEndColor.opacity(0.2) : Color.clear)  // Highlight background if selected
//        .cornerRadius(10)
//        .onTapGesture {
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                if let window = windowScene.windows.first {
//                    window.rootViewController = UIHostingController(rootView: destination)
//                    window.makeKeyAndVisible()
//                }
//            }
//        }
//    }
//
//    private func initials(for name: String) -> String {
//        let components = name.split(separator: " ")
//        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
//        return String(initials.prefix(2)).uppercased()
//    }
//}
//
//// Correct PersonalInfoRow Declaration
//struct PersonalInfoRow: View {
//    var icon: String
//    var label: String
//    @Binding var text: String
//    var editable: Bool = false
//    var borderColor: Color
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.gray)
//            Text(label)
//                .font(.system(size: 14))
//                .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1)))
//            Spacer()
//            if editable {
//                TextField(label, text: $text)
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
//            } else {
//                Text(text)
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
//            }
//        }
//    }
//}

//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ProfileView: View {
//    @State private var username: String = ""
//    @State private var email: String = ""
//    @State private var bio: String = ""
//    @State private var profileImage: UIImage? = nil
//    @State private var isEditing: Bool = false
//    @State private var showingImagePicker = false
//    @State private var loading: Bool = true
//    @State private var errorMessage: String? = nil
//    @State private var showRemovePictureAlert = false
//
//    let gradientStartColor = Color(UIColor(red: 141/255, green: 172/255, blue: 225/255, alpha: 1))
//    let gradientEndColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
//    let borderColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
//
//    var body: some View {
//        ZStack {
//            Color.white
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                // Gradient Background Box at the Top with No Space Above
//                ZStack(alignment: .top) {  // Use alignment to ensure the box starts from the top
//                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                        )
//                        .frame(height: 300)
//                        .edgesIgnoringSafeArea(.top)  // Ensure the gradient box touches the top
//
//                    VStack {
//                        Spacer().frame(height: 70)  // Adjust spacing to align profile picture
//
//                        ZStack {
//                            if let image = profileImage {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 100)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                    .onTapGesture {  // Allow adding profile picture when tapped
//                                        showingImagePicker = true
//                                    }
//                            } else {
//                                Text(initials(for: username))
//                                    .font(.largeTitle)
//                                    .foregroundColor(.white)
//                                    .frame(width: 100, height: 100)
//                                    .background(Circle().fill(Color.gray))
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                    .onTapGesture {  // Allow adding profile picture when tapped
//                                        showingImagePicker = true
//                                    }
//                            }
//
//                            if isEditing {
//                                Button(action: {
//                                    showingImagePicker = true
//                                }) {
//                                    Image(systemName: "pencil.circle.fill")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(.blue)
//                                        .background(Circle().fill(Color.white))
//                                        .offset(x: 40, y: -30)
//                                }
//                            }
//                        }
//                    }
//                }
//
//                Spacer().frame(height: 30)
//
//                if loading {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    VStack(alignment: .leading, spacing: 20) {  // Adjusted alignment for labels
//                        PersonalInfoRow(icon: "person.fill", label: "Name", text: $username, editable: isEditing, borderColor: borderColor)
//                        PersonalInfoRow(icon: "envelope.fill", label: "E-Mail", text: $email, editable: false, borderColor: borderColor)
//                        PersonalInfoRow(icon: "info.circle.fill", label: "Bio", text: $bio, editable: isEditing, borderColor: borderColor)
//                    }
//                    .padding(.horizontal, 30)
//                    .font(.system(size: 16))  // Unified font size
//                    .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1)))  // Label color
//
//                    if isEditing {
//                        Button(action: saveProfileChanges) {
//                            Text("Save Changes")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                        .onTapGesture {
//                            isEditing = false
//                        }
//                    } else {
//                        Button(action: {
//                            isEditing.toggle()
//                        }) {
//                            Text("Edit Profile")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                    }
//                }
//
//                Spacer()
//
//                // Tab Bar with Highlighted Profile Icon
//                VStack {
//                    Spacer()  // Pushes the tab bar to the bottom
//
//                    HStack {
//                        Spacer()
//                        TabBarItem(iconName: "briefcase", label: "Past Trips", destination: AnyView(SecondView()))
//                        Spacer()
//                        TabBarItem(iconName: "globe", label: "Plan Trip", destination: AnyView(SecondView()))
//                        Spacer()
//                        TabBarItem(iconName: "person.fill", label: "Profile", destination: AnyView(ProfileView()), isSelected: true)  // Highlight profile icon
//                        Spacer()
//                        TabBarItem(iconName: "gearshape", label: "Settings", destination: AnyView(SettingsView()))
//                        Spacer()
//                    }
//                    .frame(height: 72)
//                    .background(Color.white)
//                    .cornerRadius(8)
//                    .shadow(radius: 5)
//                    .padding(.bottom, 0)  // Ensure it is touching the bottom edge
//                }
//                .edgesIgnoringSafeArea(.bottom)  // Ensure the tab bar extends to the bottom and touches it
//            }
//        }
//        .sheet(isPresented: $showingImagePicker) {  // Image Picker for selecting a profile picture
//            ImagePicker(selectedImage: $profileImage)
//        }
//        .onAppear(perform: loadUserData)
//    }
//
//    private func saveProfileChanges() {
//        if let newImage = profileImage {
//            uploadProfileImage(newImage)
//        }
//        isEditing = false
//    }
//
//    private func uploadProfileImage(_ image: UIImage) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
//
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                return
//            }
//
//            storageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Error getting download URL: \(error.localizedDescription)")
//                    return
//                }
//
//                if let urlString = url?.absoluteString {
//                    self.updateUserProfileImageUrl(urlString)
//                }
//            }
//        }
//    }
//
//    private func updateUserProfileImageUrl(_ urlString: String) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let db = Firestore.firestore()
//        db.collection("users").document(userUID).updateData([
//            "profileImageUrl": urlString
//        ]) { error in
//            if let error = error {
//                print("Error updating profile image URL: \(error.localizedDescription)")
//                return
//            }
//
//            print("Profile image URL updated successfully.")
//        }
//    }
//
//    private func loadUserData() {
//        AuthService.shared.fetchUser { user, error in
//            if let error = error {
//                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
//                self.loading = false
//                return
//            }
//            
//            if let user = user {
//                self.username = user.username
//                self.email = user.email
//                self.bio = user.bio ?? ""
//                self.loading = false
//                loadProfileImage(from: user.profileImageUrl)
//            } else {
//                self.errorMessage = "User data not found."
//                self.loading = false
//            }
//        }
//    }
//
//    private func loadProfileImage(from urlString: String) {
//        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading profile image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = uiImage
//                }
//            }
//        }.resume()
//    }
//
//    private func removeProfilePicture() {
//        profileImage = nil
//
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        storageRef.delete { error in
//            if let error = error {
//                print("Error removing image: \(error.localizedDescription)")
//            } else {
//                AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: "") { error in
//                    if let error = error {
//                        print("Error removing profile image URL: \(error.localizedDescription)")
//                    } else {
//                        print("Profile image removed successfully.")
//                    }
//                }
//            }
//        }
//    }
//
//    private func TabBarItem(iconName: String, label: String, destination: AnyView, isSelected: Bool = false) -> some View {
//        VStack {
//            Image(systemName: iconName)
//                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
//            Text(label)
//                .font(.footnote)
//                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
//        }
//        .padding(.vertical, 10)
//        .background(isSelected ? gradientEndColor.opacity(0.2) : Color.clear)  // Highlight background if selected
//        .cornerRadius(10)
//        .onTapGesture {
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                if let window = windowScene.windows.first {
//                    window.rootViewController = UIHostingController(rootView: destination)
//                    window.makeKeyAndVisible()
//                }
//            }
//        }
//    }
//
//    private func initials(for name: String) -> String {
//        let components = name.split(separator: " ")
//        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
//        return String(initials.prefix(2)).uppercased()
//    }
//}
//
//// Correct PersonalInfoRow Declaration
//struct PersonalInfoRow: View {
//    var icon: String
//    var label: String
//    @Binding var text: String
//    var editable: Bool = false
//    var borderColor: Color
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.gray)
//            Text(label)
//                .font(.system(size: 14))
//                .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1)))
//            Spacer()
//            if editable {
//                TextField(label, text: $text)
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
//            } else {
//                Text(text)
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
//            }
//        }
//    }
//}
//
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ProfileView: View {
//    @State private var username: String = ""
//    @State private var email: String = ""
//    @State private var bio: String = ""
//    @State private var profileImage: UIImage? = nil
//    @State private var isEditing: Bool = false
//    @State private var showingImagePicker = false
//    @State private var loading: Bool = true
//    @State private var errorMessage: String? = nil
//    @State private var showRemovePictureAlert = false
//
//    let gradientStartColor = Color(UIColor(red: 141/255, green: 172/255, blue: 225/255, alpha: 1))
//    let gradientEndColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
//    let borderColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
//
//    var body: some View {
//        ZStack {
//            Color.white
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                // Gradient Background Box at the Top with No Space Above
//                ZStack(alignment: .top) {  // Use alignment to ensure the box starts from the top
//                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                        )
//                        .frame(height: 300)
//                        .edgesIgnoringSafeArea(.top)  // Ensure the gradient box touches the top
//
//                    VStack {
//                        Spacer().frame(height: 70)  // Adjust spacing to align profile picture
//
//                        ZStack {
//                            if let image = profileImage {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 100)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                    .onTapGesture {  // Allow adding profile picture when tapped
//                                        showingImagePicker = true
//                                    }
//                            } else {
//                                Text(initials(for: username))
//                                    .font(.largeTitle)
//                                    .foregroundColor(.white)
//                                    .frame(width: 100, height: 100)
//                                    .background(Circle().fill(Color.gray))
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                    .onTapGesture {  // Allow adding profile picture when tapped
//                                        showingImagePicker = true
//                                    }
//                            }
//
//                            if isEditing {
//                                Button(action: {
//                                    showingImagePicker = true
//                                }) {
//                                    Image(systemName: "pencil.circle.fill")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(.blue)
//                                        .background(Circle().fill(Color.white))
//                                        .offset(x: 40, y: -30)
//                                }
//                            }
//                        }
//                    }
//                }
//
//                Spacer().frame(height: 30)
//
//                if loading {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                } else {
//                    VStack(alignment: .leading, spacing: 20) {  // Adjusted alignment for labels
//                        PersonalInfoRow(icon: "person.fill", label: "Name", text: $username, editable: isEditing, borderColor: borderColor)
//                        PersonalInfoRow(icon: "envelope.fill", label: "E-Mail", text: $email, editable: false, borderColor: borderColor)
//                        PersonalInfoRow(icon: "info.circle.fill", label: "Bio", text: $bio, editable: isEditing, borderColor: borderColor)
//                    }
//                    .padding(.horizontal, 30)
//                    .font(.system(size: 16))  // Unified font size
//                    .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1)))  // Label color
//
//                    if isEditing {
//                        Button(action: saveProfileChanges) {
//                            Text("Save Changes")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                        .onTapGesture {
//                            isEditing = false
//                        }
//                    } else {
//                        Button(action: {
//                            isEditing.toggle()
//                        }) {
//                            Text("Edit Profile")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding()
//                    }
//                }
//
//                Spacer()
//
//                // Tab Bar with Highlighted Profile Icon
//                VStack {
//                    Spacer()  // Pushes the tab bar to the bottom
//
//                    HStack {
//                        Spacer()
//                        TabBarItem(iconName: "briefcase", label: "Past Trips", destination: AnyView(SecondView()))
//                        Spacer()
//                        TabBarItem(iconName: "globe", label: "Plan Trip", destination: AnyView(SecondView()))
//                        Spacer()
//                        TabBarItem(iconName: "person.fill", label: "Profile", destination: AnyView(ProfileView()), isSelected: true)  // Highlight profile icon
//                        Spacer()
//                        TabBarItem(iconName: "gearshape", label: "Settings", destination: AnyView(SettingsView()))
//                        Spacer()
//                    }
//                    .frame(height: 72)
//                    .background(Color.white)
//                    .cornerRadius(8)
//                    .shadow(radius: 5)
//                    .padding(.bottom, 0)  // Ensure it is touching the bottom edge
//                }
//                .edgesIgnoringSafeArea(.bottom)  // Ensure the tab bar extends to the bottom and touches it
//            }
//        }
//        .sheet(isPresented: $showingImagePicker) {  // Image Picker for selecting a profile picture
//            ImagePicker(selectedImage: $profileImage)
//        }
//        .onAppear(perform: loadUserData)
//    }
//
//    private func saveProfileChanges() {
//        if let newImage = profileImage {
//            uploadProfileImage(newImage)
//        }
//        isEditing = false
//    }
//
//    private func uploadProfileImage(_ image: UIImage) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
//
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                return
//            }
//
//            storageRef.downloadURL { url, error in
//                if let error = error {
//                    print("Error getting download URL: \(error.localizedDescription)")
//                    return
//                }
//
//                if let urlString = url?.absoluteString {
//                    self.updateUserProfileImageUrl(urlString)
//                }
//            }
//        }
//    }
//
//    private func updateUserProfileImageUrl(_ urlString: String) {
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let db = Firestore.firestore()
//        db.collection("users").document(userUID).updateData([
//            "profileImageUrl": urlString
//        ]) { error in
//            if let error = error {
//                print("Error updating profile image URL: \(error.localizedDescription)")
//                return
//            }
//
//            print("Profile image URL updated successfully.")
//        }
//    }
//
//    private func loadUserData() {
//        AuthService.shared.fetchUser { user, error in
//            if let error = error {
//                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
//                self.loading = false
//                return
//            }
//            
//            if let user = user {
//                self.username = user.username
//                self.email = user.email
//                self.bio = user.bio ?? ""
//                self.loading = false
//                loadProfileImage(from: user.profileImageUrl)
//            } else {
//                self.errorMessage = "User data not found."
//                self.loading = false
//            }
//        }
//    }
//
//    private func loadProfileImage(from urlString: String) {
//        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading profile image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.profileImage = uiImage
//                }
//            }
//        }.resume()
//    }
//
//    private func removeProfilePicture() {
//        profileImage = nil
//
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")
//
//        storageRef.delete { error in
//            if let error = error {
//                print("Error removing image: \(error.localizedDescription)")
//            } else {
//                AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: "") { error in
//                    if let error = error {
//                        print("Error removing profile image URL: \(error.localizedDescription)")
//                    } else {
//                        print("Profile image removed successfully.")
//                    }
//                }
//            }
//        }
//    }
//
//    private func TabBarItem(iconName: String, label: String, destination: AnyView, isSelected: Bool = false) -> some View {
//        VStack {
//            Image(systemName: iconName)
//                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
//            Text(label)
//                .font(.footnote)
//                .foregroundColor(isSelected ? gradientEndColor : .blue)  // Highlight if selected
//        }
//        .padding(.vertical, 10)
//        .background(isSelected ? gradientEndColor.opacity(0.2) : Color.clear)  // Highlight background if selected
//        .cornerRadius(10)
//        .onTapGesture {
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                if let window = windowScene.windows.first {
//                    window.rootViewController = UIHostingController(rootView: destination)
//                    window.makeKeyAndVisible()
//                }
//            }
//        }
//    }
//
//    private func initials(for name: String) -> String {
//        let components = name.split(separator: " ")
//        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
//        return String(initials.prefix(2)).uppercased()
//    }
//}
//
//// Correct PersonalInfoRow Declaration
//struct PersonalInfoRow: View {
//    var icon: String
//    var label: String
//    @Binding var text: String
//    var editable: Bool = false
//    var borderColor: Color
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.gray)
//            Text(label)
//                .font(.system(size: 14))
//                .foregroundColor(Color(UIColor(red: 78/255, green: 115/255, blue: 134/255, alpha: 1)))
//            Spacer()
//            if editable {
//                TextField(label, text: $text)
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
//            } else {
//                Text(text)
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
//            }
//        }
//    }
//}
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var bio: String = "This is a default bio. Edit to tell more about yourself."  // Default bio
    @State private var profileImage: UIImage? = nil
    @State private var isEditing: Bool = false
    @State private var showingImagePicker = false
    @State private var loading: Bool = true
    @State private var errorMessage: String? = nil
    @State private var showRemovePictureAlert = false  // State for showing the remove picture alert
    
    var userUID: String

    let gradientStartColor = Color(UIColor(red: 141/255, green: 172/255, blue: 225/255, alpha: 1))
    let gradientEndColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))
    let borderColor = Color(UIColor(red: 41/255, green: 102/255, blue: 117/255, alpha: 1))

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Gradient Background Box at the Top with No Space Above
                ZStack(alignment: .top) {  // Use alignment to ensure the box starts from the top
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 300)
                        .edgesIgnoringSafeArea(.top)  // Ensure the gradient box touches the top

                    VStack {
                        Spacer().frame(height: 70)  // Adjust spacing to align profile picture

                        ZStack {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .onTapGesture {  // Allow adding profile picture when tapped
                                        showingImagePicker = true
                                    }

                                // "Remove Profile Picture" Text
                                if isEditing {
                                    Text("Remove Profile Picture")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                        .underline()
                                        .padding(.top, 10)  // Adjusted padding for alignment
                                        .offset(y: 60) // Move it further down
                                        .onTapGesture {
                                            showRemovePictureAlert = true
                                        }
                                }
                            } else {
                                Text(initials(for: username))
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 100)
                                    .background(Circle().fill(Color.gray))
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .onTapGesture {  // Allow adding profile picture when tapped
                                        showingImagePicker = true
                                    }
                            }

                            if isEditing {
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                        .background(Circle().fill(Color.white))
                                        .offset(x: 40, y: -30)
                                }
                            }
                        }
                    }
                }

                Spacer().frame(height: 30)

                if loading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    VStack(alignment: .leading, spacing: 20) {  // Adjusted alignment for labels
                        PersonalInfoRow(
                            icon: "person.fill",
                            label: "Name",
                            text: $username,
                            editable: isEditing,
                            headerColor: Color.blue,
                            inputTextColor: gradientEndColor,
                            borderColor: borderColor,
                            fieldHeight: 40
                        )
                        
                        PersonalInfoRow(
                            icon: "envelope.fill",
                            label: "E-Mail",
                            text: $email,
                            editable: isEditing,
                            headerColor: Color.blue,
                            inputTextColor: gradientEndColor,
                            borderColor: borderColor,
                            fieldHeight: 40
                        )
                        
                        PersonalInfoRow(
                            icon: "info.circle.fill",
                            label: "Bio",
                            text: $bio,
                            editable: isEditing,
                            headerColor: Color.blue,
                            inputTextColor: gradientEndColor,
                            borderColor: borderColor,
                            fieldHeight: 80  // Increased height for Bio
                        )
                    }
                    .padding(.horizontal, 30)
                    .font(.system(size: 16))  // Unified font size
                    .foregroundColor(Color.blue)  // Label color

                    if isEditing {
                        Button(action: saveProfileChanges) {
                            Text("Save Changes")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .onTapGesture {
                            isEditing = false
                        }
                    } else {
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text("Edit Profile")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }

                Spacer()

                // Tab Bar with Highlighted Profile Icon
                VStack {
                    Spacer()  // Pushes the tab bar to the bottom

                    HStack {
                        Spacer()
                        TabBarItem(iconName: "briefcase", label: "Past Trips", destination: AnyView(SecondView(userUID: userUID)))
                        Spacer()
                        TabBarItem(iconName: "globe", label: "Plan Trip", destination: AnyView(SecondView(userUID: userUID)))
                        Spacer()
                        TabBarItem(iconName: "person.fill", label: "Profile", destination: AnyView(ProfileView(userUID: userUID)), isSelected: true)  // Highlight profile icon
                        Spacer()
                        TabBarItem(iconName: "gearshape", label: "Settings", destination: AnyView(SettingsView(userUID: userUID)))
                        Spacer()
                    }
                    .frame(height: 72)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.bottom, 0)  // Ensure it is touching the bottom edge
                }
                .edgesIgnoringSafeArea(.bottom)  // Ensure the tab bar extends to the bottom and touches it
            }
        }
        .sheet(isPresented: $showingImagePicker) {  // Image Picker for selecting a profile picture
            ImagePicker(selectedImage: $profileImage)
        }
        .alert(isPresented: $showRemovePictureAlert) {
            Alert(
                title: Text("Remove Profile Picture"),
                message: Text("Are you sure you want to remove your profile picture?"),
                primaryButton: .destructive(Text("Remove")) {
                    removeProfilePicture()  // Remove profile picture
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear(perform: loadUserData)
    }

    private func saveProfileChanges() {
        if let newImage = profileImage {
            uploadProfileImage(newImage)
        }
        isEditing = false
    }

    private func uploadProfileImage(_ image: UIImage) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }

                if let urlString = url?.absoluteString {
                    self.updateUserProfileImageUrl(urlString)
                }
            }
        }
    }

    private func updateUserProfileImageUrl(_ urlString: String) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userUID).updateData([
            "profileImageUrl": urlString
        ]) { error in
            if let error = error {
                print("Error updating profile image URL: \(error.localizedDescription)")
                return
            }

            print("Profile image URL updated successfully.")
        }
    }

    private func loadUserData() {
        AuthService.shared.fetchUser { user, error in
            if let error = error {
                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
                self.loading = false
                return
            }
            
            if let user = user {
                self.username = user.username ?? ""
                self.email = user.email ?? ""
                self.bio = (user.bio ?? "").isEmpty ? "This is a default bio. Edit to tell more about yourself." : user.bio ?? ""
                self.loading = false
                loadProfileImage(from: user.profileImageUrl ?? "")
            } else {
                self.errorMessage = "User data not found."
                self.loading = false
            }
        }
    }

    private func loadProfileImage(from urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading profile image: \(error.localizedDescription)")
                return
            }
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = uiImage
                }
            }
        }.resume()
    }

    private func removeProfilePicture() {
        profileImage = nil

        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(userUID)/profile.jpg")

        storageRef.delete { error in
            if let error = error {
                print("Error removing image: \(error.localizedDescription)")
            } else {
                AuthService.shared.updateUserProfileData(userUID: userUID, username: self.username, profileImageUrl: "") { error in
                    if let error = error {
                        print("Error removing profile image URL: \(error.localizedDescription)")
                    } else {
                        print("Profile image removed successfully.")
                    }
                }
            }
        }
    }

    private func TabBarItem(iconName: String, label: String, destination: AnyView, isSelected: Bool = false) -> some View {
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
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = UIHostingController(rootView: destination)
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    private func initials(for name: String) -> String {
        let components = name.split(separator: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }.joined()
        return String(initials.prefix(2)).uppercased()
    }
}

// Updated PersonalInfoRow Declaration
struct PersonalInfoRow: View {
    var icon: String
    var label: String
    @Binding var text: String
    var editable: Bool = false
    var headerColor: Color
    var inputTextColor: Color
    var borderColor: Color
    var fieldHeight: CGFloat  // Added parameter for field height

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(label)
                .font(.system(size: 14, weight: .bold))  // Thicker blue font
                .foregroundColor(headerColor)
            Spacer()
            if editable {
                TextField(label, text: $text)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
                    .foregroundColor(inputTextColor)  // Use the specific gradient color for input text
                    .frame(height: fieldHeight)  // Consistent size for all text fields
                    .frame(maxWidth: .infinity)  // Same width
                    .multilineTextAlignment(.center)  // Center the text in text fields
            } else {
                Text(text)  // Show only the text without repeating the label
                    .font(.system(size: 16))
                    .foregroundColor(inputTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .padding(.vertical, 5)
    }
       
}


