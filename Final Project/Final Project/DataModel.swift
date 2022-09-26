//
//  DataModel.swift
//  Final Project
//
//  Created by Charles B Lam on 5/8/22.
//

import Foundation

// url we will build looks something like this:
// https://itunes.apple.com/search?term=coldplay&entity=song

// this is where we will have methods that will send a request to get the data from the API
class DataModel {
    
    // will hold the acutal data task url session
    private var dataTask: URLSessionDataTask?
    
    /*
     * We are going to add a method that will load these songs from the api
     * and so we are going to add the method that actually creates this url and sends the request.
     *
     * @param searchTerm the term searched by the user
     * @param completion block (another method) - that the caller of the method will provide and this completion block will be called when the request either suceeds or fails (no return type: just void).
     */
    func loadSongs(searchTerm: String, completion: @escaping(([Song]) -> Void)) {
        // cancel any task that may have been executing when this method is called
        dataTask?.cancel()
        
        // next try and create the url based on this search term using the helper method created below
        guard let url = buildUrl(forTerm: searchTerm) else {
            // if we were not able to build this url then we are going to call the completion block with an empty list and we are going to return
            completion([])
            return
        }
        
        // if we're able to build this url then what we're going to do is create a new data task and resume the data task
        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                // if we are not able to get this data from the api then what we'll do is again call the completion handler with an empty list
                completion([])
                return
            }
            
            // if we are able to get the data, then what we'll do is try to decode it from the json format into a song response and we are going to call the completion handler with the list of songs
            if let songResponse = try? JSONDecoder().decode(SongResponse.self, from: data) {
                completion(songResponse.songs)
            }
        }
        // now that we have our dataTask all that we have to do is resume it
        dataTask?.resume()
    }
    
    
    /*
     * and a helper method that will build the URL based on the search term that
     * the user entered.
     *
     * @param searchTerm the term we want to search for
     * @Returns a URL or nil if the url wasn't able to be built
     */
    private func buildUrl(forTerm searchTerm: String) -> URL? {
        guard !searchTerm.isEmpty else {
            return nil
        } // guard (makes sure the search term is not empty)
        
        // now we are going to create a list of query items and this query item is basically each of the parameters we passed into the url. One for the term parameter in the url and the entity parameter.
        let queryItems = [
            URLQueryItem(name: "term", value: searchTerm), // add the first item
            URLQueryItem(name: "entity", value: "song"), // the entity we want need to be of type song
        ]
        
        // now that we have the query items, WE CAN BUILD THE URL
        // components variable will hold the URL
        var components = URLComponents(string: "https://itunes.apple.com/search?")
        // add the query items to the components
        components?.queryItems = queryItems
        
        return components?.url
    }
}


// after looking at how the data structured in the API, we can build structures that comforms to the data of the api

// the structure for the whole response (list of results)
// Decodable because we will use a JSON decoder to decode the text that the api gives us
struct SongResponse: Decodable {
    let songs: [Song] // will store the songs in an array called songs
    
    enum CodingKeys: String, CodingKey {
        case songs = "results"
    }
} // SongResponse

// in these response, we are going to have a list of songs, so in each song we are going to have 4 properties
// This struct will represent each song in the results array in the API
struct Song: Decodable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl: String
    let musicUrl: String
    
    // map the variables to the correct property in the api
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl = "artworkUrl60"
        case musicUrl = "previewUrl"
    } // CodingKeys
}
