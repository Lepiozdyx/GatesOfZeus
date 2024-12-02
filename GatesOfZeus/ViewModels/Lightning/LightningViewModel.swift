//
//  LightningViewModel.swift
//  GatesOfZeus
//
//  Created by Alex on 21.11.2024.
//

import SwiftUI

struct LightningSymbol: Identifiable {
    let id = UUID()
    var hasZeusLightning: Bool
    var isSelected = false
    var isCorrect: Bool?
}

@MainActor
final class LightningViewModel: ObservableObject {
    @Published private(set) var symbols: [LightningSymbol] = []
    @Published private(set) var isGameActive = false
    @Published private(set) var countdownText = ""
    @Published var showGameOverAlert = false
    
    private var symbolUpdateTimer: Timer?
    private var gameStartCountdown = 3
    private let coinsManager = CoinsManager.shared
    
    private var zeusLightningsShown = 0
    private let maxZeusLightnings = 15
    private let updateInterval: TimeInterval = 2.0
    
    let timerManager: TimerManager
    var earnedCoins = 0
    
    init() {
        self.timerManager = TimerManager(duration: 30)
    }
    
    // MARK: Game Control
    func startGame() {
        isGameActive = true
        symbols = []
        startCountdown()
    }
    
    private func startCountdown() {
        gameStartCountdown = 3
        updateCountdownText()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self = self else { return }
                self.gameStartCountdown -= 1
                self.updateCountdownText()
                
                if self.gameStartCountdown < 0 {
                    timer.invalidate()
                    self.startGameLoop()
                }
            }
        }
    }
    
    private func updateCountdownText() {
        countdownText = gameStartCountdown > 0 ? "\(gameStartCountdown)" : ""
    }
    
    private func startGameLoop() {
        zeusLightningsShown = 0
        earnedCoins = 0
        
        symbols = Array(repeating: LightningSymbol(hasZeusLightning: false), count: 9)
        
        timerManager.start { [weak self] in
            Task { @MainActor in
                self?.endGame()
            }
        }
        
        updateSymbols()
        startSymbolUpdates()
    }
    
    private func endGame() {
        isGameActive = false
        symbolUpdateTimer?.invalidate()
        coinsManager.add(earnedCoins)
        coinsManager.checkAchievements()
        showGameOverAlert = true
    }
    
    private func startSymbolUpdates() {
        symbolUpdateTimer?.invalidate()
        symbolUpdateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                
                if self.zeusLightningsShown < self.maxZeusLightnings {
                    self.updateSymbols()
                    self.zeusLightningsShown += 1
                } else {
                    self.endGame()
                }
            }
        }
    }
    
    private func updateSymbols() {
        symbols = symbols.map { _ in LightningSymbol(hasZeusLightning: false) }
        
        let zeusIndex = Int.random(in: 0..<9)
        symbols[zeusIndex] = LightningSymbol(hasZeusLightning: true)
    }
    
    // MARK: User Interaction
    func selectSymbol(at index: Int) {
        guard isGameActive,
              index < symbols.count,
              !symbols[index].isSelected else { return }
        
        var updatedSymbols = symbols
        let symbol = updatedSymbols[index]
        let isCorrect = symbol.hasZeusLightning
        
        updatedSymbols[index].isSelected = true
        updatedSymbols[index].isCorrect = isCorrect
        
        if isCorrect {
            earnedCoins += 20
        } else {
            earnedCoins = max(0, earnedCoins - 10)
        }
        
        symbols = updatedSymbols
    }
    
    // MARK: Timer Access
    var remainingTimeText: String {
        timerManager.formattedTime
    }
}
