//
//  storage.swift
//  Final Project
//
//  Created by Charles B Lam on 5/9/22.
//

import SwiftUI
import AVFoundation

var allsongs = [
    songs(artist: "Drake", songTitle: "Hold On, We're Going Home (feat. Majid Jordan)", artistImage: "Hold On, We're Going Home", soundFile: "HoldOn,We'reGoingHome.m4a", index: 0),
        songs(artist: "Drake", songTitle: "Best I Ever Had", artistImage: "Best I Ever Had", soundFile: "BestIEverHad.m4a", index: 1),
        songs(artist: "Drake", songTitle: "Headlines", artistImage: "Headlines", soundFile: "Headlines.m4a", index: 2),
        songs(artist: "Future", songTitle: "Where Ya At (feat. Drake)", artistImage: "Where Ya At", soundFile: "WhereYaAt.m4a", index: 3),
        songs(artist: "Drake", songTitle: "One Dance (feat. Wizkid & Kyla)", artistImage: "One Dance", soundFile: "OneDance.m4a", index: 4),
        songs(artist: "Nicki Minaj", songTitle: "Truffle Butter (feat. Drake & Lil Wayne)", artistImage: "Truffle Butter", soundFile: "TruffleButter.m4a", index: 5),
        songs(artist: "Drake", songTitle: "The Motto (feat. Lil Wayne) [Bonus Track]", artistImage: "The Motto", soundFile: "TheMotto.m4a", index: 6),
        songs(artist: "DJ Khaled", songTitle: "I'm On One (feat. Drake, Rick Ross & Lil Wayne)", artistImage: "I'm On One", soundFile: "I'mOnOne.m4a", index: 7),
        songs(artist: "Lil Wayne", songTitle: "Believe Me (feat. Drake)", artistImage: "Believe Me", soundFile: "BelieveMe.m4a", index: 8),
        songs(artist: "Big Sean", songTitle: "Blessings (feat. Drake)", artistImage: "Blessings", soundFile: "Blessings.m4a", index: 9),
        songs(artist: "Drake, Kanye West, Lil Wayne & Eminem", songTitle: "Forever", artistImage: "Forever", soundFile: "Forever.m4a", index: 10),
        songs(artist: "Drake", songTitle: "Hotline Bling", artistImage: "Hotline Bling", soundFile: "HotlineBling.m4a", index: 11)
   ]

struct songs: Identifiable {
    var id = UUID()
    var artist : String
    var songTitle : String
    var artistImage : String
    var soundFile : String
    var index : Int
} // struct states: Identifiable

func playsound (thesong: String){
    let thepath = Bundle.main.path(forAuxiliaryExecutable: thesong)!
    let url = URL(fileURLWithPath: thepath)
    do {
        twist = try AVAudioPlayer(contentsOf: url)
        twist?.play()
    } catch {
        // couldn't load file :(
    } // do-catch
} // func playsound

func paws(){
    twist?.pause()
} // func paws

func player(){
    twist?.play()
} // func player

func skip(theSongIndex: Int){
//    if (theSongIndex >= allsongs.length) {
//
//    } // if
    
} // skip
