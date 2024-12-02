//
//  SettingsViewModel.swift
//  GatesOfZeus
//
//  Created by Alex on 19.11.2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isSoundEnabled: Bool {
        didSet {
            SettingsManager.shared.isSoundEnabled = isSoundEnabled
            if isSoundEnabled {
                SoundManager.shared.playSound(.click)
            }
        }
    }
    
    @Published var isMusicEnabled: Bool {
        didSet {
            SettingsManager.shared.isMusicEnabled = isMusicEnabled
            SoundManager.shared.updateMusicState()
            if isSoundEnabled {
                SoundManager.shared.playSound(.click)
            }
        }
    }
    
    init() {
        self.isSoundEnabled = SettingsManager.shared.isSoundEnabled
        self.isMusicEnabled = SettingsManager.shared.isMusicEnabled
    }
    
    func toggleSound() {
        withAnimation {
            isSoundEnabled.toggle()
        }
    }
    
    func toggleMusic() {
        withAnimation {
            isMusicEnabled.toggle()
        }
    }
}
