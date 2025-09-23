
import SwiftUI

struct HistoryView: View {
    @State private var expandedWorkout: String? = nil
    
    private let workouts = [
        WorkoutHistory(title: "Upper Body Strength", date: "Dec 15", duration: "45 min"),
        WorkoutHistory(title: "Cardio Blast", date: "Dec 13", duration: "30 min"),
        WorkoutHistory(title: "Leg Day", date: "Dec 11", duration: "50 min"),
        WorkoutHistory(title: "Core Training", date: "Dec 9", duration: "25 min"),
        WorkoutHistory(title: "Full Body HIIT", date: "Dec 7", duration: "40 min"),
        WorkoutHistory(title: "Yoga Flow", date: "Dec 5", duration: "60 min"),
        WorkoutHistory(title: "Push Day", date: "Dec 3", duration: "55 min"),
        WorkoutHistory(title: "Pull Day", date: "Dec 1", duration: "50 min")
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack {
                    Text("Workout History")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                
                // Workout List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(workouts) { workout in
                            WorkoutCard(
                                workout: workout,
                                isExpanded: expandedWorkout == workout.id,
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        expandedWorkout = expandedWorkout == workout.id ? nil : workout.id
                                    }
                                }
                            )
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

struct WorkoutHistory: Identifiable {
    let id = UUID().uuidString
    let title: String
    let date: String
    let duration: String
}

struct WorkoutCard: View {
    let workout: WorkoutHistory
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 16) {
                        Text(workout.date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(workout.duration)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
            }
            .padding(16)
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Exercises")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            ExerciseRow(name: "Bench Press", sets: "3 x 8", weight: "135 lbs")
                            ExerciseRow(name: "Overhead Press", sets: "3 x 10", weight: "95 lbs")
                            ExerciseRow(name: "Dips", sets: "3 x 12", weight: "Bodyweight")
                            ExerciseRow(name: "Pull-ups", sets: "3 x 8", weight: "Bodyweight")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct ExerciseRow: View {
    let name: String
    let sets: String
    let weight: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(sets)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(weight)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .trailing)
        }
    }
}

#Preview {
    HistoryView()
}
