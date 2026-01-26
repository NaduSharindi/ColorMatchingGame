import SwiftUI
import Combine
import AVFoundation

class GameViewModel: ObservableObject {
    @Published var grid: [GridCell] = []
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var isGameOver: Bool = false
    @Published var isGameWon: Bool = false
    @Published var timeRemaining: Int = 60
    @Published var currentLevel: Int = 1
    @Published var comboCount: Int = 0
    @Published var feedbackMessage: String = ""
    @Published var showFeedback: Bool = false
    @Published var gameMode: GameMode = .classic
    
    @AppStorage("bestScore") private var storedBestScore: Int = 0
    @AppStorage("colorBlindMode") private var colorBlindMode = false
    
    var bestScore: Int {
        get { storedBestScore }
        set { storedBestScore = newValue }
    }
    
    private var selectedIndex: Int? = nil
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var gridSize: Int
    
    enum GameMode {
        case classic, timeAttack, survival
        
        var title: String {
            switch self {
            case .classic: return "CLASSIC"
            case .survival: return "SURVIVAL"
            case .timeAttack: return "TIME ATTACK"
            }
        }
        
        var subtitle: String {
            switch self {
            case .classic: return "No mistakes allowed"
            case .survival: return "3 Lives system"
            case .timeAttack: return "Beat the clock"
            }
        }
        
        var icon: String {
            switch self {
            case .classic: return "star.fill"
            case .survival: return "heart.fill"
            case .timeAttack: return "clock.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .classic: return .blue
            case .survival: return .red
            case .timeAttack: return .orange
            }
        }
    }
    
    // Color blind friendly palette
    private let colorBlindColors: [Color] = [
        Color(hex: "E69F00"), // Orange
        Color(hex: "56B4E9"), // Sky blue
        Color(hex: "009E73"), // Bluish green
        Color(hex: "F0E442"), // Yellow
        Color(hex: "0072B2"), // Blue
        Color(hex: "D55E00"), // Vermilion
        Color(hex: "CC79A7"), // Reddish purple
        Color(hex: "999999"), // Gray
        Color(hex: "000000"), // Black
        Color(hex: "FFFFFF")  // White
    ]
    
    // Normal colors
    private let normalColors: [Color] = [
        .red,
        .green,
        .blue,
        .yellow,
        .orange,
        .purple,
        .pink,
        .cyan,
        .mint,
        .indigo
    ]
    
    var currentColors: [Color] {
        colorBlindMode ? colorBlindColors : normalColors
    }
    
    let playerName: String
    
    init(gridSize: Int, mode: GameMode = .classic, playerName: String) {
        self.gridSize = gridSize
        self.gameMode = mode
        self.playerName = playerName
        
        // Start telemetry session
        TelemetryManager.shared.startSession(
            playerName: playerName,
            gameMode: mode.title,
            gridSize: gridSize
        )
        
        startNewGame(gridSize: gridSize)
    }
    
    func startNewGame(gridSize: Int) {
        self.gridSize = gridSize
        score = 0
        lives = gameMode == .survival ? 3 : 0
        isGameOver = false
        isGameWon = false
        comboCount = 0
        selectedIndex = nil
        timeRemaining = gameMode == .timeAttack ? 60 : 0
        
        if gameMode == .timeAttack {
            startTimer()
        }
        
        createGrid()
        
        // Set initial best score
        if score > bestScore {
            bestScore = score
        }
    }
    
