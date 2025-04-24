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
        }
    }
    
    private func deleteMedication(_ medication: Medication) {
        if let index = userSettings.medications.firstIndex(where: { $0.id == medication.id }) {
            withAnimation {
                userSettings.medications.remove(at: index)
            }
        }
    }
    
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
                Text(formatSchedule(medication.schedule))
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
    
    private func formatSchedule(_ schedule: [Date]) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return schedule.map { formatter.string(from: $0) }.joined(separator: ", ")
    }
}

struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
            .environmentObject(UserSettings())
    }
} 