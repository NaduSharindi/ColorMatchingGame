import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("musicEnabled") private var musicEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    @State private var showTelemetryData = false
    
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
                
                Section(header: Text("Game Data")) {
                    Button("View Telemetry Data") {
                        showTelemetryData = true
                    }
                    .foregroundColor(.blue)
                    
                    Button("Reset High Scores") {
                        showResetAlert = true
                    }
                    .foregroundColor(.red)
                    .alert("Reset High Scores", isPresented: $showResetAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Reset", role: .destructive) {
                            ScoreManager.shared.resetScores()
                            UserDefaults.standard.set(0, forKey: "bestScore")
                        }
                    } message: {
                        Text("This will permanently delete all high scores. This action cannot be undone.")
                    }
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
                        Text("Color Basher Team")
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
            .sheet(isPresented: $showTelemetryData) {
                TelemetryDataView()
            }
        }
    }
}

struct TelemetryDataView: View {
    @Environment(\.dismiss) var dismiss
    let telemetryData = TelemetryManager.shared.getSessionData()
    
    var body: some View {
        NavigationView {
            VStack {
                if telemetryData.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Data Collected")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Play some games to collect telemetry data")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(telemetryData, id: \.timestamp) { event in
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(event.eventType)
                                        .font(.headline)
                                    Spacer()
                                    Text(event.timestamp, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if let additionalData = event.additionalData {
                                    ForEach(additionalData.sorted(by: >), id: \.key) { key, value in
                                        HStack {
                                            Text(key)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            Text(value)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                
                Button("Clear All Data") {
                    TelemetryManager.shared.clearSessionData()
                    dismiss()
                }
                .foregroundColor(.red)
                .padding()
            }
            .navigationTitle("Telemetry Data")
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

#Preview {
    SettingsView()
}
