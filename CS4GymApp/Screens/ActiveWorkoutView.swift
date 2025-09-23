import SwiftUI

struct WorkoutExercise: Identifiable, Hashable {
    let id = UUID().uuidString
    var name: String
    var previous: String?
    var sets: [SetEntry]
}

struct SetEntry: Identifiable, Hashable {
    let id = UUID().uuidString
    var index: Int
    var previous: String?
    var weightKg: String
    var reps: String
    var completed: Bool
}

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var note: String = ""
    @State private var elapsed: TimeInterval = 0
    @State private var exercises: [WorkoutExercise]
    
    init(template: WorkoutTemplate?) {
        if let t = template {
            let ex = WorkoutExercise(
                name: t.name,
                previous: nil,
                sets: [
                    SetEntry(index: 1, previous: nil, weightKg: "", reps: "", completed: false)
                ]
            )
            _exercises = State(initialValue: [ex])
        } else {
            _exercises = State(initialValue: [])
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header
                        noteField
                        ForEach($exercises) { $exercise in
                            exerciseSection(exercise: $exercise)
                        }
                        addButtons
                        cancelButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Evening Workout").font(.headline)
                        Text(timeString(elapsed)).font(.caption).foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "ellipsis")
                }
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                elapsed += 1
            }
        }
    }
    
    private var header: some View {
        HStack { Spacer() }
            .frame(height: 1)
    }
    
    private var noteField: some View {
        TextField("Workout note", text: $note)
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5)))
    }
    
    private func exerciseSection(exercise: Binding<WorkoutExercise>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {}) {
                    Text(exercise.wrappedValue.name)
                        .foregroundColor(Color.blue)
                        .underline()
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
            .padding(.top, 6)
            
            tableHeader
            ForEach(exercise.sets) { _ in }
            ForEach(exercise.sets.indices, id: \.self) { i in
                setRow(exercise: exercise, index: i)
                    .background(i % 2 == 0 ? Color.clear : Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    private var tableHeader: some View {
        HStack {
            Text("SET").font(.caption).foregroundColor(.secondary).frame(width: 34, alignment: .leading)
            Text("PREVIOUS").font(.caption).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)
            Text("KG").font(.caption).foregroundColor(.secondary).frame(width: 56)
            Text("REPS").font(.caption).foregroundColor(.secondary).frame(width: 56)
            Spacer().frame(width: 28)
        }
    }
    
    private func setRow(exercise: Binding<WorkoutExercise>, index: Int) -> some View {
        HStack(spacing: 8) {
            Text("\(exercise.wrappedValue.sets[index].index)")
                .foregroundColor(.blue)
                .frame(width: 34, alignment: .leading)
            Text(exercise.wrappedValue.sets[index].previous ?? "")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("0", text: exercise.sets[index].weightKg)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 56)
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemGray5)))
            TextField("0", text: exercise.sets[index].reps)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 56)
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemGray5)))
            Button(action: { exercise.sets[index].completed.wrappedValue.toggle() }) {
                Image(systemName: exercise.wrappedValue.sets[index].completed ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(exercise.wrappedValue.sets[index].completed ? .green : .gray)
            }
        }
        .padding(.vertical, 6)
    }
    
    private var addButtons: some View {
        VStack(spacing: 8) {
            Button("ADD SET") { addSet() }
                .foregroundColor(Color.blue)
            Button("ADD EXERCISE") { addExercise() }
                .foregroundColor(Color.blue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    private var cancelButton: some View {
        Button("CANCEL WORKOUT") { dismiss() }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
    
    private func addSet() {
        guard !exercises.isEmpty else { addExercise(); return }
        var first = exercises[0]
        let nextIndex = (first.sets.last?.index ?? 0) + 1
        first.sets.append(SetEntry(index: nextIndex, previous: nil, weightKg: "", reps: "", completed: false))
        exercises[0] = first
    }
    
    private func addExercise() {
        let ex = WorkoutExercise(name: "Squat (Barbell)", previous: nil, sets: [SetEntry(index: 1, previous: nil, weightKg: "", reps: "", completed: false)])
        exercises.append(ex)
    }
    
    private func timeString(_ t: TimeInterval) -> String {
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    ActiveWorkoutView(template: nil)
}


