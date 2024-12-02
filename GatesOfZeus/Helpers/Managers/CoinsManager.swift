//
//  CoinsManager.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import Foundation

@MainActor
final class CoinsManager: ObservableObject {
    private enum Keys: String {
        case balance
    }
    
    static let shared = CoinsManager()
    
    @Published private(set) var balance: Int {
        didSet {
            UserDefaults.standard.set(balance, forKey: Keys.balance.rawValue)
        }
    }
    
    private init() {
        self.balance = UserDefaults.standard.integer(forKey: Keys.balance.rawValue)
    }
    
    func add(_ amount: Int) {
        balance += amount
    }
    
    func subtract(_ amount: Int) {
        balance = max(0, balance - amount)
    }
    
    func checkAchievements() {
        let achievements = AchievementsManager.shared
        
        if balance >= 100 {
            achievements.unlock(.masterOfLightning)
        }
        if balance >= 300 {
            achievements.unlock(.gateKeeper)
        }
        if balance >= 1000 {
            achievements.unlock(.lordOfZeus)
        }
    }
}
