//
//  GameCell.swift
//  GatesOfZeus
//
//  Created by Alex on 21.11.2024.
//

import SwiftUI

protocol GameSymbol {
    var id: UUID { get }
    var isSelected: Bool { get }
    var isCorrect: Bool? { get }
}

struct GameCell<Symbol: GameSymbol>: View {
    let symbol: Symbol
    let content: AnyView
    let selectedContent: AnyView
    let action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    
    private let springAnimation = Animation.spring(
        response: 0.3,
        dampingFraction: 0.6
    )
    
    var body: some View {
        ZStack {
            content

            if symbol.isSelected, let isCorrect = symbol.isCorrect {
                selectedContent
                    .transition(.scale.combined(with: .opacity))
                    .colorMultiply(isCorrect ? .yellow : .red)
            }
        }
        .scaleEffect(scale)
        .onTapGesture {
            handleTap()
        }
    }
    
    private func handleTap() {
        guard !symbol.isSelected else { return }
        
        withAnimation(springAnimation) {
            scale = 0.9
            action()
        }
        
        withAnimation(springAnimation.delay(0.1)) {
            scale = 1.0
        }
        
        SoundManager.shared.playSound(.click)
    }
}

// MARK: - Lightning cell
extension LightningSymbol: GameSymbol { }

struct LightningCellContent: View {
    let symbol: LightningSymbol
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Image(.boltCoin)
                .resizable()
                .frame(width: size, height: size)
                .overlay(alignment: .bottomTrailing) {
                    if symbol.hasZeusLightning && !symbol.isSelected {
                        Image(.bolt)
                            .resizable()
                            .frame(width: size * 0.2, height: size * 0.3)
                            .offset(x: -size * 0.2, y: -size * 0.1)
                    }
                }
        }
    }
}

// MARK: - Gate cell
extension GateSymbol: GameSymbol { }

struct GateCellContent: View {
    let symbol: GateSymbol
    let size: CGFloat
    
    var body: some View {
        Image(.gates)
            .resizable()
            .frame(width: size, height: size * 0.85)
            .overlay(alignment: .bottom) {
                Image(.bolt)
                    .resizable()
                    .frame(width: size * 0.5, height: size * 0.65)
                    .overlay {
                        Text("\(symbol.number)")
                            .customFont(
                                size: size * 0.16,
                                color: .black,
                                strokeWidth: 1,
                                strokeColor: .yellow
                            )
                    }
            }
    }
}
