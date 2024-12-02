//
//  WebViewModel.swift
//  GatesOfZeus
//
//  Created by Alex on 22.11.2024.
//

import Foundation

@MainActor
final class WebViewModel: ObservableObject {
    @Published var showFallback = false
    @Published var currentURL: URL?
    
    private let webViewManager = WebViewManager.shared
    private let soundManager = SoundManager.shared
    private let settingsManager = SettingsManager.shared
    private let rulesURL: URL?
    
    init(rulesURL: URL? = nil) {
        self.rulesURL = rulesURL
    }
    
    private var previousSoundState: Bool = false
    private var previousMusicState: Bool = false
    
    func onAppear() {
        saveSoundStates()
        disableSounds()
        setInitialURL()
    }
    
    func onDisappear() {
        restoreSoundStates()
    }
    
    private func saveSoundStates() {
        previousSoundState = settingsManager.isSoundEnabled
        previousMusicState = settingsManager.isMusicEnabled
    }
    
    private func disableSounds() {
        settingsManager.isSoundEnabled = false
        settingsManager.isMusicEnabled = false
        soundManager.updateMusicState()
    }
    
    private func restoreSoundStates() {
        settingsManager.isSoundEnabled = previousSoundState
        settingsManager.isMusicEnabled = previousMusicState
        soundManager.updateMusicState()
    }
    
    private func setInitialURL() {
        if let rulesURL = rulesURL {
            currentURL = rulesURL
        } else {
            currentURL = webViewManager.getInitialURL()
        }
    }
}

// MARK: - Loading
@MainActor
final class LoadingViewModel: ObservableObject {
    @Published var shouldShowRules = false
    @Published var shouldShowApp = false
    
    private let webViewManager = WebViewManager.shared
    
    func checkStatus() {
        NetworkManager.shared.start { [weak self] isConnected in
            Task { @MainActor in
                guard let self = self else { return }
                
                if !isConnected {
                    self.shouldShowApp = true
                    return
                }
                
                if let _ = self.webViewManager.gameURL {
                    self.shouldShowRules = true
                    return
                }
                
                do {
                    let initialURL = self.webViewManager.getInitialURL()
                    let (_, response) = try await URLSession.shared.data(from: initialURL)
                    
                    if let httpResponse = response as? HTTPURLResponse,
                       let ruleURL = httpResponse.url {
                        
                        if ruleURL.absoluteString.contains("google.com") {
                            self.shouldShowApp = true
                        } else {
                            self.webViewManager.gameURL = ruleURL
                            self.shouldShowRules = true
                        }
                    }
                } catch {
                    self.shouldShowApp = true
                }
            }
        }
    }
    
    deinit {
        NetworkManager.shared.stop()
    }
}
