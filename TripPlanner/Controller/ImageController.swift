//
//  ImageController.swift
//  TripPlanner
//
//  Created by Wen Li on 7/23/24.
//  Used Unsplash API for fetching images
//  https://unsplash.com/developers
//
// Next step !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// - increasing the accuracy of the image searching
//   1) enhance the accuracy of the location (adding city? country?)
//   2) enhance the accuracy of the query (making the query more specific)
//   3) adjust search parameters (set the orientation to landscape, portrait, or squarish to get images with specific
//      orientations, or use content_filter to filter out sensitive content)
//   4) use Unsplash Collections (high-quality)
//   5) implement a relevance check function (refer to chatGPT)


import Foundation
import SwiftUI

// this class is responsible for fetching images from the Unsplash API
class ImageController: ObservableObject {
    // an ImageController instance for shared usage
    static let shared = ImageController()
    private init() {}
    
    // unsplash API access key
    var token = "DSGVIqrflJklVgCo2cqZ6gyBhm-xSvZk99P-jfIL9Dc"
    // published results array to store fetched results
    @Published var results = [Result]()
    
    // this function is to search images based on a location
    func search(for location: String, completion: @escaping (String?) -> Void) {
        // construct the URL string with a search query
        let urlString = "https://api.unsplash.com/search/photos?query=\(location)&orientation=landscape"
        // if the url failed to generated, return directly
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        // create a URLRequest object with the URL
        var request = URLRequest(url: url)
        // set the HTTP method to GET
        request.httpMethod = "GET"
        // set the authorization header
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        // create a data task to perform the network request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // ensure data is not nil. if nil, return
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                // decode the JSON response into a Results object
                let res = try JSONDecoder().decode(Results.self, from: data)
                // get the URL of the first image in the result
                let imageUrl = res.results.first?.urls.small
                // call the completion handler with the image URL
                completion(imageUrl)
            } catch {
                // if decoding fails, return
                completion(nil)
                print(error)
            }
        }
        // start the data task
        task.resume()
    }
}

// struct to represent the JSON response from the Unsplash API
struct Results: Decodable {
    // total number of results
    var total: Int
    // array of Result objects
    var results: [Result]
}

// struct to represent a single result from the Unsplash API
struct Result: Decodable {
    // ID of the result
    var id: String
    // description of the result/image (option)
    var description: String?
    // URLs object obtaining different sizes of the image
    var urls: URLs
}

// struct to represent the URLs of an image
struct URLs: Decodable {
    // we are using the small version of the image
    var small: String
}
