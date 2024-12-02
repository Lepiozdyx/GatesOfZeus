//
//  RootView.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI

struct RootView: View {
    @StateObject private var vm = LoadingViewModel()
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            } else if vm.shouldShowRules {
                RulesWebView(rulesURL: nil)
                    .transition(.opacity)
            } else if vm.shouldShowApp {
                ContentView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isLoading)
        .onAppear {
            vm.checkStatus()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isLoading = false
            }
        }
    }
}

#Preview {
    RootView()
}
