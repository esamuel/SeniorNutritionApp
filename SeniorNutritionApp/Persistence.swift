//
//  Persistence.swift
//  SeniorNutritionApp
//
//  Created by Samuel Eskenasy on 4/22/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Add preview data for blood pressure
        let bp = BloodPressureEntry(context: viewContext)
        bp.id = UUID()
        bp.systolic = 120
        bp.diastolic = 80
        bp.date = Date()
        
        // Add preview data for blood sugar
        let bs = BloodSugarEntry(context: viewContext)
        bs.id = UUID()
        bs.glucose = 100.0
        bs.date = Date()
        
        // Add preview data for heart rate
        let hr = HeartRateEntry(context: viewContext)
        hr.id = UUID()
        hr.bpm = 72
        hr.date = Date()
        
        // Add preview data for weight
        let weight = WeightEntry(context: viewContext)
        weight.id = UUID()
        weight.weight = 70.5
        weight.date = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SeniorNutritionApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Convenience Methods
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
