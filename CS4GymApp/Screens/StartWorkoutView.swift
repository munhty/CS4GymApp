
import SwiftUI

struct WorkoutTemplate: Identifiable {
    let id = UUID().uuidString
    let name: String
    let exercises: [String]
    let estimatedDuration: Int // minutes
}

struct StartWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTemplate: WorkoutTemplate?
    // Removed unused timer state for a leaner view
    @State private var showActiveWorkout = false
    @State private var launchTemplate: WorkoutTemplate? = nil
    
    private let templates = [
        WorkoutTemplate(name: "Upper Body", exercises: ["Bench Press", "Overhead Press", "Dips", "Pull-ups"], estimatedDuration: 45),
        WorkoutTemplate(name: "Lower Body", exercises: ["Squats", "Deadlifts", "Lunges", "Calf Raises"], estimatedDuration: 50),
        WorkoutTemplate(name: "Cardio Blast", exercises: ["Burpees", "Mountain Climbers", "Jump Squats", "High Knees"], estimatedDuration: 30),
        WorkoutTemplate(name: "Core Focus", exercises: ["Plank", "Crunches", "Russian Twists", "Leg Raises"], estimatedDuration: 25)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Timer Display
                    timerSection
                    
                    // Template Selection
                    templateSection
                    
                    // Start without template
                    Button(action: { presentActiveWorkout(template: nil) }) {
                        Text("Start Without Template")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    actionButtons
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Start Workout")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showActiveWorkout) {
            ActiveWorkoutView(template: launchTemplate)
        }
    }
    
    private var timerSection: some View {
        VStack(spacing: 16) {
            Text("Workout Duration")
                .font(.headline)
                .foregroundColor(.primary)
            
            ZStack {
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: workoutDuration / 3600) // Assuming max 1 hour
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text(timeString)
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                    
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private var templateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Template")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                // New Template Option
                Button(action: { createNewTemplate() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                        
                        Text("New Template")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.05))
                            )
                    )
                }
                
                // Existing Templates
                ForEach(templates) { template in
                    TemplateCard(
                        template: template,
                        isSelected: selectedTemplate?.id == template.id,
                        onTap: { selectedTemplate = template }
                    )
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if isWorkoutActive {
                Button(action: stopWorkout) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("Stop Workout")
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .cornerRadius(12)
                }
            } else {
                Button(action: startWorkout) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Workout")
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(selectedTemplate != nil ? Color.green : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(selectedTemplate == nil)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var timeString: String {
        let minutes = Int(workoutDuration) / 60
        let seconds = Int(workoutDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startWorkout() {
        guard selectedTemplate != nil else { return }
        presentActiveWorkout(template: selectedTemplate)
    }
    
    private func stopWorkout() {
        isWorkoutActive = false
        timer?.invalidate()
        timer = nil
        // Could save workout data here
        dismiss()
    }
    
    private func createNewTemplate() {
        // Could present a template creation view
        selectedTemplate = WorkoutTemplate(name: "Custom Workout", exercises: [], estimatedDuration: 30)
    }

    private func presentActiveWorkout(template: WorkoutTemplate?) {
        launchTemplate = template
        showActiveWorkout = true
    }
}

struct TemplateCard: View {
    let template: WorkoutTemplate
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(template.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(template.estimatedDuration) min")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(template.exercises.count) exercises")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

#Preview {
    StartWorkoutView()
}
