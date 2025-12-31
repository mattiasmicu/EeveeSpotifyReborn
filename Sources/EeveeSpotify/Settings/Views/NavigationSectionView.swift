import SwiftUI

struct NavigationSectionView: View {
    var color: Color
    var title: String
    var imageSystemName: String
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.gradient)
                    .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: imageSystemName)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(width: 36, height: 36)
            .scaleEffect(isPressed ? 0.92 : 1.0)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .rotationEffect(.degrees(isPressed ? 5 : 0))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .contentShape(Rectangle())
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

struct NavigationSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 12) {
                NavigationSectionView(
                    color: .orange,
                    title: "Patching",
                    imageSystemName: "hammer.fill"
                )
                NavigationSectionView(
                    color: .blue,
                    title: "Lyrics",
                    imageSystemName: "quote.bubble.fill"
                )
                NavigationSectionView(
                    color: Color(hex: "#64D2FF"),
                    title: "Customization",
                    imageSystemName: "paintpalette.fill"
                )
            }
            .padding()
        }
    }
}
