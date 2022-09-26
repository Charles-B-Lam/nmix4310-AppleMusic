//
//  SongListViewModel.swift
//  Final Project
//
//  Created by Charles B Lam on 5/8/22.
//

import Foundation
import SwiftUI
import Combine
// now that we have our data model class and implementation, we are going to add our view model where we will call these load songs method and we will return the results to our view to display in the app

// we added this file to hold the view model and we are going to have 2 classes. The first class represents the view model for a single song and then we're going to add the class to represent the viewmodel for all of the results of a search


class SongListViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published public private(set) var songs: [SongViewModel] = []
    
    private let dataModel: DataModel = DataModel() // we are going to have a dataModel object that we will use to load the data from the api
    private let artworkLoader: ArtworkLoader = ArtworkLoader()
    private var disposables = Set<AnyCancellable>()
    
    
    // we are going to have an observation set up so whenever search term changes, we update the song view model list which will in turn update our content view or the UI of our app
    init() {
        $searchTerm
            .sink(receiveValue: loadSongs(searchTerm:))
            .store(in: &disposables)
    }
    
    private func loadSongs(searchTerm: String) {
        songs.removeAll() // empty the list to remove any songs that we had there previously
        artworkLoader.reset()
        dataModel.loadSongs(searchTerm: searchTerm) { songs in
            songs.forEach { self.appendSong(song: $0)}
        }
    }
    
    private func appendSong(song: Song) {
        let songViewModel = SongViewModel(song: song)
        DispatchQueue.main.async {
            self.songs.append(songViewModel)
        }
        
        artworkLoader.loadArtwork(forSong: song) { image in
            DispatchQueue.main.async {
                songViewModel.artwork = image
            }
        }
    }
}

// This SongViewModel will have 4 properties.
class SongViewModel: Identifiable, ObservableObject {
    let id: Int
    let trackName: String
    let artistName: String
    let musicUrl: String
    
    // this will have a published property b/c when we get the results for each song, we have a url to get the artwork. So what we'll do is return the results for the songs to our view and then load the artworks and update the view as these artworks become available.
    @Published var artwork: Image?
    
    // when a song view model is initialized we are going to take in a song model and we are going to assign our properties based on the data in the model
    init(song: Song) {
        self.id = song.id
        self.trackName = song.trackName
        self.artistName = song.artistName
        self.musicUrl = song.musicUrl
    }
    
    // so now that we have our song viewmodel we are going to add the viewmodel to represent all of the results of a call to the api so we are going to add a new class above
}
