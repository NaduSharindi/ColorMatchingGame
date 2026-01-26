import SwiftUI

struct WelcomeView: View {
    @State private var playerName = ""
    @State private var navigateToMenu = false
    @State private var showAlert = false
    @State private var showPrivacyPolicy = false
    @AppStorage("hasAcceptedPrivacy") private var hasAcceptedPrivacy = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title with improved layout
                    VStack(spacing: 15) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text("COLOR BASHER")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text("Match colors, build combos!")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Name Input
                    VStack(spacing: 15) {
                        Text("ENTER YOUR NAME")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
                        TextField("", text: $playerName)
                            .placeholder(when: playerName.isEmpty) {
                                Text("Player Name")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                            .padding(.horizontal, 40)
                            .accessibilityLabel("Enter your name")
                            .accessibilityHint("Type your name to start the game")
                    }
                    
                    Spacer()
                    
                    // Start Button
                    Button(action: {
                        if playerName.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAlert = true
                        } else if !hasAcceptedPrivacy {
                            showPrivacyPolicy = true
                        } else {
                            navigateToMenu = true
                        }
                    }) {
                        Text("START GAME")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]),
                                             startPoint: .leading,
                                             endPoint: .trailing)
                            )
                            .cornerRadius(20)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 30)
                    .accessibilityLabel("Start game button")
                    .accessibilityHint("Tap to start the game with your entered name")
                    .alert("Enter Name", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Please enter your name to continue.")
                    }
                    
                    // Privacy Policy Link
                    Button("Privacy Policy") {
                        showPrivacyPolicy = true
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)
                    
                    NavigationLink("", destination: MenuView(playerName: playerName), isActive: $navigateToMenu)
                        .hidden()
                }
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView(hasAcceptedPrivacy: $hasAcceptedPrivacy)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
