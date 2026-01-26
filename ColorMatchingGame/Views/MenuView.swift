import SwiftUI

struct MenuView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @State private var showSettings = false
    @State private var showTutorial = false
    @State private var selectedMode: GameViewModel.GameMode = .classic
    @State private var difficulty: Difficulty = .easy
    @State private var showAccessibility = false
    
    let playerName: String
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy (3×3)"
        case medium = "Medium (5×5)"
        case hard = "Hard (7×7)"
        
        var gridSize: Int {
            switch self {
            case .easy: return 3
            case .medium: return 5
            case .hard: return 7
            }
        }
        
        var color: Color {
            switch self {
            case .easy: return Color(hex: "4CAF50") // Green
            case .medium: return Color(hex: "FF9800") // Orange
            case .hard: return Color(hex: "F44336") // Red
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header with improved spacing
                        VStack(spacing: 8) {
                            Text("Welcome,")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text(playerName)
                                .font(.largeTitle.bold())
                                .foregroundColor(.primary)
                                .padding(.bottom, 20)
                        }
                        .padding(.top, 30)
                        
                        // Game Modes with proper layout
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECT MODE")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach([GameViewModel.GameMode.classic, .survival, .timeAttack], id: \.self) { mode in
                                    GameModeCard(
                                        title: mode.title,
                                        subtitle: mode.subtitle,
                                        icon: mode.icon,
                                        color: mode.color,
                                        isSelected: selectedMode == mode
                                    )
                                    .onTapGesture {
                                        selectedMode = mode
                                    }
                                    .padding(.horizontal, 20)
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel("\(mode.title) mode, \(mode.subtitle)")
                                    .accessibilityAddTraits(selectedMode == mode ? [.isSelected] : [])
                                }
                            }
                        }
                        
                        // Difficulty Selection with proper layout
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECT DIFFICULTY")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 12) {
                                ForEach(Difficulty.allCases, id: \.self) { diff in
                                    DifficultyCard(
                                        title: diff.rawValue,
                                        color: diff.color,
                                        isSelected: difficulty == diff
                                    )
                                    .onTapGesture {
                                        difficulty = diff
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel(diff.rawValue)
                                    .accessibilityAddTraits(difficulty == diff ? [.isSelected] : [])
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Play Button
                        NavigationLink(
                            destination: GameView(
                                gridSize: difficulty.gridSize,
                                mode: selectedMode,
                                playerName: playerName
                            )
                        ) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                    .font(.title2)
                                Text("PLAY NOW")
                                    .font(.title2.bold())
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                             startPoint: .leading,
                                             endPoint: .trailing)
                            )
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .accessibilityLabel("Play now button")
                        .accessibilityHint("Start the game with selected mode and difficulty")
                        
                        Spacer(minLength: 20)
                        
                        // Bottom Buttons with improved layout
                        HStack(spacing: 12) {
                            Button(action: { showTutorial.toggle() }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.title2)
                                    Text("How to Play")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            }
                            .accessibilityLabel("How to play tutorial")
                            
                            Button(action: { showAccessibility.toggle() }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "accessibility.fill")
                                        .font(.title2)
                                    Text("Accessibility")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            }
                            .accessibilityLabel("Accessibility settings")
                            
                            Button(action: { showSettings.toggle() }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "gear")
                                        .font(.title2)
                                    Text("Settings")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            }
                            .accessibilityLabel("Game settings")
                            
                            NavigationLink(destination: HighScoresView()) {
                                VStack(spacing: 8) {
                                    Image(systemName: "trophy.fill")
                                        .font(.title2)
                                    Text("High Scores")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            }
                            .accessibilityLabel("High scores leaderboard")
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showTutorial) {
                TutorialView()
            }
            .sheet(isPresented: $showAccessibility) {
                AccessibilitySettingsView()
            }
        }
    }
}

#Preview {
    MenuView(playerName: "Test Player")
}
