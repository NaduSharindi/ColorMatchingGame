import SwiftUI

struct HighScoresView: View {
    @AppStorage("bestScore") private var bestScore = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Text("HIGH SCORES")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.orange)
            
            VStack(spacing: 20) {
                ScoreRow(rank: 1, score: bestScore, isCurrent: true)
                
                ForEach(2...5, id: \.self) { rank in
                    ScoreRow(rank: rank, score: bestScore - (rank * 50), isCurrent: false)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)]),
                         startPoint: .top, endPoint: .bottom)
        )
        .navigationTitle("High Scores")
    }
}

struct ScoreRow: View {
    let rank: Int
    let score: Int
    let isCurrent: Bool
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.title2)
                .bold()
                .frame(width: 50)
            
            Spacer()
            
            Text("\(score) points")
                .font(.title3)
                .foregroundColor(isCurrent ? .blue : .primary)
            
            Spacer()
            
            if isCurrent {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
            }
        }
        .padding()
        .background(isCurrent ? Color.yellow.opacity(0.1) : Color.clear)
        .cornerRadius(10)
    }
}
