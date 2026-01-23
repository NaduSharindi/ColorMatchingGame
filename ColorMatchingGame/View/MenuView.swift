import SwiftUI

// MARK: - Hex Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // skip #
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

struct MenuView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @State private var showSettings = false
    @State private var selectedMode: GameViewModel.GameMode = .classic
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    VStack {
                        Text("COLOR BASHER")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                        
                        Text("Match colors, build combos!")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Game Modes
                    VStack(spacing: 15) {
                        Text("SELECT MODE")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                        
                        GameModeButton(
                            title: "CLASSIC",
                            subtitle: "One wrong = Game Over",
                            color: Color(hex: "#C07DFF"),
                            mode: .classic,
                            selectedMode: $selectedMode
                        )
                        
                        GameModeButton(
                            title: "SURVIVAL",
                            subtitle: "3 Lives • Lives System",
                            color: Color(hex: "#FFA652"),
                            mode: .survival,
                            selectedMode: $selectedMode
                        )
                        
                        GameModeButton(
                            title: "TIME ATTACK",
                            subtitle: "60 Seconds • Beat the Clock",
                            color: Color(hex: "#63CEFF"),
                            mode: .timeAttack,
                            selectedMode: $selectedMode
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Difficulty Selection
                    VStack(spacing: 15) {
                        Text("SELECT DIFFICULTY")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 20) {
                            NavigationLink(destination: GameView(gridSize: 3, mode: selectedMode)) {
                                DifficultyButton(title: "EASY", color: Color(hex: "#4CAF50"), size: 3) // Medium Green
                            }
                            
                            NavigationLink(destination: GameView(gridSize: 5, mode: selectedMode)) {
                                DifficultyButton(title: "MEDIUM", color: Color(hex: "#FBC02D"), size: 5) // Golden Yellow
                            }
                            
                            NavigationLink(destination: GameView(gridSize: 7, mode: selectedMode)) {
                                DifficultyButton(title: "HARD", color: Color(hex: "#D32F2F"), size: 7) // Crimson Red
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom Buttons
                    HStack {
                        Button(action: { showSettings.toggle() }) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.black.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: HighScoresView()) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                Text("High Scores")
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

// MARK: - Game Mode Button
struct GameModeButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let mode: GameViewModel.GameMode
    @Binding var selectedMode: GameViewModel.GameMode
    
    var body: some View {
        Button(action: { selectedMode = mode }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                if selectedMode == mode {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding()
            .background(color)
            .cornerRadius(15)
        }
    }
}

// MARK: - Difficulty Button
struct DifficultyButton: View {
    let title: String
    let color: Color
    let size: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(size)×\(size)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 100, height: 80)
        .background(color)
        .cornerRadius(15)
    }
}
