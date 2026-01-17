struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("musicEnabled") private var musicEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Audio")) {
                    Toggle("Sound Effects", isOn: $soundEnabled)
                    Toggle("Background Music", isOn: $musicEnabled)
                }
                
                Section(header: Text("Haptics")) {
                    Toggle("Vibration Feedback", isOn: $hapticEnabled)
                }
                
                Section(header: Text("Game")) {
                    Button("Reset High Scores") {
                        UserDefaults.standard.set(0, forKey: "bestScore")
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Your Name")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
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