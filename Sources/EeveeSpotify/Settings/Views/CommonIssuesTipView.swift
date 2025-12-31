import SwiftUI

struct CommonIssuesTipView: View {
    var onDismiss: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            onDismiss()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.gradient)
                        .shadow(color: .orange.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: "exclamationmark.bubble.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("common_issues_tip_title".localized)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("common_issues_tip_message".localized)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                        + Text(" ")
                        + Text("common_issues_tip_button".localized)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(EeveeSettingsView.spotifyAccentColor)
                        + Text(".")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "#2a2a1a"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}
