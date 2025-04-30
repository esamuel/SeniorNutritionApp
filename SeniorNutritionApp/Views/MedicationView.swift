import SwiftUI

struct MedicationView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingAddMedication = false
    @State private var showingEditMedication = false
    @State private var selectedMedication: Medication?
    @State private var showingDeleteAlert = false
    @State private var medicationToDelete: Medication?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Quick Actions
                    HStack(spacing: 15) {
                        quickActionButton(
                            icon: "plus.circle.fill",
                            title: "Add Medication",
                            action: { showingAddMedication = true }
                        )
                        
                        quickActionButton(
                            icon: "bell.fill",
                            title: "Reminders",
                            action: { /* TODO: Show reminders settings */ }
                        )
                    }
                    .padding(.horizontal)
                    
                    // Medication List
                    if userSettings.medications.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(userSettings.medications) { medication in
                            MedicationCard(medication: medication)
                                .onTapGesture {
                                    selectedMedication = medication
                                    showingEditMedication = true
                                }
                                .contextMenu {
                                    Button {
                                        selectedMedication = medication
                                        showingEditMedication = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        medicationToDelete = medication
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        medicationToDelete = medication
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Medications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMedication = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                MedicationInputView()
            }
            .sheet(isPresented: $showingEditMedication) {
                if let medication = selectedMedication {
                    EditMedicationView(medication: medication)
                }
            }
            .alert("Delete Medication", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let medication = medicationToDelete {
                        deleteMedication(medication)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this medication? This action cannot be undone.")
            }
            .onAppear {
                print("DEBUG: MedicationView appearing with \(userSettings.medications.count) medications")
                for med in userSettings.medications {
                    print("DEBUG: Medication in view: \(med.name)")
                }
                
                // No longer adding sample medications automatically
                // This allows the user to add their own medications
            }
        }
    }
    
    private func deleteMedication(_ medication: Medication) {
        if let index = userSettings.medications.firstIndex(where: { $0.id == medication.id }) {
            withAnimation {
                userSettings.medications.remove(at: index)
            }
        }
    }
    
    // No longer needed - removed clear all data functionality
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "pills")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("No Medications Added")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            Text("Tap the + button to add your first medication")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    // No sample medications are added automatically anymore
    
    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct MedicationCard: View {
    let medication: Medication
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Pill shape and color visualization
                pillShapeView(medication: medication)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 4)
                
                Text(medication.name)
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                Spacer()
                
                if medication.takeWithFood {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.blue)
                }
            }
            
            if !medication.dosage.isEmpty {
                HStack {
                    Image(systemName: "pills")
                        .foregroundColor(.blue)
                    Text("Dosage: \(medication.dosage)")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                Text(formatTimesOfDay(medication.timesOfDay))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            if let notes = medication.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal)
        .contentShape(Rectangle())
    }
    
    /// Formats an array of TimeOfDay into a comma-separated string (e.g., "8:00 AM, 8:00 PM")
    private func formatTimesOfDay(_ times: [TimeOfDay]) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let calendar = Calendar.current
        
        // Sort times for consistent display
        let sortedTimes = times.sorted()
        
        return sortedTimes.map { timeOfDay -> String in
            // Create a date component for formatting
            var components = DateComponents()
            components.hour = timeOfDay.hour
            components.minute = timeOfDay.minute
            // Use today's date just to get a valid Date object for the formatter
            if let date = calendar.date(from: components) {
                return formatter.string(from: date)
            } else {
                // Fallback if date creation fails
                return String(format: "%02d:%02d", timeOfDay.hour, timeOfDay.minute)
            }
        }.joined(separator: ", ")
    }
    
    // Function to display the pill shape and color
    private func pillShapeView(medication: Medication) -> some View {
        let color = medication.color ?? .blue
        let shape = medication.shape ?? .capsule
        
        return Group {
            switch shape {
            case .round:
                Circle()
                    .fill(color)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            case .oval:
                Capsule()
                    .fill(color)
                    .frame(width: 30, height: 20)
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            case .capsule:
                Capsule()
                    .fill(color)
                    .frame(width: 30, height: 15)
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            case .rectangle:
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 25, height: 20)
                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 1))
            case .diamond:
                MedicationDiamondShape()
                    .fill(color)
                    .frame(width: 25, height: 25)
                    .overlay(MedicationDiamondShape().stroke(Color.gray, lineWidth: 1))
            case .triangle:
                MedicationTriangleShape()
                    .fill(color)
                    .frame(width: 25, height: 25)
                    .overlay(MedicationTriangleShape().stroke(Color.gray, lineWidth: 1))
            case .other:
                Text("?")
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
        }
    }
}

// Custom shapes for pill visualization in MedicationView
struct MedicationDiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        
        return path
    }
}

struct MedicationTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
            .environmentObject(UserSettings())
    }
}