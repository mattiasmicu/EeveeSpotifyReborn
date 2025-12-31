import SwiftUI

struct EeveeSettingsVersionView: View {
    @State private var latestVersion: String?
    @State private var isPresentingContributorsSheet = false
    
    private func loadVersion() async throws {
        let release = try await GitHubHelper.shared.getLatestRelease()
        latestVersion = String(release.tagName.dropFirst(5))
    }
    
    private var isUpdateAvailable: Bool {
        latestVersion != nil && latestVersion != EeveeSpotify.version
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if isUpdateAvailable {
                Button {
                    if let url = URL(string: "https://github.com/whoeevee/Beam/releases") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("update_available".localized)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("v\(latestVersion ?? "")")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1a3a1a"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text("Beam")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("v\(EeveeSpotify.version)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    if latestVersion == nil {
                        HStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.6)))
                                .scaleEffect(0.8)
                            Text("checking_for_update".localized)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    } else {
                        Button {
                            isPresentingContributorsSheet = true
                        } label: {
                            Text("contributors".localized)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(EeveeSettingsView.spotifyAccentColor)
                        }
                    }
                }
                
                Spacer()
                
                if !isUpdateAvailable && latestVersion != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#1a1a1a"))
            )
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: latestVersion)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isUpdateAvailable)
        .sheet(isPresented: $isPresentingContributorsSheet) {
            EeveeContributorsSheetView()
        }
        .onAppear {
            Task {
                try await loadVersion()
            }
        }
    }
}
