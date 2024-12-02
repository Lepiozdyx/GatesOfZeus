//
//  GameElements.swift
//  GatesOfZeus
//
//  Created by Alex on 22.11.2024.
//

import SwiftUI

struct CoinsMenuButton: View {
    @ObservedObject private var coinsManager = CoinsManager.shared
    let size: CGFloat
    let textSize: CGFloat
    
    var body: some View {
        MenuButton(
            image: .coinsUnderlay,
            text: "\(coinsManager.balance)",
            size: size,
            textSize: textSize,
            color: .yellow,
            isCounter: true
        )
    }
}

struct TimerMenuButton: View {
    @ObservedObject var timerManager: TimerManager
    let size: CGFloat
    let textSize: CGFloat
    
    var body: some View {
        MenuButton(
            image: .sandGlassUnderlay,
            text: timerManager.formattedTime,
            size: size,
            textSize: textSize,
            color: .yellow,
            isCounter: true
        )
    }
}

#Preview {
    HStack {
        CoinsMenuButton(size: 120, textSize: 18)
        Spacer()
        TimerMenuButton(timerManager: TimerManager(), size: 120, textSize: 18)
    }
    .padding(100)
}
