import SwiftUI

struct GridCell: Identifiable {
    let id = UUID()
    let colorID: Int
    let color: Color

    var isMatched = false
    var isSelected = false
    var isWrong = false
}
