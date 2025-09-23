
import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Profile")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .background(Color(.systemGray6))
                
                // Profile Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Info Section
                        VStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Name
                            Text(UserDefaults.standard.string(forKey: "displayName") ?? "Athlete")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            // Stats
                            HStack(spacing: 32) {
                                StatItem(number: "127", label: "Workouts")
                                StatItem(number: "45", label: "Streak")
                                StatItem(number: "8.2k", label: "Points")
                            }
                        }
                        .padding(.top, 20)
                        
                        // Badges Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Badges")
                                    .font(.headline.weight(.semibold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            
                            BadgesCollection(badges: sampleBadges)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            // FAB removed; provided globally by MainTabView
        }
    }
}

struct StatItem: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.title2.weight(.bold))
                .foregroundColor(.blue)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

extension ProfileView {
    var sampleBadges: [BadgeData] {
        [
            BadgeData(title: "S-Rank", icon: "sparkles", colors: [.pink, .purple], isEarned: true, level: 9),
            BadgeData(title: "Combo Master", icon: "bolt.fill", colors: [.yellow, .orange], isEarned: true, level: 7),
            BadgeData(title: "Shield Hero", icon: "shield.fill", colors: [.teal, .blue], isEarned: false, level: 3),
            BadgeData(title: "Zen", icon: "leaf.fill", colors: [.green, .mint], isEarned: true, level: 4),
            BadgeData(title: "Ultra", icon: "flame.fill", colors: [.red, .orange], isEarned: false, level: 2),
            BadgeData(title: "Stellar", icon: "star.fill", colors: [.indigo, .blue], isEarned: true, level: 6)
        ]
    }
}

#Preview {
    ProfileView()
}
