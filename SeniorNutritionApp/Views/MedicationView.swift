import SwiftUI

struct MedicationView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var medications: [Medication] = []
    @State private var showingAddMedication = false
    @State private var showingMedicationDetail: Medication? = nil
    @State private var showingVoiceInput = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if medications.isEmpty {
                    emptyStateView
                } else {
                    medicationListView
                }
            }
            .navigationTitle("Medications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMedication = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.large)
                            
                            Text("Add")
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView { newMedication in
                    medications.append(newMedication)
                    userSettings.medications = medications
                }
            }
            .sheet(item: $showingMedicationDetail) { medication in
                MedicationDetailView(medication: medication)
            }
            .onAppear {
                // Load medications from userSettings
                medications = userSettings.medications
                
                // Add sample data if needed
                if medications.isEmpty && userSettings.medications.isEmpty {
                    createSampleMedications()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Empty state view
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "pill")
                .font(.system(size: 70))
                .foregroundColor(.blue.opacity(0.7))
            
            Text("No Medications Added")
                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            
            Text("Tap the Add button to start tracking your medications and coordinate them with your fasting schedule.")
                .font(.system(size: userSettings.textSize.size))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: {
                showingAddMedication = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Medication")
                        .font(.system(size: userSettings.textSize.size))
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    // Medication list view
    private var medicationListView: some View {
        VStack(spacing: 0) {
            // Today's medications
            todayScheduleSection
            
            // Quick action buttons
            quickActionsSection
                .padding()
            
            // Full medication list
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(medications) { medication in
                        medicationCard(medication: medication)
                            .onTapGesture {
                                showingMedicationDetail = medication
                            }
                    }
                }
                .padding()
            }
        }
    }
    
    // Today's medication schedule section
    private var todayScheduleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's Schedule")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(todayMedications) { medication in
                        todayMedicationCard(medication: medication)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
    }
    
    // Quick action buttons section
    private var quickActionsSection: some View {
        HStack(spacing: 20) {
            Button(action: {
                showingAddMedication = true
            }) {
                quickActionButton(
                    icon: "plus.circle.fill",
                    title: "Add New",
                    color: .blue
                )
            }
            
            Button(action: {
                showingVoiceInput = true
            }) {
                quickActionButton(
                    icon: "mic.fill",
                    title: "Voice Add",
                    color: .green
                )
            }
            
            Button(action: {
                // Action to print medication list
            }) {
                quickActionButton(
                    icon: "printer.fill",
                    title: "Print List",
                    color: .purple
                )
            }
        }
    }
    
    // Helper for quick action buttons
    private func quickActionButton(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Card for today's medications
    private func todayMedicationCard(medication: Medication) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(nextDoseTime(for: medication))
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: medication.takeWithFood ? "fork.knife" : "drop.fill")
                    .foregroundColor(.white)
            }
            
            Text(medication.name)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.white)
            
            Text(medication.dosage)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .frame(width: 180, height: 130)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(medication.takeWithFood ? Color.orange : Color.blue)
        )
        .shadow(radius: 2)
    }
    
    // Card for medication in the full list
    private func medicationCard(medication: Medication) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "pill.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.blue)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(medication.name)
                    .font(.system(size: userSettings.textSize.size))
                
                Text(medication.dosage)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                
                if medication.takeWithFood {
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.orange)
                        
                        Text("Take with food")
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                if let nextSchedule = medication.schedule.first {
                    Text(timeFormatter.string(from: nextSchedule))
                        .font(.system(size: userSettings.textSize.size))
                    
                    Text(isScheduledToday(nextSchedule) ? "Today" : "Tomorrow")
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper to check if a date is today
    private func isScheduledToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    // Helper to format the next dose time
    private func nextDoseTime(for medication: Medication) -> String {
        guard let nextDose = medication.schedule.first else {
            return "No time"
        }
        
        return timeFormatter.string(from: nextDose)
    }
    
    // Computed property for today's medications
    private var todayMedications: [Medication] {
        medications.filter { medication in
            guard let nextDose = medication.schedule.first else {
                return false
            }
            
            return Calendar.current.isDateInToday(nextDose)
        }
    }
    
    // Time formatter
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    // Create sample medication data
    private func createSampleMedications() {
        let calendar = Calendar.current
        
        // Create different times through the day
        var morningComponents = DateComponents()
        morningComponents.hour = 8
        morningComponents.minute = 0
        
        var noonComponents = DateComponents()
        noonComponents.hour = 12
        noonComponents.minute = 0
        
        var eveningComponents = DateComponents()
        eveningComponents.hour = 18
        eveningComponents.minute = 0
        
        // Create sample medications
        medications = [
            Medication(
                name: "Blood Pressure Med",
                dosage: "10mg",
                schedule: [calendar.date(from: morningComponents)!],
                takeWithFood: true
            ),
            Medication(
                name: "Vitamin D",
                dosage: "1000 IU",
                schedule: [calendar.date(from: morningComponents)!],
                takeWithFood: true,
                notes: "Take with breakfast"
            ),
            Medication(
                name: "Heart Medication",
                dosage: "25mg",
                schedule: [calendar.date(from: morningComponents)!, calendar.date(from: eveningComponents)!],
                takeWithFood: false,
                notes: "Take on empty stomach"
            )
        ]
        
        userSettings.medications = medications
    }
}

