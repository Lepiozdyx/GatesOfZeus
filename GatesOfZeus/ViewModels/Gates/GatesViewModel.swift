//
//  GatesViewModel.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI
import Combine

struct GateSymbol: Identifiable {
    let id = UUID()
    let number: Int
    var isSelected = false
    var isCorrect: Bool?
}

enum GameRule: CaseIterable {
    case odd
    case even
    case multipleOfThree
    case fives
    
    var description: String {
        switch self {
        case .odd:
            return "Pick all the odd lightning bolts"
        case .even:
            return "Pick the even-numbered lightning bolts"
        case .multipleOfThree:
            return "Hit the bolts in multiples of 3"
        case .fives:
            return "Click the bolts with the number 5 on it"
        }
    }
    
    func isCorrect(_ number: Int) -> Bool {
        switch self {
        case .odd:
            return number.isMultiple(of: 2) == false
        case .even:
            return number.isMultiple(of: 2)
        case .multipleOfThree:
            return number.isMultiple(of: 3)
        case .fives:
            return number == 5
        }
    }
}

@MainActor
final class GatesViewModel: ObservableObject {
    @Published private(set) var symbols: [GateSymbol] = []
    @Published private(set) var currentRule: GameRule?
    @Published private(set) var isGameActive = false
    @Published private(set) var countdownText = ""
    @Published var showGameOverAlert = false
    
    private var symbolUpdateTimer: Timer?
    private var ruleUpdateTimer: Timer?
    private var gameRules: [GameRule] = GameRule.allCases.shuffled()
    private var currentRuleIndex = 0
    private var symbolUpdateInterval: TimeInterval = 5.0
    private let coinsManager = CoinsManager.shared
    private var gameStartCountdown = 3
    
    let timerManager: TimerManager
    var earnedCoins = 0
    
    init() {
        self.timerManager = TimerManager(duration: 60)
    }
    
    // MARK: - Game Control
    func startGame() {
        isGameActive = true
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
        if gameStartCountdown > 0 {
            countdownText = "\(gameStartCountdown)"
        } else {
            countdownText = currentRule?.description ?? ""
        }
    }
    
    private func startGameLoop() {
        setupNextRule()
        generateSymbols()
        
        timerManager.start { [weak self] in
            Task { @MainActor in
                self?.endGame()
            }
        }
        
        startSymbolUpdates()
        startRuleUpdates()
    }
    
    private func endGame() {
        isGameActive = false
        symbolUpdateTimer?.invalidate()
        ruleUpdateTimer?.invalidate()
        coinsManager.add(earnedCoins)
        coinsManager.checkAchievements()
        showGameOverAlert = true
    }
    
    // MARK: Game Logic
    private func setupNextRule() {
        currentRule = gameRules[currentRuleIndex]
        currentRuleIndex = (currentRuleIndex + 1) % gameRules.count
        updateCountdownText()
    }
    
    private func startSymbolUpdates() {
        symbolUpdateTimer?.invalidate()
        symbolUpdateTimer = Timer.scheduledTimer(withTimeInterval: symbolUpdateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.generateSymbols()
            }
        }
    }
    
    private func startRuleUpdates() {
        ruleUpdateTimer?.invalidate()
        ruleUpdateTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                self.setupNextRule()
                self.symbolUpdateInterval = max(2.0, self.symbolUpdateInterval - 1.0)
                self.startSymbolUpdates()
            }
        }
    }
    
    private func generateSymbols() {
        symbols = (1...9).map { _ in
            GateSymbol(number: Int.random(in: 1...9))
        }
    }
    
    // MARK: User Interaction
    func selectSymbol(at index: Int) {
        guard isGameActive,
              index < symbols.count,
              !symbols[index].isSelected,
              let currentRule = currentRule else { return }
        
        var updatedSymbols = symbols
        let symbol = updatedSymbols[index]
        let isCorrect = currentRule.isCorrect(symbol.number)
        
        updatedSymbols[index].isSelected = true
        updatedSymbols[index].isCorrect = isCorrect
        
        if isCorrect {
            earnedCoins += 10
        } else {
            earnedCoins = max(0, earnedCoins - 5)
        }
        
        symbols = updatedSymbols
    }
    
    // MARK: Timer Access
    var remainingTimeText: String {
        timerManager.formattedTime
    }
}
