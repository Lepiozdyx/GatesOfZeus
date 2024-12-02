//
//  LightningCell.swift
//  GatesOfZeus
//
//  Created by Alex on 21.11.2024.
//

import SwiftUI

struct LightningCell: View {
    let symbol: LightningSymbol
    let cellSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        GameCell(
            symbol: symbol,
            content: AnyView(LightningCellContent(symbol: symbol, size: cellSize)),
            selectedContent: AnyView(
                Image(.bolt)
                    .resizable()
                    .frame(width: cellSize * 0.34, height: cellSize * 0.65)
                    .shadow(color: .yellow, radius: 5)
            ),
            action: action
        )
    }
}

#Preview {
    VStack {
        LightningCell(symbol: .init(hasZeusLightning: true),cellSize: 100, action: {})
        LightningCell(symbol: .init(hasZeusLightning: true, isSelected: true, isCorrect: true), cellSize: 100, action: {})
        LightningCell(symbol: .init(hasZeusLightning: false, isSelected: true, isCorrect: false), cellSize: 100, action: {})
    }
}
