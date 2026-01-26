import Foundation

class ScoreManager {
    static let shared = ScoreManager()
    private let key = "playerScores"
    
    private init() {}
    
    func loadScores() -> [PlayerScore] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let scores = try? JSONDecoder().decode([PlayerScore].self, from: data)
        else {
            return []
        }
        return scores.sorted { $0.score > $1.score }
    }
    
    func saveScore(name: String, score: Int) {
        var scores = loadScores()
        let newScore = PlayerScore(name: name, score: score, date: Date())
        scores.append(newScore)
        
        // Keep only top 50 scores
        scores = Array(scores.sorted { $0.score > $1.score }.prefix(50))
        
        if let data = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func resetScores() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