    private func createGrid() {
        let totalCells = gridSize * gridSize
        let pairsNeeded = totalCells / 2
        
        // Ensure we have enough unique colors
        let availableColors = Array(currentColors.prefix(max(2, gridSize)))
        
        // Create pairs
        var colorPairs: [Color] = []
        for _ in 0..<pairsNeeded {
            if let color = availableColors.randomElement() {
                colorPairs.append(color)
            }
        }
        
        // Duplicate for pairs and ensure correct count
        var allColors = colorPairs + colorPairs
        
        // If odd number of cells, add one extra random color
        if totalCells % 2 == 1 {
            allColors.append(availableColors.randomElement() ?? .gray)
        }
        
        // Ensure we have exactly the right number of cells
        while allColors.count < totalCells {
            allColors.append(availableColors.randomElement() ?? .gray)
        }
        
        allColors = Array(allColors.prefix(totalCells))
        allColors.shuffle()
        
        // Create grid cells
        grid = allColors.map { GridCell(color: $0) }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endGame(won: false)
            }
        }
    }
    
    func selectCell(_ index: Int) {
        guard !grid[index].isMatched, !grid[index].isSelected, !isGameOver else { return }
        
        // Log click
        TelemetryManager.shared.logClick(cellIndex: index, gameMode: gameMode.title)
        
        withAnimation(.spring()) {
            grid[index].isSelected = true
        }
        
        if let firstIndex = selectedIndex {
            // Second selection
            if grid[firstIndex].color == grid[index].color {
                handleCorrectMatch(firstIndex: firstIndex, secondIndex: index)
            } else {
                handleWrongMatch(firstIndex: firstIndex, secondIndex: index)
            }
            selectedIndex = nil
        } else {
            // First selection
            selectedIndex = index
        }
    }
    
    private func handleCorrectMatch(firstIndex: Int, secondIndex: Int) {
        withAnimation(.spring()) {
            grid[firstIndex].isMatched = true
            grid[secondIndex].isMatched = true
        }
        
        comboCount += 1
        let basePoints = 10
        let comboBonus = comboCount >= 2 ? (comboCount - 1) * 5 : 0
        let pointsEarned = basePoints + comboBonus
        
        score += pointsEarned
        
        // Log match
        TelemetryManager.shared.logMatch(correct: true, comboCount: comboCount)
        
        showFeedback("Perfect! +\(pointsEarned)")
        
        // Check if all matched
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.grid.allSatisfy({ $0.isMatched }) {
                self.endGame(won: true)
            }
        }
        
        // Reset selection after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.grid[firstIndex].isSelected = false
                self.grid[secondIndex].isSelected = false
            }
        }
    }
    
    private func handleWrongMatch(firstIndex: Int, secondIndex: Int) {
        comboCount = 0
        
        // Log match
        TelemetryManager.shared.logMatch(correct: false, comboCount: 0)
        
        if gameMode == .survival {
            lives -= 1
            
            if lives <= 0 {
                endGame(won: false)
                return
            }
        } else if gameMode == .classic {
            endGame(won: false)
            return
        }
        
        showFeedback("Wrong! Try again")
        
        // Visual feedback
        withAnimation {
            grid[firstIndex].isWrong = true
            grid[secondIndex].isWrong = true
        }
        
        // Reset after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                self.grid[firstIndex].isSelected = false
                self.grid[firstIndex].isWrong = false
                self.grid[secondIndex].isSelected = false
                self.grid[secondIndex].isWrong = false
            }
        }
    }
    
    private func showFeedback(_ message: String) {
        feedbackMessage = message
        showFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                self.showFeedback = false
            }
        }
    }
    
    private func endGame(won: Bool) {
        isGameOver = true
        isGameWon = won
        timer?.invalidate()
        
        if won {
            // Bonus points for time and lives
            let timeBonus = gameMode == .timeAttack ? timeRemaining * 2 : 0
            let livesBonus = gameMode == .survival ? lives * 10 : 0
            score += timeBonus + livesBonus
        }
        
        // Log game over
        TelemetryManager.shared.logGameOver(won: won, score: score, level: currentLevel)
        
        // End telemetry session
        TelemetryManager.shared.endSession(score: score)
        
        // Save score
        ScoreManager.shared.saveScore(name: playerName, score: score)
        
        // Update best score
        if score > bestScore {
            bestScore = score
        }
    }
    
    func nextLevel() {
        currentLevel += 1
        let newGridSize = min(7, gridSize + 2) // Cap at 7x7
        startNewGame(gridSize: newGridSize)
    }
    
    deinit {
        timer?.invalidate()
    }
}
