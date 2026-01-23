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
    @Published var bestScore: Int = UserDefaults.standard.integer(forKey: "bestScore")
    
    private var selectedIndex: Int? = nil
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    
    // Game Modes
    enum GameMode {
        case classic, timeAttack, survival
    }
    
    private let normalColors: [Color] = [
        Color(red: 240/255, green: 43/255, blue: 29/255),    // Red
        Color(red: 34/255, green: 160/255, blue: 59/255),    // Green
        Color(red: 26/255, green: 115/255, blue: 232/255),   // Blue
        Color(red: 252/255, green: 194/255, blue: 0/255),    // Yellow
        Color(red: 244/255, green: 121/255, blue: 32/255),   // Orange
        Color(red: 111/255, green: 48/255, blue: 214/255),   // Purple
        Color(red: 0/255, green: 191/255, blue: 213/255),    // Cyan
        Color(red: 255/255, green: 105/255, blue: 180/255),  // Pink
        Color(red: 46/255, green: 204/255, blue: 113/255),   // Emerald
        Color(red: 155/255, green: 89/255, blue: 182/255)    // Amethyst
    ]
    
    private let soundEffects = [
        "match": "match_sound",
        "wrong": "wrong_sound",
        "tap": "tap_sound",
        "combo": "combo_sound"
    ]
    
    let playerName: String
    
    init(gridSize: Int, mode: GameMode = .classic, playerName: String) {
        self.playerName = playerName
        self.gameMode = mode
        startNewGame(gridSize: gridSize)
    }

    
    func startNewGame(gridSize: Int) {
        score = 0
        lives = gameMode == .survival ? 3 : 0
        isGameOver = false
        isGameWon = false
        comboCount = 0
        grid = []
        selectedIndex = nil
        timeRemaining = gameMode == .timeAttack ? 60 : 0
        
        if gameMode == .timeAttack {
            startTimer()
        }
        
        // Calculate colors needed
        let totalCells = gridSize * gridSize
        let pairsNeeded = totalCells / 2
        var colorPairs: [Color] = []
        
        for _ in 0..<pairsNeeded {
            colorPairs.append(normalColors.randomElement()!)
        }
        
        // Duplicate for pairs and shuffle
        var allColors = colorPairs + colorPairs
        
        // Add one extra color if odd number of cells
        if totalCells % 2 == 1 {
            allColors.append(normalColors.randomElement()!)
        }
        
        allColors.shuffle()
        
        // Create grid cells
        grid = allColors.map { GridCell(color: $0) }
        
        // Play start sound
        playSound("tap")
    }
    
    func startTimer() {
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
        
        playSound("tap")
        grid[index].isSelected = true
        
        if let firstIndex = selectedIndex {
            // Check match
            if grid[firstIndex].color == grid[index].color {
                handleCorrectMatch(firstIndex: firstIndex, secondIndex: index)
            } else {
                handleWrongMatch(firstIndex: firstIndex, secondIndex: index)
            }
            selectedIndex = nil
        } else {
            selectedIndex = index
        }
        
        // Check win condition
        if grid.allSatisfy({ $0.isMatched }) {
            endGame(won: true)
        }
    }
    
    private func handleCorrectMatch(firstIndex: Int, secondIndex: Int) {
        grid[firstIndex].isMatched = true
        grid[secondIndex].isMatched = true
        
        comboCount += 1
        let comboBonus = calculateComboBonus()
        score += 10 + comboBonus
        
        showFeedback("Great! +\(10 + comboBonus)")
        playSound(comboCount >= 3 ? "combo" : "match")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.grid[firstIndex].isSelected = false
                self.grid[secondIndex].isSelected = false
            }
        }
    }
    
    private func handleWrongMatch(firstIndex: Int, secondIndex: Int) {
        comboCount = 0
        
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
        
        // Visual feedback for wrong match
        grid[firstIndex].isWrong = true
        grid[secondIndex].isWrong = true
        
        showFeedback("Wrong! -1 Life")
        playSound("wrong")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation {
                self.grid[firstIndex].isSelected = false
                self.grid[firstIndex].isWrong = false
                self.grid[secondIndex].isSelected = false
                self.grid[secondIndex].isWrong = false
            }
        }
    }
    
    private func calculateComboBonus() -> Int {
        switch comboCount {
        case 2: return 5
        case 3: return 15
        case 4: return 30
        case 5...: return 50
        default: return 0
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
            score += timeRemaining * 5
            score += lives * 20
        }

        ScoreManager.shared.saveScore(name: playerName, score: score)
    }
    
    private func checkAndSaveHighScore() {
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
    }
    
    func nextLevel() {
        currentLevel += 1
        let newGridSize = min(8, 3 + currentLevel) // Cap at 8x8
        startNewGame(gridSize: newGridSize)
    }
    
    private func playSound(_ name: String) {
        guard let soundName = soundEffects[name],
              let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
