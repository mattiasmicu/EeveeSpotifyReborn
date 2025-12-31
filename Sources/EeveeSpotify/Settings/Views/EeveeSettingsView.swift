import SwiftUI
import UIKit

struct EeveeSettingsView: View {
    let navigationController: UINavigationController
    static let spotifyAccentColor = Color(hex: "#1ed760")
    
    @State private var hasShownCommonIssuesTip = UserDefaults.hasShownCommonIssuesTip
    @State private var isClearingData = false
    
    private func pushSettingsController(with view: any View, title: String) {
        let viewController = EeveeSettingsViewController(
            navigationController.view.frame,
            settingsView: AnyView(view),
            navigationTitle: title
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        UIView.appearance().tintColor = UIColor(EeveeSettingsView.spotifyAccentColor)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                
                VStack(spacing: 12) {
                    settingsSection
                    
                    if !hasShownCommonIssuesTip {
                        CommonIssuesTipView(
                            onDismiss: {
                                hasShownCommonIssuesTip = true
                                UserDefaults.hasShownCommonIssuesTip = true
                            }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    actionSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: hasShownCommonIssuesTip)
        
        .onAppear {
            WindowHelper.shared.overrideUserInterfaceStyle(.dark)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(EeveeSettingsView.spotifyAccentColor.gradient)
                    .frame(width: 72, height: 72)
                    .shadow(color: EeveeSettingsView.spotifyAccentColor.opacity(0.4), radius: 16, x: 0, y: 8)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text("Beam")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Beam v\(EeveeSpotify.version)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#1a1a1a"),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var settingsSection: some View {
        VStack(spacing: 0) {
            settingsButton(
                color: .orange,
                title: "patching".localized,
                imageSystemName: "hammer.fill",
                destination: EeveePatchingSettingsView()
            )
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            settingsButton(
                color: .blue,
                title: "lyrics".localized,
                imageSystemName: "quote.bubble.fill",
                destination: EeveeLyricsSettingsView()
            )
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            settingsButton(
                color: Color(hex: "#64D2FF"),
                title: "customization".localized,
                imageSystemName: "paintpalette.fill",
                destination: EeveeUISettingsView()
            )
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            settingsButton(
                color: .purple,
                title: "experiments".localized,
                imageSystemName: "sparkle",
                destination: EeveeExperimentsSettingsView()
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#1a1a1a"))
        )
    }
    
    private func settingsButton<V: View>(color: Color, title: String, imageSystemName: String, destination: V) -> some View {
        Button {
            pushSettingsController(with: destination, title: title)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.gradient)
                        .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: imageSystemName)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(width: 36, height: 36)
                
                Text(title.localized)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var actionSection: some View {
        VStack(spacing: 0) {
            Button {
                isClearingData = true
                
                DispatchQueue.global(qos: .userInitiated).async {
                    OfflineHelper.resetData(clearCaches: true)
                    
                    DispatchQueue.main.async {
                        exitApplication()
                    }
                }
            } label: {
                HStack {
                    if isClearingData {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    } else {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("reset_data".localized)
                            .foregroundColor(.red)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "#1a1a1a"))
                )
            }
            .disabled(isClearingData)
            .padding(.top, 8)
            
            Text("reset_data_description".localized)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.top, 12)
        }
    }
}
