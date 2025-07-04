import SwiftUI
import CoreData

struct HealthDataTabView: View {
    @EnvironmentObject var languageManager: LanguageManager
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
                                Text(NSLocalizedString("Blood Pressure", comment: "Title for Blood Pressure section"))
                                    .font(.title2).bold()
                                    .foregroundColor(.red)
                                Spacer()
                                Button(action: { 
                                    showingAddBP = true 
                                }) {
                                    Label(NSLocalizedString("Add", comment: "Add button text"), systemImage: "plus.circle.fill")
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
                                        Text("\(latestEntry.systolic)/\(latestEntry.diastolic) \(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))")
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
                                Text(NSLocalizedString("No entries yet. Tap + to add your first reading.", comment: "Message when no health entries exist"))
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text(NSLocalizedString("Tap to view history and charts", comment: "Instructions to view detailed health data"))
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
                        NavigationView {
                            AddBloodPressureView()
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    .sheet(item: $bpEntryToEdit) { entry in
                        NavigationView {
                            EditBloodPressureView(entry: entry)
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    
                    // Blood Sugar Card
                    NavigationLink(destination: BloodSugarDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "drop.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.orange).frame(width: 56, height: 56))
                                Text(NSLocalizedString("Blood Sugar", comment: "Title for Blood Sugar section"))
                                    .font(.title2).bold()
                                    .foregroundColor(.orange)
                                Spacer()
                                Button(action: { 
                                    showingAddBS = true 
                                }) {
                                    Label(NSLocalizedString("Add", comment: "Add button text"), systemImage: "plus.circle.fill")
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
                                        Text("\(Int(latestEntry.glucose)) \(NSLocalizedString("mg/dL", comment: "Unit for blood sugar"))")
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
                                Text(NSLocalizedString("No entries yet. Tap + to add your first reading.", comment: "Message when no health entries exist"))
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text(NSLocalizedString("Tap to view history and charts", comment: "Instructions to view detailed health data"))
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
                        NavigationView {
                            AddBloodSugarView()
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    .sheet(item: $bsEntryToEdit) { entry in
                        NavigationView {
                            EditBloodSugarView(entry: entry)
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    
                    // Heart Rate Card
                    NavigationLink(destination: HeartRateDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "waveform.path.ecg")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.blue).frame(width: 56, height: 56))
                                Text(NSLocalizedString("Heart Rate", comment: "Title for Heart Rate section"))
                                    .font(.title2).bold()
                                    .foregroundColor(.blue)
                                Spacer()
                                Button(action: { 
                                    showingAddHR = true 
                                }) {
                                    Label(NSLocalizedString("Add", comment: "Add button text"), systemImage: "plus.circle.fill")
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
                                        Text("\(latestEntry.bpm) \(NSLocalizedString("BPM", comment: "Unit for heart rate"))")
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
                                Text(NSLocalizedString("No entries yet. Tap + to add your first reading.", comment: "Message when no health entries exist"))
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text(NSLocalizedString("Tap to view history and charts", comment: "Instructions to view detailed health data"))
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
                        NavigationView {
                            AddHeartRateView()
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    .sheet(item: $hrEntryToEdit) { entry in
                        NavigationView {
                            EditHeartRateView(entry: entry)
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    
                    // Weight Card
                    NavigationLink(destination: WeightDetailView()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "scalemass.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.green).frame(width: 56, height: 56))
                                Text(NSLocalizedString("Weight", comment: "Title for Weight section"))
                                    .font(.title2).bold()
                                    .foregroundColor(.green)
                                Spacer()
                                Button(action: { 
                                    showingAddWeight = true 
                                }) {
                                    Label(NSLocalizedString("Add", comment: "Add button text"), systemImage: "plus.circle.fill")
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
                                        Text(String(format: "%.1f \(NSLocalizedString("kg", comment: "Unit for weight"))", latestEntry.weight))
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
                                Text(NSLocalizedString("No entries yet. Tap + to add your first reading.", comment: "Message when no health entries exist"))
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                            
                            Text(NSLocalizedString("Tap to view history and charts", comment: "Instructions to view detailed health data"))
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
                        NavigationView {
                            AddWeightView()
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                    .sheet(item: $weightEntryToEdit) { entry in
                        NavigationView {
                            EditWeightView(entry: entry)
                                .environment(\.managedObjectContext, viewContext)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Health", comment: "Navigation title for Health view"))
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()



#Preview {
    HealthDataTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 