import SwiftUI

struct MedicationView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingAddMedication = false
    @State private var showingEditMedication = false
    @State private var selectedMedication: Medication?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userSettings.medications) { medication in
                    MedicationRow(medication: medication)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedMedication = medication
                            showingEditMedication = true
                        }
                }
                .onDelete(perform: deleteMedication)
            }
            .navigationTitle("Medications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMedication = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                MedicationInputView()
            }
            .sheet(isPresented: $showingEditMedication, content: {
                if let medication = selectedMedication {
                    EditMedicationView(medication: medication)
                }
            })
        }
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        userSettings.medications.remove(atOffsets: offsets)
    }
}

struct MedicationRow: View {
    let medication: Medication
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                Text("Dosage: \(medication.dosage)")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
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
        .padding(.vertical, 8)
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