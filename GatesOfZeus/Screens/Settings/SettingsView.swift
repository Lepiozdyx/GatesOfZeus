//
//  SettingsView.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var vm = SettingsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView(imageName: .bg)
            
            GeometryReader { geometry in
                let maxWidth = geometry.size.width
                let maxHeight = geometry.size.height
                let titleFontSize = maxWidth * 0.05
                let toggleSize = maxWidth * 0.35
                let toggleTextSize = toggleSize * 0.1
                let spacing = maxWidth * 0.1
                
                VStack {
                    HStack {
                        NavigationBackButton {
                            navigationManager.navigateBack()
                        }
                        
                        Spacer()
                        
                        Text("SETTINGS")
                            .customFont(
                                size: titleFontSize,
                                color: .softPurple,
                                strokeWidth: 1.5,
                                strokeColor: .black
                            )
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: spacing) {
                        CustomToggle(
                            image: .musicButton,
                            name: "MUSIC",
                            isOn: vm.isMusicEnabled,
                            size: toggleSize,
                            textSize: toggleTextSize
                        ) { vm.toggleMusic() }
                        
                        CustomToggle(
                            image: .soundButton,
                            name: "SOUND",
                            isOn: vm.isSoundEnabled,
                            size: toggleSize,
                            textSize: toggleTextSize
                        ) { vm.toggleSound() }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: maxWidth, height: maxHeight)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationManager())
}
