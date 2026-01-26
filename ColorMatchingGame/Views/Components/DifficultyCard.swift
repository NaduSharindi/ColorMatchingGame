import SwiftUI

struct DifficultyCard: View {
    let title: String
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(isSelected ? .white : color)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .white : color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? color : color.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color, lineWidth: isSelected ? 3 : 1)
        )
    }
}
