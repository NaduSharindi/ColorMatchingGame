import SwiftUI

struct HighScoresView: View {
    @State private var scores: [PlayerScore] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("HIGH SCORES")
                .font(.largeTitle)
                .bold()

            List(scores.prefix(10)) { score in
                HStack {
                    Text(score.name)
                        .font(.headline)

                    Spacer()

                    Text("\(score.score)")
                        .bold()
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            scores = ScoreManager.shared.loadScores()
        }
    }
}

