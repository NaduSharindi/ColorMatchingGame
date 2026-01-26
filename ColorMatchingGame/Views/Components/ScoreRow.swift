import SwiftUI

struct ScoreRow: View {
    let score: PlayerScore
    let rank: Int
    
    var medalColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            ZStack {
                Circle()
                    .fill(medalColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                if rank <= 3 {
                    Image(systemName: "medal.fill")
                        .foregroundColor(medalColor)
                } else {
                    Text("\(rank)")
                        .font(.headline.bold())
                        .foregroundColor(medalColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(score.name)
                    .font(.headline)
                
                Text(score.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing) {
                Text("\(score.score)")
                    .font(.title2.bold())
                    .foregroundColor(.blue)
                
                Text("points")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