// Medication Add View
struct AddMedicationView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var notes: String = ""
    @State private var takeWithFood: Bool = false
    @State private var selectedTime = Date()
    @State private var showingVoiceInput = false
    
    var onSave: (Medication) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details").font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        Text("Name")
                            .font(.system(size: userSettings.textSize.size))
                        
                        TextField("Medication name", text: $name)
                            .font(.system(size: userSettings.textSize.size))
                        
                        Button(action: {
                            showingVoiceInput = true
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        Text("Dosage")
                            .font(.system(size: userSettings.textSize.size))
                        
                        TextField("Amount (e.g. 10mg)", text: $dosage)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                Section(header: Text("Schedule").font(.system(size: userSettings.textSize.size))) {
                    DatePicker("Time to take",
                               selection: $selectedTime,
                               displayedComponents: .hourAndMinute)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Additional Options").font(.system(size: userSettings.textSize.size))) {
                    Toggle("Take with food", isOn: $takeWithFood)
                        .font(.system(size: userSettings.textSize.size))
                    
                    TextField("Notes (optional)", text: $notes)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveMedication) {
                        Text("Save Medication")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    private func saveMedication() {
        let newMedication = Medication(
            name: name,
            dosage: dosage,
            schedule: [selectedTime],
            takeWithFood: takeWithFood,
            notes: notes.isEmpty ? nil : notes
        )
        
        onSave(newMedication)
        presentationMode.wrappedValue.dismiss()
    }
}

// Medication Detail View
struct MedicationDetailView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    let medication: Medication
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Medication header
                    VStack(spacing: 10) {
                        Image(systemName: "pill.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text(medication.name)
                            .font(.system(size: userSettings.textSize.size + 6, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        Text(medication.dosage)
                            .font(.system(size: userSettings.textSize.size + 2))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Medication details
                    VStack(alignment: .leading, spacing: 15) {
                        detailRow(title: "Schedule", value: scheduleText)
                        
                        detailRow(
                            title: "Take with food",
                            value: medication.takeWithFood ? "Yes" : "No",
                            icon: medication.takeWithFood ? "fork.knife" : "xmark.circle",
                            color: medication.takeWithFood ? .orange : .red
                        )
                        
                        if let notes = medication.notes {
                            detailRow(title: "Notes", value: notes)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    
                    // Fasting compatibility
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Fasting Compatibility")
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                        
                        if medication.takeWithFood {
                            compatibilityWarning(
                                icon: "exclamationmark.triangle.fill",
                                title: "Take During Eating Window",
                                message: "This medication should be taken with food during your eating window.",
                                color: .orange
                            )
                        } else {
                            compatibilityWarning(
                                icon: "checkmark.circle.fill",
                                title: "Compatible with Fasting",
                                message: "This medication can be taken during your fasting window.",
                                color: .green
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    
                    // Action buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            // Edit medication
                        }) {
                            VStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 30))
                                Text("Edit")
                                    .font(.system(size: userSettings.textSize.size))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // Delete medication
                        }) {
                            VStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 30))
                                Text("Delete")
                                    .font(.system(size: userSettings.textSize.size))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Medication Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    // Helper for detail rows
    private func detailRow(title: String, value: String, icon: String? = nil, color: Color? = nil) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
            
            HStack {
                if let icon = icon, let color = color {
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
                
                Text(value)
                    .font(.system(size: userSettings.textSize.size))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
    }
    
    // Helper for compatibility warnings
    private func compatibilityWarning(icon: String, title: String, message: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(color)
                
                Text(message)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Computed property for formatted schedule
    private var scheduleText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        if medication.schedule.count == 1, let time = medication.schedule.first {
            return formatter.string(from: time)
        } else {
            return medication.schedule.map { formatter.string(from: $0) }.joined(separator: ", ")
        }
    }
}

struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
            .environmentObject(UserSettings())
    }
} 