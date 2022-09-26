//
//  ContentView.swift
//  Final Project
//
//  Created by Charles B Lam on 5/8/22.
//

import SwiftUI
import AVFoundation

var twist: AVAudioPlayer?
struct ContentView: View {
    @State var current = 0
    @State var currentSongIndex = 0
    
    // miniplayer property
    @State var expandMiniPlayer = false
    @State var playPressed = false
    
    @Namespace var animation
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            TabView(selection: $current) {
                NavigationView {
                    List(allsongs) { song in
                        Button(action: {
                            playsound(thesong: song.soundFile)
                            currentSongIndex = song.index
                            playPressed = false // to make the miniplayer disc spin
                        }) {
                            BasicImageRow(song: song)
                        } // Button
                        .listStyle(.plain)
                    } // List
                    .navigationTitle("Hip-Hop Songs")
                } // NavView
                    .tag(0)
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Library")
                    }
                SearchMusic(viewModel: SongListViewModel())
                    .tag(1)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
            }
            MiniPlayer(currentSongIndex: $currentSongIndex, expandMiniPlayer: $expandMiniPlayer, playPressed: $playPressed)
        })
    } // body: some View
} // ContentView: View


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BasicImageRow: View {
    var song: songs
    var body: some View {
        HStack {
            Image(song.artistImage)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text(song.songTitle)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
                Text(song.artist)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
            } // VStack
        } // HStack
    } // body: some View
} // BasicImageRow: View

struct ButtonsView: View {
    @Binding var currentSongIndex : Int
    @Binding var expandMiniPlayer : Bool
    @Binding var playPressed : Bool
    var body: some View {
        HStack(spacing: 11.0) {
            Button(action: { // previous song button
                // if at the first song, doesn't allow to play the previos songs. It just pauses
                if (currentSongIndex == 0) {
                    currentSongIndex = 0
                    paws()
                } else {
                    currentSongIndex = currentSongIndex - 1
                    playsound(thesong: allsongs[currentSongIndex].soundFile)
                } // if-else
            }) {
                Image(systemName: "backward.fill")
                    .font(.system(size: expandMiniPlayer ? 25 : 20))
            } // Button
            
            Button(action: {
                playPressed = false
                paws()
            }) { // pause button
                Image(systemName: "pause.fill")
                    .font(.system(size: expandMiniPlayer ? 40 : 30))
            } // Button
            
            Button(action: {
                player()
                playPressed = true
                if (currentSongIndex == 0) {
                    playsound(thesong: allsongs[currentSongIndex].soundFile)
                } // if
            }) { // play button
                Image(systemName: "play.fill")
                    .font(.system(size: expandMiniPlayer ? 40 : 30))
            } // Button
            
            Button(action: { // skip button
                //skip(theSongIndex: currentSongIndex)
                if (allsongs.count == currentSongIndex + 1){
                    // reset the song index back to 0
                    currentSongIndex = -1 // b/c when skip button is pressed it will add 1, so index restart to 0 at start
                } // if
                currentSongIndex = currentSongIndex + 1
                playsound(thesong: allsongs[currentSongIndex].soundFile)
            }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: expandMiniPlayer ? 25: 20))
            } // Button
        } // Hstack
    }
}

struct MiniPlayer: View {
    @Binding var currentSongIndex : Int
    @Binding var expandMiniPlayer : Bool
    //var animation: Namespace.ID
    @Binding var playPressed : Bool
    
    var height = UIScreen.main.bounds.height / 3
    var body: some View {
        VStack {
            HStack {
                
                // if the miniPlayer is currently not in use
                if !expandMiniPlayer {
                    Image(allsongs[currentSongIndex].artistImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: expandMiniPlayer ? height: 40, height: expandMiniPlayer ? height: 40)
                        .cornerRadius(5)
                    
                    Spacer(minLength: 0)
                    Text(allsongs[currentSongIndex].songTitle)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                    Spacer()
                    ButtonsView(currentSongIndex: $currentSongIndex, expandMiniPlayer: $expandMiniPlayer, playPressed: $playPressed)
                } // if
                
                // miniPlayer in use
                if expandMiniPlayer {
                    // centering Image...
                    Spacer(minLength: 0)
                    VStack {
                        ZStack {
                            Image("player")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .font(.system(size: 10))
                                .frame(width: 100, height: 420)
                                .offset(x:7, y: -30)
                            Image("Disk")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: expandMiniPlayer ? height: 100, height: expandMiniPlayer ? height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle() // gray portion
                                        .stroke(Color(.black), lineWidth: 25)
                                        .frame(width: 260, height: 260)
                                )
                                .rotationEffect(Angle(degrees: playPressed ? 360 : 0))
                            // If you want to change the speed of the animation, you can use the linear animation and specify a duration like this:
                            // The greater the duration value the slower the animation (rotation).
                                .animation(playPressed ? Animation.linear(duration: 5).repeatForever(autoreverses: false) : .default) // to stop the repeatForever animation use .default animation when playPressed is false
                                .onAppear() { // onAppear modifier may be new to you
                                    self.playPressed = true
                                } // onAppear
                            
                            Image(allsongs[currentSongIndex].artistImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .font(.system(size: 10))
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .rotationEffect(Angle(degrees: playPressed ? 360 : 0))
                                .animation(playPressed ? Animation.linear(duration: 5).repeatForever(autoreverses: false) : .default)// The greater the duration value the slower the animation (rotation).
                                .onAppear() { // onAppear modifier may be new to you
                                    self.playPressed = true
                                } // onAppear
                        } // ZStack
                    ButtonsView(currentSongIndex: $currentSongIndex, expandMiniPlayer: $expandMiniPlayer, playPressed: $playPressed)
                        Text("Not Spinning? Hit the pause then play button to make the disc spin again in the miniplayer.")
                            .padding(.top)
                        Text("Or if disc is spinning when it's not supposed to. Hit pause in the miniplayer to make the disc stop spinning")
                            .padding(.top)
                        
                    } // VStack
                    Spacer(minLength: 0)
                } // if
            } // HStack
            .padding(.horizontal)
        } // VStack
        // expanding to full screen when clicked...
        .frame(width: .infinity) // width frame of the miniplayer
        .frame(height: expandMiniPlayer ? 1000 : 80) // height of the miniplayer section
        .background(BlurView()) // background of mini-player
        .onTapGesture(perform: {
            withAnimation(.spring()) {
                expandMiniPlayer.toggle()
            } // withAnimation
        }) // onTapGesture // when the VStack is pressed on
        .ignoresSafeArea()
        .offset(y: expandMiniPlayer ? 0 : -49) // moves the VStack to the middle
    }
}
