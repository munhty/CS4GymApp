
import SwiftUI

struct BadgeData: Identifiable {
    let id = UUID().uuidString
    let title: String
    let icon: String
    let colors: [Color]
    let isEarned: Bool
    let level: Int
}

struct AnimeBadge: View {
    let data: BadgeData
    @State private var animateSparkles: Bool = false
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 74, height: 74)
                .shadow(color: gradientColors.first!.opacity(0.6), radius: 12, x: 0, y: 0)
                .shadow(color: gradientColors.last!.opacity(0.4), radius: 18, x: 0, y: 0)
            
            // Inner core
            Circle()
                .fill(RadialGradient(colors: [Color.white.opacity(0.25), Color.white.opacity(0.02)], center: .center, startRadius: 2, endRadius: 34))
                .frame(width: 66, height: 66)
                .blendMode(.screen)
            
            // Icon
            Image(systemName: data.icon)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                .overlay(
                    LinearGradient(colors: [Color.white.opacity(0.7), Color.clear], startPoint: .top, endPoint: .bottom)
                        .mask(Image(systemName: data.icon).font(.system(size: 26, weight: .bold)))
                )
            
            // Sparkles
            sparkles
        }
        .overlay(levelBadge, alignment: .bottomTrailing)
        .opacity(data.isEarned ? 1.0 : 0.5)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                animateSparkles = true
            }
        }
    }
    
    private var gradientColors: [Color] {
        if data.colors.count >= 2 { return data.colors }
        return [Color.purple, Color.blue]
    }
    
    private var levelBadge: some View {
        Text("Lv\(data.level)")
            .font(.caption2.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(Color.black.opacity(0.35))
            )
            .offset(x: 4, y: 4)
    }
    
    private var sparkles: some View {
        ZStack {
            sparkle(offset: CGSize(width: -20, height: -18), baseScale: 0.85)
            sparkle(offset: CGSize(width: 18, height: -22), baseScale: 1.0)
            sparkle(offset: CGSize(width: 22, height: 16), baseScale: 0.8)
            sparkle(offset: CGSize(width: -22, height: 14), baseScale: 0.9)
        }
    }
    
    private func sparkle(offset: CGSize, baseScale: CGFloat) -> some View {
        Circle()
            .fill(Color.white.opacity(0.9))
            .frame(width: 6, height: 6)
            .blur(radius: 0.5)
            .overlay(
                Circle().stroke(Color.white.opacity(0.9), lineWidth: 0.5)
            )
            .scaleEffect(animateSparkles ? baseScale : baseScale * 0.6)
            .opacity(animateSparkles ? 1.0 : 0.6)
            .offset(offset)
    }
}

struct BadgesCollection: View {
    let badges: [BadgeData]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(badges) { badge in
                VStack(spacing: 8) {
                    AnimeBadge(data: badge)
                    Text(badge.title)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
            }
        }
    }
}

#Preview {
    let sample: [BadgeData] = [
        BadgeData(title: "S-Rank", icon: "sparkles", colors: [.pink, .purple], isEarned: true, level: 9),
        BadgeData(title: "Combo Master", icon: "bolt.fill", colors: [.yellow, .orange], isEarned: true, level: 7),
        BadgeData(title: "Shield Hero", icon: "shield.fill", colors: [.teal, .blue], isEarned: false, level: 3),
        BadgeData(title: "Zen", icon: "leaf.fill", colors: [.green, .mint], isEarned: true, level: 4),
        BadgeData(title: "Ultra", icon: "flame.fill", colors: [.red, .orange], isEarned: false, level: 2),
        BadgeData(title: "Stellar", icon: "star.fill", colors: [.indigo, .blue], isEarned: true, level: 6)
    ]
    return AnyView(
        VStack(alignment: .leading, spacing: 16) {
            Text("Anime Badges").font(.headline)
            BadgesCollection(badges: sample)
                .padding()
        }
    )
}


