//
//  HomeTabView.swift
//  CS4GymApp
//
//  Created by AI Assistant on 9/11/25.
//

import SwiftUI

struct HomeTabView: View {
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    private let weekDays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    
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
            // Tab bar and FAB are provided globally by MainTabView
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
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                ForEach(7..<14) { day in
                    let isSelected = day == selectedDay
                    VStack(spacing: 6) {
                        Text("\(day)")
                            .fontWeight(.semibold)
                            .foregroundColor(isSelected ? .white : Color(.label))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isSelected ? Color.blue : Color(.systemGray5))
                            )
                        Text(weekDays[(day-1)%7])
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture { selectedDay = day }
                }
            }
        }
    }
    
    private var monthGrid: some View {
        let days = Array(1...27)
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
            ForEach(days, id: \.self) { day in
                let isActive = [2,5,7,10,12,16,18,21,24,27].contains(day)
                Text("\(day)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isActive ? Color.blue : Color(.systemGray5))
                    )
                    .foregroundColor(isActive ? .white : Color(.secondaryLabel))
            }
        }
    }
    
    // Removed local tab bar and plus button; handled by MainTabView
}

#Preview {
    HomeTabView()
}
