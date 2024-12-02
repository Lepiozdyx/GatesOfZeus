//
//  FontsView.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

extension Text {
    func customFont(
        size: CGFloat,
        color: Color,
        strokeWidth: CGFloat = 1,
        strokeColor: Color = .secondary
    ) -> some View {
        ZStack {
            ForEach(0..<4) { i in
                self
                    .font(.system(size: size, weight: .heavy))
                    .foregroundColor(strokeColor)
                    .offset(x: strokeWidth * CGFloat([-1, 1, 0, 0][i]),
                            y: strokeWidth * CGFloat([0, 0, -1, 1][i]))
            }
            
            self
                .font(.system(size: size, weight: .heavy))
                .foregroundColor(color)
        }
    }
}

struct FontView: View {
    var body: some View {
        Text("LOADING...")
            .customFont(
                size: 80,
                color: .softGold,
                strokeWidth: 2,
                strokeColor: .softBrown
            )
    }
}

#Preview {
    FontView()
}
