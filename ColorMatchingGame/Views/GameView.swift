import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showQuitAlert = false
    @AppStorage("largerText") private var largerText = false
    @AppStorage("highContrast") private var highContrast = false
    
    let gridSize: Int
    let playerName: String
    private let spacing: CGFloat = 6
    
    init(gridSize: Int, mode: GameViewModel.GameMode = .classic, playerName: String) {
        self.gridSize = gridSize
        self.playerName = playerName
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize, mode: mode, playerName: playerName))
    }
    
    // Helper properties to simplify complex expressions
    private var gradientColors: [Color] {
        if highContrast {
            return [Color.black, Color.gray]
        } else {
            return [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]
        }
    }
    
    private var headerFontSize: Font {
        largerText ? .headline : .caption
    }
    
    private var scoreFontSize: Font {
        largerText ? .title.bold() : .title2.bold()
    }
    
    private var levelFontSize: Font {
        largerText ? .headline : .subheadline
    }
    
    private var comboFontSize: Font {
        largerText ? .title2.bold() : .headline.bold()
    }
    
    private var feedbackFontSize: Font {
        largerText ? .title3 : .headline
    }
    
    private var bestScoreFontSize: Font {
        largerText ? .headline : .subheadline
    }
    
    private var menuFontSize: Font {
        largerText ? .headline : .body
    }
    
    private var timeColor: Color {
        viewModel.timeRemaining <= 10 ? .red : .primary
    }
    
    private var feedbackBackgroundColor: Color {
        viewModel.feedbackMessage.contains("Wrong") ? .red : .green
    }
    
    private var gridBackgroundOpacity: Double {
        highContrast ? 0.2 : 0.1
    }
    
    private var winColor: Color {
        viewModel.isGameWon ? .green : .red
    }
    
    private var winIcon: String {
        viewModel.isGameWon ? "checkmark.circle.fill" : "xmark.circle.fill"
    }
    
    private var winText: String {
        viewModel.isGameWon ? "You Win!" : "Game Over"
    }
    
    private var canGoToNextLevel: Bool {
        viewModel.isGameWon && gridSize < 7
    }
    
    private var isNewHighScore: Bool {
        viewModel.score >= viewModel.bestScore && viewModel.isGameWon
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                headerView
                
                // Game Info
                gameInfoView
                
                // Game Grid
                gameGridView
                
                Spacer()
                
                // Game Over/Win Screen
                if viewModel.isGameOver {
                    gameOverView
                }
                
                // Bottom Controls
                bottomControlsView
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                menuButtonView
            }
        }
        .alert("Quit Game?", isPresented: $showQuitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Quit", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your progress will be saved.")
        }
        .dynamicTypeSize(largerText ? .xxLarge : .medium)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(playerName)
                    .font(headerFontSize)
                    .foregroundColor(.secondary)
                
                Text("Score: \(viewModel.score)")
                    .font(scoreFontSize)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Level \(viewModel.currentLevel)")
                    .font(levelFontSize)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                
                if viewModel.gameMode == .timeAttack {
                    Text("Time: \(viewModel.timeRemaining)s")
                        .font(levelFontSize)
                        .foregroundColor(timeColor)
                        .monospacedDigit()
                        .fontWeight(.semibold)
                }
                
                if viewModel.gameMode == .survival {
                    HStack {
                        ForEach(0..<viewModel.lives, id: \.self) { _ in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(largerText ? .body : .caption)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var gameInfoView: some View {
        VStack(spacing: 10) {
            if viewModel.comboCount >= 2 {
                HStack {
                    Text("COMBO x\(viewModel.comboCount)")
                        .font(comboFontSize)
                        .foregroundColor(.orange)
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                }
                .transition(.scale)
            }
            
            if viewModel.showFeedback {
                Text(viewModel.feedbackMessage)
                    .font(feedbackFontSize)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(feedbackBackgroundColor)
                    .cornerRadius(20)
                    .transition(.move(edge: .top))
            }
            
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                Text("Best: \(viewModel.bestScore)")
                    .font(bestScoreFontSize)
                    .foregroundColor(.secondary)
            }
        }
        .animation(.spring(), value: viewModel.showFeedback)
        .animation(.spring(), value: viewModel.comboCount)
    }
    
    private var gameGridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: gridSize),
            spacing: spacing
        ) {
            ForEach(0..<viewModel.grid.count, id: \.self) { index in
                let cell = viewModel.grid[index]
                CellView(cell: cell)
                    .onTapGesture {
                        if !viewModel.isGameOver {
                            viewModel.selectCell(index)
                        }
                    }
                    .disabled(cell.isMatched || viewModel.isGameOver)
                    .accessibilityLabel("Cell \(index + 1)")
                    .accessibilityHint("Tap to select this cell")
                    .accessibilityAddTraits(cell.isMatched ? [.isSelected] : [])
            }
        }
        .padding(12)
        .background(Color.white.opacity(gridBackgroundOpacity))
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .shadow(radius: 5)
    }
    
    private var gameOverView: some View {
        VStack(spacing: 25) {
            VStack(spacing: 10) {
                Image(systemName: winIcon)
                    .font(.system(size: 60))
                    .foregroundColor(winColor)
                
                Text(winText)
                    .font(.largeTitle.bold())
                    .foregroundColor(winColor)
            }
            
            VStack(spacing: 10) {
                Text("Final Score: \(viewModel.score)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if isNewHighScore {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        Text("New High Score!")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            HStack(spacing: 20) {
                Button {
                    viewModel.startNewGame(gridSize: gridSize)
                } label: {
                    Label("Play Again", systemImage: "arrow.clockwise")
                        .font(.headline)
                }
                .buttonStyle(PrimaryButtonStyle(color: .blue))
                .accessibilityLabel("Play again button")
                
                if canGoToNextLevel {
                    Button {
                        viewModel.nextLevel()
                    } label: {
                        Label("Next Level", systemImage: "arrow.right")
                            .font(.headline)
                    }
                    .buttonStyle(PrimaryButtonStyle(color: .green))
                    .accessibilityLabel("Next level button")
                }
            }
        }
        .padding(30)
        .frame(maxWidth: 400)
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(radius: 20)
        .padding()
        .transition(.scale.combined(with: .opacity))
    }
    
    private var bottomControlsView: some View {
        HStack {
            Button {
                viewModel.startNewGame(gridSize: gridSize)
            } label: {
                Label("Restart", systemImage: "arrow.clockwise")
            }
            .buttonStyle(SecondaryButtonStyle())
            .accessibilityLabel("Restart game button")
            
            Spacer()
            
            Button {
                showQuitAlert = true
            } label: {
                Label("Quit", systemImage: "house")
            }
            .buttonStyle(SecondaryButtonStyle(color: .red))
            .accessibilityLabel("Quit to menu button")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var menuButtonView: some View {
        Button {
            showQuitAlert = true
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
            Text("Menu")
                .font(menuFontSize)
        }
        .accessibilityLabel("Back to menu button")
    }
}

#Preview {
    GameView(gridSize: 3, playerName: "Test Player")
}
