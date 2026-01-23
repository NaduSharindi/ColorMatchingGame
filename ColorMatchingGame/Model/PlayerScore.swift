import Foundation

struct PlayerScore: Identifiable, Codable {
    var id = UUID()
    let name: String
    let score: Int
    let date: Date
}
