import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hasAcceptedPrivacy: Bool
    @State private var accepted = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.largeTitle.bold())
                        .padding(.bottom, 10)
                    
                    Text("Last Updated: January 26, 2026")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Group {
                            Text("1. Data Collection").font(.headline)
                            Text("We collect anonymous gameplay data to improve your experience:")
                                .font(.body)
                            
                            BulletPoint(text: "Game start and end times")
                            BulletPoint(text: "Number of clicks/taps")
                            BulletPoint(text: "Game mode preferences")
                            BulletPoint(text: "Difficulty levels played")
                            BulletPoint(text: "Scores achieved")
                        }
                        
                        Group {
                            Text("\n2. Data Usage").font(.headline)
                            Text("The data we collect is used for:")
                                .font(.body)
                            
                            BulletPoint(text: "Improving game performance")
                            BulletPoint(text: "Understanding player behavior")
                            BulletPoint(text: "Identifying and fixing bugs")
                            BulletPoint(text: "Adding new features")
                        }
                        
                        Group {
                            Text("\n3. Data Storage").font(.headline)
                            Text("All data is:")
                                .font(.body)
                            
                            BulletPoint(text: "Stored locally on your device")
                            BulletPoint(text: "Anonymous and not linked to personal identity")
                            BulletPoint(text: "Not shared with third parties")
                            BulletPoint(text: "Used only for game improvement")
                        }
                        
                        Group {
                            Text("\n4. Your Rights").font(.headline)
                            Text("You have the right to:")
                                .font(.body)
                            
                            BulletPoint(text: "View collected data in Settings")
                            BulletPoint(text: "Delete all collected data")
                            BulletPoint(text: "Opt-out of data collection")
                        }
                    }
                    .padding(.vertical)
                    
                    Toggle("I accept the Privacy Policy", isOn: $accepted)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        if accepted {
                            hasAcceptedPrivacy = true
                            dismiss()
                        }
                    }) {
                        Text("Continue to Game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(accepted ? Color.blue : Color.gray)
                            .cornerRadius(15)
                    }
                    .disabled(!accepted)
                    .padding(.top)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.body)
                .padding(.trailing, 5)
            Text(text)
                .font(.body)
            Spacer()
        }
        .padding(.leading, 10)
    }
}

#Preview {
    PrivacyPolicyView(hasAcceptedPrivacy: .constant(false))
}
