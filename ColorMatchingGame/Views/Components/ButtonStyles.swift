import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = .blue
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background(color)
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var color: Color = .gray
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(color.opacity(0.1))
            .cornerRadius(10)
    }
}
