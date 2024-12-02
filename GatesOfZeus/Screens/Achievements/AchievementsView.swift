//
//  AchievementsView.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel = AchievementsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView(imageName: .bg)
            
            GeometryReader { geometry in
                let maxWidth = geometry.size.width
                let maxHeight = geometry.size.height
                let titleFontSize = maxWidth * 0.05
                let buttonSize = min(maxWidth, maxHeight) * 0.1
                let textSize = buttonSize * 0.3
                let imageSize = min(maxWidth, maxHeight) * 0.5
                
                VStack {
                    // Header
                    HStack {
                        NavigationBackButton {
                            navigationManager.navigateBack()
                        }
                        
                        Spacer()
                        
                        Text("TEMPLE OF ACHIEVEMENTS")
                            .customFont(
                                size: titleFontSize,
                                color: .softPurple,
                                strokeWidth: 1.5,
                                strokeColor: .black
                            )
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Achievements content
                    HStack {
                        // Previous button
                        Button {
                            viewModel.previousAchievement()
                        } label: {
                            Image(.arrowButton)
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                        }
                        
                        // Achievement content
                        if let achievement = viewModel.currentAchievement {
                            VStack {
                                ZStack {
                                    achievementImage(for: achievement)
                                        .frame(width: imageSize, height: imageSize)
                                        .opacity(viewModel.isCurrentAchievementUnlocked ? 1 : 0.5)
                                    
                                    if !viewModel.isCurrentAchievementUnlocked {
                                        Text("ACHIEVEMENT NOT UNLOCKED")
                                            .customFont(
                                                size: textSize,
                                                color: .softGold,
                                                strokeWidth: 1.5,
                                                strokeColor: .black
                                            )
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                }
                                
                                Text(achievement.title.uppercased())
                                    .customFont(
                                        size: textSize,
                                        color: .black,
                                        strokeWidth: 1.5,
                                        strokeColor: .softPurple
                                    )
                                
                                Text(achievement.description.uppercased())
                                    .customFont(
                                        size: textSize,
                                        color: .softPurple
                                    )
                            }
                            .transition(.opacity)
                        }
                        
                        // Next button
                        Button {
                            viewModel.nextAchievement()
                        } label: {
                            Image(.arrowButton)
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                                .rotationEffect(Angle(degrees: 180))
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: maxWidth, height: maxHeight)
            }
        }
    }
    
    private func achievementImage(for achievement: Achievement) -> some View {
        Group {
            switch achievement {
            case .masterOfLightning:
                Image(.masterOfLightning)
                    .resizable()
                    .scaledToFit()
            case .gateKeeper:
                Image(.gateKeeper)
                    .resizable()
                    .scaledToFit()
            case .lordOfZeus:
                Image(.lordOfZeus)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    AchievementsView()
        .environmentObject(NavigationManager())
}
