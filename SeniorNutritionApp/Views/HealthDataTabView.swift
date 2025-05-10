import SwiftUI
import CoreData

struct HealthDataTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: BloodPressureEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BloodPressureEntry.date, ascending: false)],
        animation: .default)
    private var bpEntries: FetchedResults<BloodPressureEntry>
    
    @FetchRequest(
        entity: BloodSugarEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BloodSugarEntry.date, ascending: false)],
        animation: .default)
    private var bsEntries: FetchedResults<BloodSugarEntry>
    
    @FetchRequest(
        entity: HeartRateEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \HeartRateEntry.date, ascending: false)],
        animation: .default)
    private var hrEntries: FetchedResults<HeartRateEntry>
    
    @FetchRequest(
        entity: WeightEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)],
        animation: .default)
    private var weightEntries: FetchedResults<WeightEntry>
    
    @State private var showingAddBP = false
    @State private var bpEntryToEdit: BloodPressureEntry?
    
    @State private var showingAddBS = false
    @State private var bsEntryToEdit: BloodSugarEntry?
    
    @State private var showingAddHR = false
    @State private var hrEntryToEdit: HeartRateEntry?
    
    @State private var showingAddWeight = false
    @State private var weightEntryToEdit: WeightEntry?
    
    @State private var systolic = ""
    @FocusState private var systolicFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Blood Pressure Card
                    NavigationLink(destination: BloodPressureDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "heart.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.red).frame(width: 56, height: 56))
                                Text("Blood Pressure")
                                    .font(.title2).bold()
                                    .foregroundColor(.red)
                                Spacer()
                                Button(action: { 
                                    showingAddBP = true 
                                }) {
                                    Label("Add", systemImage: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.red)
                                }
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                            
                            // Only show the most recent entry or a message if none
                            if let latestEntry = bpEntries.first {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(latestEntry.systolic)/\(latestEntry.diastolic) mmHg")
                                            .font(.title3).bold()
                                            .foregroundColor(.primary)
                                        Text(latestEntry.date ?? Date(), formatter: dateFormatter)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        bpEntryToEdit = latestEntry
                                    }) {
                                        Image(systemName: "pencil.circle")
                                            .font(.title3)
                                            .foregroundColor(.secondary)
                                    }
                                    .contentShape(Rectangle())
                                    .background(Color.clear)
                                }
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                            } else {
                                Text("No entries yet. Tap + to add your first reading.")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text("Tap to view history and charts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                        }
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(18)
                        .shadow(radius: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingAddBP) {
                        AddBloodPressureView()
                            .environment(\.managedObjectContext, viewContext)
                    }
                    .sheet(item: $bpEntryToEdit) { entry in
                        EditBloodPressureView(entry: entry)
                            .environment(\.managedObjectContext, viewContext)
                    }
                    
                    // Blood Sugar Card
                    NavigationLink(destination: BloodSugarDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "drop.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.orange).frame(width: 56, height: 56))
                                Text("Blood Sugar")
                                    .font(.title2).bold()
                                    .foregroundColor(.orange)
                                Spacer()
                                Button(action: { 
                                    showingAddBS = true 
                                }) {
                                    Label("Add", systemImage: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.orange)
                                }
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                            
                            // Only show the most recent entry or a message if none
                            if let latestEntry = bsEntries.first {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(Int(latestEntry.glucose)) mg/dL")
                                            .font(.title3).bold()
                                            .foregroundColor(.primary)
                                        Text(latestEntry.date ?? Date(), formatter: dateFormatter)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        bsEntryToEdit = latestEntry
                                    }) {
                                        Image(systemName: "pencil.circle")
                                            .font(.title3)
                                            .foregroundColor(.secondary)
                                    }
                                    .contentShape(Rectangle())
                                    .background(Color.clear)
                                }
                                .padding()
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(10)
                            } else {
                                Text("No entries yet. Tap + to add your first reading.")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text("Tap to view history and charts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(18)
                        .shadow(radius: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingAddBS) {
                        AddBloodSugarView()
                            .environment(\.managedObjectContext, viewContext)
                    }
                    .sheet(item: $bsEntryToEdit) { entry in
                        EditBloodSugarView(entry: entry)
                            .environment(\.managedObjectContext, viewContext)
                    }
                    
                    // Heart Rate Card
                    NavigationLink(destination: HeartRateDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "waveform.path.ecg")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.blue).frame(width: 56, height: 56))
                                Text("Heart Rate")
                                    .font(.title2).bold()
                                    .foregroundColor(.blue)
                                Spacer()
                                Button(action: { 
                                    showingAddHR = true 
                                }) {
                                    Label("Add", systemImage: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.blue)
                                }
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                            
                            // Only show the most recent entry or a message if none
                            if let latestEntry = hrEntries.first {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(latestEntry.bpm) BPM")
                                            .font(.title3).bold()
                                            .foregroundColor(.primary)
                                        Text(latestEntry.date ?? Date(), formatter: dateFormatter)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        hrEntryToEdit = latestEntry
                                    }) {
                                        Image(systemName: "pencil.circle")
                                            .font(.title3)
                                            .foregroundColor(.secondary)
                                    }
                                    .contentShape(Rectangle())
                                    .background(Color.clear)
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            } else {
                                Text("No entries yet. Tap + to add your first reading.")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text("Tap to view history and charts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(18)
                        .shadow(radius: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingAddHR) {
                        AddHeartRateView()
                            .environment(\.managedObjectContext, viewContext)
                    }
                    .sheet(item: $hrEntryToEdit) { entry in
                        EditHeartRateView(entry: entry)
                            .environment(\.managedObjectContext, viewContext)
                    }
                    
                    // Weight Card
                    NavigationLink(destination: WeightDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "scalemass.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.green).frame(width: 56, height: 56))
                                Text("Weight")
                                    .font(.title2).bold()
                                    .foregroundColor(.green)
                                Spacer()
                                Button(action: { 
                                    showingAddWeight = true 
                                }) {
                                    Label("Add", systemImage: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.green)
                                }
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                            
                            // Only show the most recent entry or a message if none
                            if let latestEntry = weightEntries.first {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(String(format: "%.1f kg", latestEntry.weight))
                                            .font(.title3).bold()
                                            .foregroundColor(.primary)
                                        Text(latestEntry.date ?? Date(), formatter: dateFormatter)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        weightEntryToEdit = latestEntry
                                    }) {
                                        Image(systemName: "pencil.circle")
                                            .font(.title3)
                                            .foregroundColor(.secondary)
                                    }
                                    .contentShape(Rectangle())
                                    .background(Color.clear)
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(10)
                            } else {
                                Text("No entries yet. Tap + to add your first reading.")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text("Tap to view history and charts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                        }
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(18)
                        .shadow(radius: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingAddWeight) {
                        AddWeightView()
                            .environment(\.managedObjectContext, viewContext)
                    }
                    .sheet(item: $weightEntryToEdit) { entry in
                        EditWeightView(entry: entry)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
                .padding()
            }
            .navigationTitle("Health")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct AddBloodPressureView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var systolic = ""
    @State private var diastolic = ""
    @State private var error: String?
    @FocusState private var systolicFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Blood Pressure")) {
                    TextField("Systolic (top)", text: $systolic)
                        .keyboardType(.numberPad)
                        .focused($systolicFieldIsFocused)
                    TextField("Diastolic (bottom)", text: $diastolic)
                        .keyboardType(.numberPad)
                }
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add Blood Pressure")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.systolicFieldIsFocused = true
            }
        }
    }
    
    private func saveEntry() {
        guard let sys = Int32(systolic), let dia = Int32(diastolic), sys > 0, dia > 0 else {
            error = "Please enter valid numbers."
            return
        }
        let entry = BloodPressureEntry(context: viewContext)
        entry.id = UUID()
        entry.systolic = sys
        entry.diastolic = dia
        entry.date = Date()
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = "Failed to save. Try again."
        }
    }
}

#Preview {
    HealthDataTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 