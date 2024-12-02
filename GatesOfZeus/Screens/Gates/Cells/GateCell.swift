//
//  GateCell.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import SwiftUI

struct GateCell: View {
    let symbol: GateSymbol
    let cellSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        GameCell(
            symbol: symbol,
            content: AnyView(GateCellContent(symbol: symbol, size: cellSize)),
            selectedContent: AnyView(
                Image(.bolt)
                    .resizable()
                    .frame(width: cellSize * 0.5, height: cellSize * 0.65)
                    .offset(y: cellSize * 0.12)
                    .shadow(color: .yellow, radius: 5)
            ),
            action: action
        )
    }
}

#Preview {
    VStack {
        GateCell(symbol: .init(number: 5), cellSize: 100, action: {})
        GateCell(symbol: .init(number: 5, isSelected: true, isCorrect: true), cellSize: 100, action: {})
        GateCell(symbol: .init(number: 5, isSelected: true, isCorrect: false), cellSize: 100, action: {})
    }
}
