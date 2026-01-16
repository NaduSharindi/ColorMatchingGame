//
//  GridCell.swift
//  ColorMatchingGame
//
//  Created by COBSCCOMP242P-063 on 2026-01-16.
//

import SwiftUI

struct GridCell: Identifiable {
    let id = UUID()
    var color: Color
    var isMatched: Bool = false
    var isSelected: Bool = false
}
