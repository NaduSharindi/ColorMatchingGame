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
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(cell.isMatched ? cell.color.opacity(0.3) : 
                      cell.isWrong ? Color.red.opacity(0.3) : 
                      cell.isSelected ? cell.color : Color.gray.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(cell.isMatched ? cell.color : Color.gray, lineWidth: 2)
                )
                .aspectRatio(1, contentMode: .fit)
                .scaleEffect(cell.isMatched ? 0.9 : 1.0)
                .rotation3DEffect(
                    .degrees(cell.isSelected ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.easeInOut(duration: 0.3), value: cell.isSelected)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: cell.isMatched)
            
            if cell.isMatched {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .shadow(color: cell.isSelected ? cell.color.opacity(0.5) : Color.black.opacity(0.1), 
                radius: cell.isSelected ? 8 : 2)
    }
}
