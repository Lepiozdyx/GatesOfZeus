//
//  LightningView.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI

struct LightningView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @ObservedObject private var coinsManager = CoinsManager.shared
    @StateObject private var viewModel = LightningViewModel()
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 3
    )
    
    var body: some View {
        ZStack {
            BackgroundView(imageName: .bg)
            
            GeometryReader { geometry in
                let maxWidth = geometry.size.width
                let maxHeight = geometry.size.height
                let gridMaxWidth = maxHeight * 0.9
                let gridMaxHeight = maxHeight * 0.5
                let cellSize = min(maxWidth * 0.2, gridMaxHeight / 3)
                let buttonSize = min(maxWidth, maxHeight) * 0.3
                let textSize = buttonSize * 0.1
                let headerFontSize = maxWidth * 0.05
                
                VStack {
                    // Top panel
                    HStack {
                        NavigationBackButton {
                            navigationManager.navigateBack()
                        }
                        
                        Spacer()
                        
                        if !viewModel.countdownText.isEmpty {
                            Text(viewModel.countdownText)
                                .customFont(size: headerFontSize, color: .softGold)
                                .animation(.easeInOut, value: viewModel.countdownText)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Coins grid
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(viewModel.symbols.enumerated()), id: \.element.id) { index, symbol in
                            LightningCell(symbol: symbol, cellSize: cellSize) {
                                viewModel.selectSymbol(at: index)
                            }
                        }
                    }
                    .frame(maxWidth: gridMaxWidth, maxHeight: gridMaxHeight)
                    
                    Spacer()
                    
                    // Bottom panel
                    HStack {
                        CoinsMenuButton(size: buttonSize, textSize: textSize)
                        
                        Spacer()
                        
                        TimerMenuButton(timerManager: viewModel.timerManager, size: buttonSize, textSize: textSize)
                    }
                }
                .padding()
                .frame(width: maxWidth, height: maxHeight)
            }
        }
        .alert("Game Over!", isPresented: $viewModel.showGameOverAlert) {
            Button("OK") {
                navigationManager.navigateToHome()
            }
        } message: {
            Text("You earned \(viewModel.earnedCoins) coins!")
        }
        .onAppear {
            viewModel.startGame()
        }
    }
}

#Preview {
    LightningView()
        .environmentObject(NavigationManager())
}
