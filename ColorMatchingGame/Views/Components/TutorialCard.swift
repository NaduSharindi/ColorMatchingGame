import SwiftUI

struct TutorialStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct TutorialCard: View {
    let step: TutorialStep
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: step.icon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(step.color)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(step.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5)
        .padding(.horizontal)
    }
}
