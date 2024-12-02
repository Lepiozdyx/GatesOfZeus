//
//  NavigationManager.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI

enum Screen: Equatable {
    case home
    case settings
    case gates
    case lightning
    case achievements
    case rules
}

final class NavigationManager: ObservableObject {
    @Published var currentScreen: Screen = .home
    @Published var navigationStack: [Screen] = []
    
    func navigate(to screen: Screen) {
        withAnimation {
            navigationStack.append(currentScreen)
            currentScreen = screen
        }
        playSound()
    }
    
    func navigateBack() {
        guard let previousScreen = navigationStack.popLast() else { return }
        
        withAnimation {
            currentScreen = previousScreen
        }
        playSound()
    }
    
    func navigateToHome() {
        withAnimation {
            currentScreen = .home
            navigationStack.removeAll()
        }
        playSound()
    }
    
    private func playSound() {
        guard SettingsManager.shared.isSoundEnabled else { return }
        SoundManager.shared.playSound(.click)
    }
}
