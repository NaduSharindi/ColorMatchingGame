import SwiftUI

struct AccessibilitySettingsView: View {
    @AppStorage("highContrast") private var highContrast = false
    @AppStorage("reduceMotion") private var reduceMotion = false
    @AppStorage("largerText") private var largerText = false
    @AppStorage("colorBlindMode") private var colorBlindMode = false
    @AppStorage("soundCues") private var soundCues = true
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Visual Accessibility")) {
                    Toggle("High Contrast Mode", isOn: $highContrast)
                        .accessibilityLabel("High contrast mode")
                        .accessibilityHint("Increases color contrast for better visibility")
                    
                    Toggle("Reduce Motion", isOn: $reduceMotion)
                        .accessibilityLabel("Reduce animation motion")
                        .accessibilityHint("Reduces or removes animations")
                    
                    Toggle("Larger Text", isOn: $largerText)
                        .accessibilityLabel("Larger text size")
                        .accessibilityHint("Increases text size throughout the game")
                    
                    Toggle("Color Blind Mode", isOn: $colorBlindMode)
                        .accessibilityLabel("Color blind friendly mode")
                        .accessibilityHint("Uses color blind friendly palette")
                }
                
                Section(header: Text("Audio & Haptic")) {
                    Toggle("Sound Cues", isOn: $soundCues)
                        .accessibilityLabel("Sound effects cues")
                        .accessibilityHint("Plays sound effects for game events")
                    
                    Toggle("Haptic Feedback", isOn: $hapticFeedback)
                        .accessibilityLabel("Vibration feedback")
                        .accessibilityHint("Provides vibration feedback for game events")
                }
                
                Section(header: Text("Gameplay Assistance")) {
                    NavigationLink("VoiceOver Guide") {
                        VoiceOverGuideView()
                    }
                    
                    NavigationLink("Screen Reader Support") {
                        ScreenReaderGuideView()
                    }
                }
                
                Section(header: Text("Quick Actions")) {
                    Button("Test Accessibility Features") {
                        // Test functionality
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                    .foregroundColor(.blue)
                    
                    Button("Reset to Defaults") {
                        highContrast = false
                        reduceMotion = false
                        largerText = false
                        colorBlindMode = false
                        soundCues = true
                        hapticFeedback = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Accessibility")
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

struct VoiceOverGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("VoiceOver Guide")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                
                Text("Color Basher is fully compatible with VoiceOver. Here's how to navigate:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 15) {
                    GuideItem(
                        icon: "hand.tap.fill",
                        title: "Grid Navigation",
                        description: "Swipe left/right to navigate between cells. Double-tap to select."
                    )
                    
                    GuideItem(
                        icon: "speaker.wave.2.fill",
                        title: "Audio Cues",
                        description: "The game announces matches, scores, and game state changes."
                    )
                    
                    GuideItem(
                        icon: "clock.fill",
                        title: "Time Announcements",
                        description: "In Time Attack mode, VoiceOver announces remaining time every 10 seconds."
                    )
                    
                    GuideItem(
                        icon: "heart.fill",
                        title: "Life Announcements",
                        description: "In Survival mode, remaining lives are announced after each match."
                    )
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
}

struct ScreenReaderGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Screen Reader Support")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                
                Text("The game provides comprehensive screen reader support:")
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 15) {
                    GuideItem(
                        icon: "textformat.size",
                        title: "Dynamic Text",
                        description: "Supports system text size settings for better readability."
                    )
                    
                    GuideItem(
                        icon: "contrast",
                        title: "Contrast Options",
                        description: "High contrast mode available for low vision users."
                    )
                    
                    GuideItem(
                        icon: "paintpalette.fill",
                        title: "Color Options",
                        description: "Color blind mode provides alternative color schemes."
                    )
                    
                    GuideItem(
                        icon: "waveform.path",
                        title: "Audio Descriptions",
                        description: "All visual elements have descriptive audio alternatives."
                    )
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
}

struct GuideItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    AccessibilitySettingsView()
}
