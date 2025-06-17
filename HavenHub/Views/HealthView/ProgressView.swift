//
//  ProgressView.swift
//  HavenHub
//
//  Created by Khush Patel on 6/12/25.
//

import SwiftUI

struct Goal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var priority: Double
    var progress: Double
    var isCompleted: Bool = false
}

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = [] {
        didSet {
            saveGoals()
        }
    }

    init() {
        loadGoals()
    }

    func addGoal(title: String, dueDate: Date, priority: Double, progress: Double) {
        let newGoal = Goal(title: title, dueDate: dueDate, priority: priority, progress: progress)
        goals.append(newGoal)
    }

    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "SavedGoals")
        }
    }

    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: "SavedGoals"),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            self.goals = decoded
        }
    }
}

struct GoalView: View {
    @StateObject var viewModel = GoalViewModel()
    @State private var title: String = ""
    @State private var dueDate = Date()
    @State private var priority: Double = 0.5
    @State private var progress: Double = 0.0
    @State private var showConfetti = false
    @State private var showCongrats = false
    @FocusState private var isTitleFocused: Bool

    func complete(goal: Goal) {
        if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.goals[index].isCompleted = true
            withAnimation {
                showConfetti = true
                showCongrats = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showConfetti = false
                    showCongrats = false
                }
            }
        }
    }

    var sortedGoals: [Goal] {
        viewModel.goals
            .filter { !$0.isCompleted }
            .sorted {
                if $0.dueDate != $1.dueDate {
                    return $0.dueDate < $1.dueDate
                } else {
                    return $0.priority > $1.priority
                }
            }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter your goal", text: $title)
                        .focused($isTitleFocused)

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)

                    VStack(alignment: .leading) {
                        Text("Priority")
                        Slider(value: $priority, in: 0...1)
                            .accentColor(.red)
                    }

                    VStack(alignment: .leading) {
                        Text("Progress")
                        Slider(value: $progress, in: 0...1)
                            .accentColor(.green)
                    }

                    Button(action: {
                        if !title.trimmingCharacters(in: .whitespaces).isEmpty {
                            viewModel.addGoal(title: title, dueDate: dueDate, priority: priority, progress: progress)
                            title = ""
                            progress = 0
                            priority = 0.5
                            dueDate = Date()
                            isTitleFocused = false
                        }
                    }) {
                        Text("Add Goal")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                if sortedGoals.isEmpty {
                    Section {
                        Text("No goals yet. Add one above!")
                            .foregroundColor(.gray)
                    }
                } else {
                    Section(header: Text("Your Goals")) {
                        ForEach(sortedGoals) { goal in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(goal.title)
                                    .font(.headline)
                                    .strikethrough(goal.isCompleted, color: .green)
                                    .foregroundColor(goal.isCompleted ? .gray : .primary)

                                Text("Due: \(goal.dueDate, formatter: dateFormatter)")
                                    .font(.subheadline)

                                ProgressView("Progress", value: goal.progress)
                                ProgressView("Priority", value: goal.priority)
                                    .tint(.red)
                            }
                            .padding(5)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    complete(goal: goal)
                                } label: {
                                    Label("Complete", systemImage: "checkmark.circle")
                                }
                                .tint(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Set SMART Goals")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isTitleFocused = false
                    }
                }
            }
            .overlay(
                ZStack {
                    if showConfetti {
                        ConfettiView()
                            .transition(.opacity)
                    }

                    if showCongrats {
                        Text("🎉 Congrats on completing a goal!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .shadow(radius: 10)
                            .transition(.scale)
                    }
                }
            )
        }
    }
}

struct ConfettiView: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<30, id: \ .self) { i in
                    Circle()
                        .fill(Color(hue: Double.random(in: 0...1),
                                    saturation: 0.8,
                                    brightness: 1.0))
                        .frame(width: 8, height: 8)
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: animate ? geometry.size.height + 50 : -50)
                        .animation(.linear(duration: Double.random(in: 2.0...3.0)).delay(Double(i) * 0.05), value: animate)
                }
            }
            .onAppear {
                animate = true
            }
        }
        .ignoresSafeArea()
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
