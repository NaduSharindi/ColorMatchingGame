//
//  GameView.swift
//  ColorMatchingGame
//
//  Created by COBSCCOMP242P-063 on 2026-01-16.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    let gridSize: Int
    
    private let spacing: CGFloat=4
    
    init(gridSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize))
        self.gridSize = gridSize
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Score: \(viewModel.score)")
                .font(.title)
                .bold()
            
            //Grid Layout
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize),
                spacing: spacing
            ) {
                ForEach(viewModel.grid.indices, id: \.self) { index in
                    let cell = viewModel.grid[index]
                    CellView(cell: cell)
                        .onTapGesture {
                            if !viewModel.isGameOver {
                                viewModel.selectCell(index)
                            }
                        }
                }
            }
            .padding()
            
            if viewModel.isGameOver {
                Text("Game Over!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            } else if viewModel.grid.allSatisfy({ $0.isMatched }) {
                Text("You Win!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
            
            Button("Restart") {
                viewModel.startNewGame(gridSize: gridSize)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
