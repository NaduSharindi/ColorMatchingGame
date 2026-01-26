import Foundation

struct TelemetryEvent: Codable {
    let eventType: String
    let timestamp: Date
    let sessionId: String
    let playerName: String?
    let gameMode: String?
    let gridSize: Int?
    let score: Int?
    let additionalData: [String: String]?
}

class TelemetryManager {
    static let shared = TelemetryManager()
    private let sessionId = UUID().uuidString
    private var events: [TelemetryEvent] = []
    private var startTime: Date?
    
    private init() {}
    
    func startSession(playerName: String, gameMode: String, gridSize: Int) {
        startTime = Date()
        logEvent("session_start", playerName: playerName, gameMode: gameMode, gridSize: gridSize)
    }
    
    func endSession(score: Int) {
        if let startTime = startTime {
            let duration = Date().timeIntervalSince(startTime)
            logEvent("session_end", additionalData: [
                "duration": String(format: "%.2f", duration),
                "score": "\(score)"
            ])
        }
        self.startTime = nil
    }
    
    func logClick(cellIndex: Int, gameMode: String) {
        logEvent("cell_click", additionalData: [
            "cell_index": "\(cellIndex)",
            "game_mode": gameMode
        ])
    }
    
    func logMatch(correct: Bool, comboCount: Int) {
        logEvent(correct ? "correct_match" : "wrong_match", additionalData: [
            "combo": "\(comboCount)"
        ])
    }
    
    func logGameOver(won: Bool, score: Int, level: Int) {
        logEvent("game_over", additionalData: [
            "result": won ? "won" : "lost",
            "score": "\(score)",
            "level": "\(level)"
        ])
    }
    
    private func logEvent(_ eventType: String, playerName: String? = nil, gameMode: String? = nil, gridSize: Int? = nil, additionalData: [String: String]? = nil) {
        let event = TelemetryEvent(
            eventType: eventType,
            timestamp: Date(),
            sessionId: sessionId,
            playerName: playerName,
            gameMode: gameMode,
            gridSize: gridSize,
            score: nil,
            additionalData: additionalData
        )
        events.append(event)
        print("[Telemetry] \(eventType): \(additionalData ?? [:])")
        
        // In production, you would send this to your server
        // sendToServer(event)
    }
    
    func getSessionData() -> [TelemetryEvent] {
        return events
    }
    
    func clearSessionData() {
        events.removeAll()
    }
    
    // For production - send to your server
    private func sendToServer(_ event: TelemetryEvent) {
        // Implement your server API call here
        // Example using URLSession
    }
}
