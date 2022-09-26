//
//  Miniplayer.swift
//  Final Project
//
//  Created by Charles B Lam on 5/9/22.
//

import SwiftUI

struct Miniplayer: View {
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image("Headlines")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .cornerRadius(15)
                
                Text("Drake")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer(minLength: 0)
                
                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                })
                
                Button(action: {}, label: {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                })
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
        .background(
            
            VStack(spacing: 0) {
                BlurView()
                Divider()
            }
            
        )
        .offset(y: -48)
    }
}

struct Miniplayer_Previews: PreviewProvider {
    static var previews: some View {
        Miniplayer()
    }
}
