//
//  LoadingView.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            BackgroundView(imageName: .temple)
            
            VStack(spacing: 20) {
                Image(.loadingbolt)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                    .scaleEffect(isAnimating ? 1 : 0.9)
                    .opacity(isAnimating ? 1 : 0.9)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Text("LOADING...")
                    .customFont(size: 40, color: .softGold, strokeWidth: 2, strokeColor: .softBrown)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
}
