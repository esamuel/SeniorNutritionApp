import SwiftUI

struct MedicationsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var showingAddMedication = false
    @State private var showingEditMedication = false
    @State private var selectedMedication: Medication?
    @State private var showingDeleteAlert = false
    @State private var medicationToDelete: Medication?
    
    var body: some View {
        List {
            // Current Medications Section
            Section(header: Text(NSLocalizedString("Current Medications", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                if userSettings.medications.isEmpty {
                    Text(NSLocalizedString("No medications added", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(userSettings.medications) { medication in
                        MedicationCard(medication: medication)
                            .onTapGesture {
                                selectedMedication = medication
                                showingEditMedication = true
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    medicationToDelete = medication
                                    showingDeleteAlert = true
                                } label: {
                                    Label(NSLocalizedString("Delete", comment: "Delete action"), systemImage: "trash")
                                }
                            }
                    }
                }
            }
            
            // Add Medication Button
            Section {
                Button(action: {
                    showingAddMedication = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("Add Medication", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
            
            // Today's Schedule Section
            if !userSettings.medications.isEmpty {
                Section(header: Text(NSLocalizedString("Today's Schedule", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                    let todaysMedications = getTodaysMedications()
                    if todaysMedications.isEmpty {
                        Text(NSLocalizedString("No medications scheduled for today", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(todaysMedications) { medication in
                            MedicationScheduleRow(medication: medication)
                        }
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("Medications", comment: ""))
        .sheet(isPresented: $showingAddMedication) {
            MedicationInputView()
        }
        .sheet(isPresented: $showingEditMedication) {
            if let medication = selectedMedication {
                EditMedicationView(medication: medication)
            }
        }
        .alert(NSLocalizedString("Delete Medication", comment: "Alert title"), isPresented: $showingDeleteAlert) {
            Button(NSLocalizedString("Cancel", comment: "Cancel button"), role: .cancel) { }
            Button(NSLocalizedString("Delete", comment: "Delete button"), role: .destructive) {
                if let medication = medicationToDelete {
                    deleteMedication(medication)
                }
            }
        } message: {
            Text(NSLocalizedString("Are you sure you want to delete this medication? This action cannot be undone.", comment: "Delete confirmation message"))
        }
        .onAppear {
            print("DEBUG: MedicationsView appearing with \(userSettings.medications.count) medications")
            for med in userSettings.medications {
                print("DEBUG: Medication in view: \(med.name)")
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
    
    private func getTodaysMedications() -> [Medication] {
        let today = Date()
        return userSettings.medications.filter { medication in
            medication.isDue(on: today)
        }
    }
}

struct MedicationScheduleRow: View {
    let medication: Medication
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(medication.name)
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
            
            ForEach(medication.timesOfDay.sorted(), id: \.self) { time in
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text(formatTime(time))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ time: TimeOfDay) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: Date()) ?? Date()
        return dateFormatter.string(from: date)
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MedicationsView()
                .environmentObject(UserSettings())
        }
    }
} 