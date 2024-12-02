//
//  AchievementsManager.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import Foundation

enum Achievement: String, CaseIterable {
    case masterOfLightning
    case gateKeeper
    case lordOfZeus
    
    var title: String {
        switch self {
        case .masterOfLightning:
            return "Master of Lightning"
        case .gateKeeper:
            return "Gate Keeper"
        case .lordOfZeus:
            return "Lord of Zeus"
        }
    }
    
    var description: String {
        switch self {
        case .masterOfLightning:
            return "Collect 100 coins"
        case .gateKeeper:
            return "Collect 300 coins"
        case .lordOfZeus:
            return "Collect 1000 coins"
        }
    }
}

@MainActor
final class AchievementsManager: ObservableObject {
    private enum Keys: String {
        case achievements
    }
    
    static let shared = AchievementsManager()
    
    @Published private(set) var unlockedAchievements: Set<Achievement> {
        didSet {
            let achievementStrings = unlockedAchievements.map { $0.rawValue }
            UserDefaults.standard.set(achievementStrings, forKey: Keys.achievements.rawValue)
        }
    }
    
    private init() {
        let savedAchievements = UserDefaults.standard.stringArray(forKey: Keys.achievements.rawValue) ?? []
        self.unlockedAchievements = Set(savedAchievements.compactMap { Achievement(rawValue: $0) })
    }
    
    func unlock(_ achievement: Achievement) {
        unlockedAchievements.insert(achievement)
    }
    
    func isUnlocked(_ achievement: Achievement) -> Bool {
        unlockedAchievements.contains(achievement)
    }
}
