import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showGameOver = false
    
    let gridSize: Int
    let playerName: String
    private let spacing: CGFloat = 6
    
    init(gridSize: Int, mode: GameViewModel.GameMode = .classic, playerName: String) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize, mode: mode, playerName: playerName))
        self.gridSize = gridSize
        self.playerName = playerName
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                         startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Level \(viewModel.currentLevel)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Score: \(viewModel.score)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        if viewModel.gameMode == .timeAttack {
                            Text("Time: \(viewModel.timeRemaining)s")
                                .font(.headline)
                                .foregroundColor(viewModel.timeRemaining <= 10 ? .red : .primary)
                        }
                        
                        if viewModel.gameMode == .survival {
                            HStack {
                                ForEach(0..<viewModel.lives, id: \.self) { _ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Combo Display
                if viewModel.comboCount >= 2 {
                    HStack {
                        Text("Combo x\(viewModel.comboCount)")
                            .font(.headline)
                            .foregroundColor(.orange)
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.yellow)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Feedback Message
                if viewModel.showFeedback {
                    Text(viewModel.feedbackMessage)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(viewModel.feedbackMessage.contains("Wrong") ? Color.red : Color.green)
                        .cornerRadius(20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Best Score
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    Text("Best: \(viewModel.bestScore)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Grid
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize),
                    spacing: spacing
                ) {
                    ForEach(Array(viewModel.grid.enumerated()), id: \.element.id) { index, cell in
                        CellView(cell: cell)
                            .onTapGesture {
                                if !viewModel.isGameOver {
                                    viewModel.selectCell(index)
                                }
                            }
                            .disabled(viewModel.isGameOver)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .shadow(radius: 10)
                
                // Game Over/Win Screen
                if viewModel.isGameOver {
                    VStack(spacing: 20) {
                        Text(viewModel.isGameWon ? "You Win!" : "Game Over")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(viewModel.isGameWon ? .green : .red)
                        
                        Text("Final Score: \(viewModel.score)")
                            .font(.title2)
                        
                        if viewModel.score == viewModel.bestScore && viewModel.isGameWon {
                            Text("New High Score!")
                                .font(.headline)
                                .foregroundColor(.yellow)
                        }
                        
                        HStack(spacing: 20) {
                            Button("Play Again") {
                                viewModel.startNewGame(gridSize: gridSize)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            if viewModel.isGameWon && gridSize < 8 {
                                Button("Next Level") {
                                    viewModel.nextLevel()
                                }
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button("Menu") {
                                dismiss()
                            }
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground).opacity(0.95))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Bottom Controls
                HStack {
                    Button("Restart") {
                        viewModel.startNewGame(gridSize: gridSize)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Button("Menu") {
                        dismiss()
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
    }
}
