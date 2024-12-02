//
//  MenuButton.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct MenuButton: View {
    let image: ImageResource
    let text: String
    let size: CGFloat
    let textSize: CGFloat
    let color: Color
    var isCounter = false
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .overlay {
                Text(text)
                    .customFont(size: textSize, color: color)
                    .multilineTextAlignment(.center)
                    .offset(x: isCounter ? 10 : 0)
            }
    }
}

#Preview {
    MenuButton(image: .goldenUnderlay, text: "TEXT", size: 260, textSize: 25, color: .softGold)
}
