//
//  BackgroundView.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct BackgroundView: View {
    let imageName: ImageResource
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView(imageName: .temple)
}
