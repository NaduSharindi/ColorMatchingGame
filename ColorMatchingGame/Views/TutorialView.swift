import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    let tutorialSteps = [
        TutorialStep(
            title: "Welcome to Color Basher",
            description: "Match pairs of colored tiles to score points!",
            icon: "paintpalette.fill",
            color: .blue
        ),
        TutorialStep(
            title: "How to Play",
            description: "Tap two tiles with the same color to make a match.",
            icon: "hand.tap.fill",
            color: .green
        ),
        TutorialStep(
            title: "Game Modes",
            description: "Classic: No mistakes\nSurvival: 3 lives\nTime Attack: 60 seconds",
            icon: "gamecontroller.fill",
            color: .orange
        ),
        TutorialStep(
            title: "Scoring",
            description: "Base: 10 points per match\nCombo: Bonus points for consecutive matches",
            icon: "star.fill",
            color: .yellow
        ),
        TutorialStep(
            title: "Difficulty",
            description: "Easy: 3×3 grid\nMedium: 5×5 grid\nHard: 7×7 grid",
            icon: "chart.bar.fill",
            color: .red
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    ForEach(tutorialSteps) { step in
                        TutorialCard(step: step)
                    }
                    
                    // Quick Tips
                    VStack(alignment: .leading, spacing: 15) {
                        Text("💡 Quick Tips")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            TipRow(icon: "bolt.fill", text: "Build combos for higher scores")
                            TipRow(icon: "clock.fill", text: "Plan your moves in Time Attack")
                            TipRow(icon: "heart.fill", text: "Use lives wisely in Survival mode")
                            TipRow(icon: "crown.fill", text: "Beat your own high score!")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("How to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TutorialView()
}
