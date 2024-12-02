//
//  SettingsButton.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct SettingsButton: View {
    let image: ImageResource
    let name: String
    let size: CGFloat
    let textSize: CGFloat
    let color: Color
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.5)
            
            VStack {
                Text(name)
                    .customFont(size: textSize, color: color)
            }
        }
    }
}

#Preview {
    SettingsButton(image: .settingsButton, name: "SETTINGS", size: 200, textSize: 18, color: .softPurple)
}
