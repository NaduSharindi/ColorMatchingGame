//
//  CellView.swift
//  ColorMatchingGame
//
//  Created by COBSCCOMP242P-063 on 2026-01-16.
//

import SwiftUI

struct CellView: View {
    var cell: GridCell
    
    var body: some View {
        Rectangle()
            .fill(cell.isMatched || cell.isSelected ? cell.color : Color.gray)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
            .shadow(radius: 2)
            .animation(.easeInOut(duration: 0.2), value: cell.isSelected)
    }
}
