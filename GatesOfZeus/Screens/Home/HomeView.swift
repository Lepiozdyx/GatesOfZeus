//
//  HomeView.swift
//  GatesOfZeus
//
//  Created by Alex on 18.11.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @ObservedObject private var coinsManager = CoinsManager.shared
    @State private var showOrientationAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView(imageName: .temple2)
            
            GeometryReader { geometry in
                let maxWidth = geometry.size.width
                let maxHeight = geometry.size.height
                let buttonSize = min(maxWidth, maxHeight) * 0.4
                let textSize = buttonSize * 0.075
                
                VStack(alignment: .center, spacing: buttonSize * 0.2) {
                    CoinsMenuButton(size: buttonSize, textSize: textSize)
                    
                    HStack(spacing: buttonSize * 0.2) {
                        Button {
                            navigationManager.navigate(to: .lightning)
                        } label: {
                            MenuButton(
                                image: .goldenUnderlay,
                                text: "ZEUS'S LIGHTNING",
                                size: buttonSize,
                                textSize: textSize,
                                color: .softGold
                            )
                        }
                        
                        Button {
                            navigationManager.navigate(to: .gates)
                        } label: {
                            MenuButton(
                                image: .goldenUnderlay,
                                text: "ENTER THE GATES",
                                size: buttonSize,
                                textSize: textSize,
                                color: .softGold
                            )
                        }
                    }
                    
                    Button {
                        navigationManager.navigate(to: .achievements)
                    } label: {
                        MenuButton(
                            image: .purpleUnderlay,
                            text: "TEMPLE OF ACHIEVEMENTS",
                            size: buttonSize,
                            textSize: textSize,
                            color: .softPurple
                        )
                    }
                    
                    HStack(spacing: buttonSize * 0.2) {
                        Button {
                            navigationManager.navigate(to: .settings)
                        } label: {
                            SettingsButton(
                                image: .settingsButton,
                                name: "SETTINGS",
                                size: buttonSize,
                                textSize: textSize,
                                color: .softPurple
                            )
                        }
                        
                        Button {
                            navigationManager.navigate(to: .rules)
                        } label: {
                            SettingsButton(
                                image: .rulesButton,
                                name: "RULES",
                                size: buttonSize,
                                textSize: textSize,
                                color: .softPurple
                            )
                        }
                    }
                }
                .frame(width: maxWidth, height: maxHeight)
            }
        }
        .onAppear {
            if !OrientationManager.shared.isOrientationAlertShown {
                showOrientationAlert = true
                OrientationManager.shared.isOrientationAlertShown = true
            }
        }
        .alert("A little tip!", isPresented: $showOrientationAlert) {
            Button("OK") { }
        } message: {
            Text("Play in landscape orientation for a better gaming experience")
        }
    }
}

#Preview {
    HomeView()
}
