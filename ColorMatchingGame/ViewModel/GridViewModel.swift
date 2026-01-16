//
//  GridViewModel.swift
//  ColorMatchingGame
//
//  Created by COBSCCOMP242P-063 on 2026-01-16.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var grid: [GridCell] = []
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    
    private var selectedIndex: Int? = nil
    private let normalColors: [Color] = [
        Color(red: 240 / 255, green: 43 / 255, blue: 29 / 255), //vibrant Red
        Color(red: 34 / 255, green: 160 / 255, blue: 59 / 255), //vibrant Green
        Color(red: 26 / 255, green: 115 / 255, blue: 232 / 255), //vibrant Blue
        Color(red: 252 / 255, green: 194 / 255, blue: 0 / 255), //bright Yellow
        Color(red: 244 / 255, green: 121 / 255, blue: 32 / 255), //vibrant Orange
        Color(red: 111 / 255, green: 48 / 255, blue: 214 / 255), //strong Purple
        Color(red: 0 / 255, green: 191 / 255, blue: 213 / 255), //bright Cyan
    ]
    
    init(gridSize: Int) {
        startNewGame(gridSize: gridSize)
    }
    
    func startNewGame(gridSize: Int) {
        score = 0
        isGameOver = false
        grid = []
        selectedIndex = nil
        
        //Generating random pairs
        var pairs = (0..<((gridSize * gridSize) / 2)).map { _ in
            normalColors.randomElement()!
        }
        
        //for odd grids to create extra cells
        if gridSize * gridSize % 2 == 1 {
            pairs.append(normalColors.randomElement()!)
        }
        
        //shuffle the grid with cells
        let allColors = (pairs + pairs).shuffled().prefix(gridSize * gridSize)
        grid = allColors.map { GridCell(color: $0)}
    }
    
    //handles what happens user taps the cell
    func selectCell(_ index: Int) {
        guard !grid[index].isMatched, !grid[index].isSelected, !isGameOver else { return }
        
        grid[index].isSelected = true
        
        if let firstIndex = selectedIndex {
            // check if selected cells match
            if grid[firstIndex].color == grid[index].color {
                grid[firstIndex].isMatched = true
                grid[index].isMatched = true
                score += 10
                selectedIndex = nil
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isGameOver = true
                }
            }
        } else {
            selectedIndex = index
        }
    }

}
