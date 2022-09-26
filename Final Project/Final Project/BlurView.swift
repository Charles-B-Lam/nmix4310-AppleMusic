//
//  BlurView.swift
//  Final Project
//
//  Created by Charles B Lam on 5/9/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}

