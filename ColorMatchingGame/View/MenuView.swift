//
//  MenuView.swift
//  ColorMatchingGame
//
//  Created by COBSCCOMP242P-063 on 2026-01-16.
//

import SwiftUI

struct MenuView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @State private var showSettings = false
    @State private var selectedMode: GameViewModel.GameMode = .classic
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                             startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    VStack {
                        Text("COLOR BASHER")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text("Match colors, build combos!")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Game Modes
                    VStack(spacing: 15) {
                        Text("SELECT MODE")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.bottom, 10)
                        
                        GameModeButton(
                            title: "CLASSIC",
                            subtitle: "One wrong = Game Over",
                            color: .green,
                            mode: .classic,
                            selectedMode: $selectedMode
                        )
                        
                        GameModeButton(
                            title: "SURVIVAL",
                            subtitle: "3 Lives • Lives System",
                            color: .orange,
                            mode: .survival,
                            selectedMode: $selectedMode
                        )
                        
                        GameModeButton(
                            title: "TIME ATTACK",
                            subtitle: "60 Seconds • Beat the Clock",
                            color: .red,
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
                            .foregroundColor(.white.opacity(0.9))
                        
                        HStack(spacing: 20) {
                            NavigationLink(destination: GameView(gridSize: 3, mode: selectedMode)) {
                                DifficultyButton(title: "EASY", color: .green, size: 3)
                            }
                            
                            NavigationLink(destination: GameView(gridSize: 5, mode: selectedMode)) {
                                DifficultyButton(title: "MEDIUM", color: .yellow, size: 5)
                            }
                            
                            NavigationLink(destination: GameView(gridSize: 7, mode: selectedMode)) {
                                DifficultyButton(title: "HARD", color: .red, size: 7)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom Buttons
                    HStack {
                        Button(action: { showSettings.toggle() }) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: HighScoresView()) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                Text("High Scores")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.yellow.opacity(0.3))
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
            .background(color.opacity(selectedMode == mode ? 0.8 : 0.5))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
        }
    }
}

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
        .background(color.opacity(0.7))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.5), lineWidth: 3)
        )
    }
}