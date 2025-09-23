

import SwiftUI

struct FriendsView: View {
    private let friends = [
        Friend(name: "Sarah Johnson", initials: "SJ", isOnline: true),
        Friend(name: "Mike Chen", initials: "MC", isOnline: false),
        Friend(name: "Emma Davis", initials: "ED", isOnline: true),
        Friend(name: "Alex Rodriguez", initials: "AR", isOnline: false),
        Friend(name: "Jessica Kim", initials: "JK", isOnline: true),
        Friend(name: "David Wilson", initials: "DW", isOnline: false),
        Friend(name: "Lisa Thompson", initials: "LT", isOnline: true),
        Friend(name: "Ryan Park", initials: "RP", isOnline: false)
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack {
                    Text("Friends")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                
                // Friends List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(friends) { friend in
                            FriendCard(friend: friend)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            // FAB removed; provided globally by MainTabView
        }
    }
}

struct Friend: Identifiable {
    let id = UUID().uuidString
    let name: String
    let initials: String
    let isOnline: Bool
}

struct FriendCard: View {
    let friend: Friend
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar with status indicator
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                
                Text(friend.initials)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                
                // Status indicator
                Circle()
                    .fill(friend.isOnline ? Color.green : Color.gray)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                    )
                    .offset(x: 18, y: 18)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(friend.isOnline ? "Online" : "Offline")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    FriendsView()
}
