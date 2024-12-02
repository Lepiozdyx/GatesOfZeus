//
//  CustomToggle.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct CustomToggle: View {
    let image: ImageResource
    let name: String
    let isOn: Bool
    let size: CGFloat
    let textSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                SettingsButton(
                    image: image,
                    name: name,
                    size: size,
                    textSize: textSize,
                    color: .yellow
                )
                .opacity(isOn ? 1 : 0.5)
                
                Text(isOn ? "ON" : "OFF")
                    .customFont(size: textSize * 0.5, color: .softBrown)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CustomToggle(
        image: .soundButton,
        name: "SOUND",
        isOn: true,
        size: 200,
        textSize: 18,
        action: {
        })
}
