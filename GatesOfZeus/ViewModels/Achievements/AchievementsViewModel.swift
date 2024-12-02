//
//  AchievementsViewModel.swift
//  GatesOfZeus
//
//  Created by Alex on 21.11.2024.
//

import SwiftUI

@MainActor
final class AchievementsViewModel: ObservableObject {
    @Published private(set) var currentIndex = 0
    private let allAchievements = Achievement.allCases
    
    var canGoBack: Bool {
        currentIndex > 0
    }
    
    var canGoForward: Bool {
        currentIndex < allAchievements.count - 1
    }
    
    var currentAchievement: Achievement? {
        guard currentIndex < allAchievements.count else { return nil }
        return allAchievements[currentIndex]
    }
    
    var isCurrentAchievementUnlocked: Bool {
        guard let currentAchievement = currentAchievement else { return false }
        return AchievementsManager.shared.isUnlocked(currentAchievement)
    }
    
    func nextAchievement() {
        guard canGoForward else { return }
        withAnimation {
            currentIndex += 1
        }
        SoundManager.shared.playSound(.click)
    }
    
    func previousAchievement() {
        guard canGoBack else { return }
        withAnimation {
            currentIndex -= 1
        }
        SoundManager.shared.playSound(.click)
    }
}
