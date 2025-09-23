
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var showStartWorkout = false
    
    enum Tab: CaseIterable {
        case home, history, friends, profile
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .history: return "clock.arrow.circlepath"
            case .friends: return "person.2"
            case .profile: return "person.crop.circle"
            }
        }
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .history: return "History"
            case .friends: return "Friends"
            case .profile: return "Profile"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case .home:
                    HomeScreen()
                case .history:
                    HistoryView()
                case .friends:
                    FriendsView()
                case .profile:
                    ProfileView()
                }
            }
            
            // Tab bar overlaid so it always shows above content
        }
        .overlay(customTabBar, alignment: .bottom)
        .sheet(isPresented: $showStartWorkout) {
            StartWorkoutView()
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabSlot { tabItem(tab: .home, selected: selectedTab == .home) }
            tabSlot { tabItem(tab: .history, selected: selectedTab == .history) }
            tabSlot { Color.clear.frame(height: 1) } // center slot for plus
            tabSlot { tabItem(tab: .friends, selected: selectedTab == .friends) }
            tabSlot { tabItem(tab: .profile, selected: selectedTab == .profile) }
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue)
                .ignoresSafeArea(edges: .bottom)
        )
        .foregroundColor(.white)
        .overlay(
            // Floating Action Button
            Button(action: { showStartWorkout = true }) {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 54, height: 54)
                    .background(Circle().fill(Color.blue))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .offset(y: -27)
        )
    }
    
    private func tabItem(tab: Tab, selected: Bool) -> some View {
        Button(action: { selectedTab = tab }) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                Text(tab.title).font(.caption2)
            }
            .opacity(selected ? 1 : 0.9)
        }
        .foregroundColor(.white)
    }
    
    private func tabSlot<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainTabView()
}

// MARK: - Home Screen (merged former HomeTabView)

private struct HomeScreen: View {
    @State private var today: Date = Date()
    @State private var selectedDate: Date = Date()
    private let calendar: Calendar = .current
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGray6).ignoresSafeArea()
            VStack(spacing: 16) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        weeklyActivityCard
                        weekScroller
                        Text("Last Month").font(.headline)
                        monthGrid
                            .padding(.bottom, 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
        }
    }
    
    private var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weekly Activity").font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.secondary)
            }
            HStack {
                Spacer()
                ProgressRing(progress: 0.43)
                Spacer()
            }
            HStack {
                Spacer()
                Text("3/7 days").font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
    
    private var weekScroller: some View {
        let week = currentWeekDates()
        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                ForEach(week, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                    VStack(spacing: 6) {
                        Text(dayNumber(date))
                            .fontWeight(.semibold)
                            .foregroundColor(isSelected ? .white : Color(.label))
                            .frame(width: 44, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isSelected ? Color.blue : Color(.systemGray5))
                            )
                        Text(weekdaySymbol(date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture { selectedDate = date }
                }
            }
        }
    }
    
    private var monthGrid: some View {
        let range: Range<Int> = calendar.range(of: .day, in: .month, for: today) ?? 1..<29
        let todayDay = calendar.component(.day, from: today)
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
            ForEach(Array(range), id: \.self) { day in
                let isActive = [2,5,7,10,12,16,18,21,24,27].contains(day)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isActive ? Color.blue : Color(.systemGray5))
                    Text("\(day)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isActive ? .white : Color(.secondaryLabel))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(day == todayDay ? Color.blue : Color.clear, lineWidth: 2)
                )
            }
        }
    }

    // MARK: - Date Helpers
    private func startOfWeek(for date: Date) -> Date {
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: comps) ?? date
    }
    private func currentWeekDates() -> [Date] {
        let start = startOfWeek(for: today)
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }
    private func dayNumber(_ date: Date) -> String {
        String(calendar.component(.day, from: date))
    }
    private func weekdaySymbol(_ date: Date) -> String {
        let idx = calendar.component(.weekday, from: date) - 1
        return calendar.shortWeekdaySymbols[idx]
    }
}

