//
//  SearchMusic.swift
//  Final Project
//
//  Created by Charles B Lam on 5/9/22.
//

import SwiftUI

struct SearchMusic: View {
    @ObservedObject var viewModel: SongListViewModel
    @State var favoriteSongs = [SongViewModel]() // will store the songs in an array called songs
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchTerm: $viewModel.searchTerm)
                if viewModel.songs.isEmpty {
                    EmptyStateView()
                } else {
                    List(viewModel.songs) { song in
                        if #available(iOS 14.0, *) {
                            Link(destination: URL(string: song.musicUrl)!){
                                SongView(song: song, favoriteSongs: $favoriteSongs)
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    .listStyle(PlainListStyle())
                } // if-else
                NavigationLink(destination: favoriteView(favoriteSongs: $favoriteSongs)) {
                    HStack {
                        Text("Favorite Songs")
                            .font(.system(size: 20))
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30))
                    }
                } // Game Time Navigation Link
            } // VStack
            .padding(.bottom, 100.0)
            .navigationBarTitle("Discover New Music")
        } // NavView
    } // body
} // contentView

struct favoriteView: View {
    @Binding var favoriteSongs: [SongViewModel] // will store the songs in an array called songs
    var body: some View {
        VStack {
            Text("Favorited Songs")
                .font(.title2)
            List(favoriteSongs) { favoriteSong in
                HStack {
                    ArtworkView(image: favoriteSong.artwork)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text(favoriteSong.trackName)
                        Text(favoriteSong.artistName)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    } // VStack
                } // HStack
            } // List
            Button(action: {
                favoriteSongs.removeAll()
            }) {
                Text("Clear All Favorites")
            } // Button
        } // VStack
        .padding(.bottom, 100.0)
    } // body
} // favorite

struct SongView: View {
    @ObservedObject var song: SongViewModel
    @Binding var favoriteSongs: [SongViewModel]
    var body: some View {
        HStack {
            ArtworkView(image: song.artwork)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(song.trackName)
                Text(song.artistName)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(song.musicUrl)
            }
            Button(action: {
                favoriteSongs.append(song)
            }) {
                Image(systemName: "heart")
            } // Button
        } // HStack
        .padding()
    } // body
} // SongView

struct ArtworkView: View {
    let image: Image?
    
    var body: some View {
        ZStack {
            if image != nil {
                image
            } else {
                Color(.red)
                Image(systemName: "music.note")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 50, height: 50)
        .shadow(radius: 5)
        .padding(.trailing, 5)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "music.note")
                .font(.system(size: 85))
                .padding(.bottom)
            Text("Start searching for music...")
                .font(.title)
            Spacer()
        }
        .padding()
        .foregroundColor(Color(.red))
    } // body
} // emptyState View

// allows us to embed our UIKit View inside our swiftUI View
struct SearchBar: UIViewRepresentable {
    // tells xcode which type of UIView these UIVIewRepresentable will hold
    typealias UIViewType = UISearchBar
    
    // has a context and returns UISearchBar
    // The search bar will be constructed here and so we can use this view inside content view
    @Binding var searchTerm: String
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Type a song, artist, or album name..."
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
    }
    
    func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(searchTerm: $searchTerm)
    }
    
    class SearchBarCoordinator: NSObject, UISearchBarDelegate {
        @Binding var searchTerm: String
        
        init(searchTerm: Binding<String>) {
            self._searchTerm = searchTerm
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchTerm = searchBar.text ?? ""
            UIApplication.shared.windows.first { $0.isKeyWindow}?.endEditing(true)
        }
    }
} // SearchBar


struct SearchMusic_Previews: PreviewProvider {
    static var previews: some View {
        SearchMusic(viewModel: SongListViewModel())
    }
}
