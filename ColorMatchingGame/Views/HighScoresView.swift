import SwiftUI

struct HighScoresView: View {
    @State private var scores: [PlayerScore] = []
    @State private var selectedFilter: ScoreFilter = .allTime
    
    enum ScoreFilter: String, CaseIterable {
        case allTime = "All Time"
        case today = "Today"
        case thisWeek = "This Week"
    }
    
    var filteredScores: [PlayerScore] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case .today:
            return scores.filter { calendar.isDateInToday($0.date) }
        case .thisWeek:
            return scores.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear) }
        case .allTime:
            return scores
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack {
                Text("HIGH SCORES")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Top Players")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                             startPoint: .leading,
                             endPoint: .trailing)
            )
            
            // Filter Picker
            Picker("Filter", selection: $selectedFilter) {
                ForEach(ScoreFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if filteredScores.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "trophy")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Scores Yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("Be the first to set a high score!")
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(Array(filteredScores.enumerated()), id: \.element.id) { index, score in
                        ScoreRow(score: score, rank: index + 1)
                            .listRowBackground(index % 2 == 0 ? Color.gray.opacity(0.05) : Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            scores = ScoreManager.shared.loadScores()
        }
    }
}

#Preview {
    HighScoresView()
}
