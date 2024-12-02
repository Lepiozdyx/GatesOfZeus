//
//  ContentView.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some View {
        ZStack {
            switch navigationManager.currentScreen {
            case .home:
                HomeView()
                    .environmentObject(navigationManager)
            case .settings:
                SettingsView()
                    .environmentObject(navigationManager)
            case .gates:
                GatesView()
                    .environmentObject(navigationManager)
            case .lightning:
                LightningView()
                    .environmentObject(navigationManager)
            case .achievements:
                AchievementsView()
                    .environmentObject(navigationManager)
            case .rules:
                RulesView()
                    .environmentObject(navigationManager)
            }
        }
        .transition(.opacity)
        .onAppear {
            SoundManager.shared.updateMusicState()
        }
    }
}

#Preview {
    ContentView()
}
