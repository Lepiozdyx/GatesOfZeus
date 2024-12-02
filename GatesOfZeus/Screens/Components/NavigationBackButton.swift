//
//  NavigationBackButton.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct NavigationBackButton: View {
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(.backButton)
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    NavigationBackButton(action: {})
}
