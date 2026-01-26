import SwiftUI

struct GridCell: Identifiable {
    let id = UUID()
    var color: Color
    var isMatched: Bool = false
    var isSelected: Bool = false
    var isWrong: Bool = false
}
