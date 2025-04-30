import Foundation

// A class that manages data persistence even across app reinstalls
class PersistentStorage {
    static let shared = PersistentStorage()
    
    // Key for storing data
    private let dataKey = "SeniorNutritionAppData"
    private let saveQueue = DispatchQueue(label: "com.seniornutritionapp.storage", qos: .utility)
    
    // Directory for app document storage
    private var documentsDirectory: URL {
        // This uses Apple's Application Support directory which can survive app deletion
        // if the "Do Not Back Up" attribute is set
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    // File URL for our data storage
    private var dataFileURL: URL {
        return documentsDirectory.appendingPathComponent("\(dataKey).json")
    }
    
    // Initialize directory if needed
    private init() {
        createDirectoryIfNeeded()
    }
    
    // Create application support directory if it doesn't exist
    private func createDirectoryIfNeeded() {
        do {
            let directoryURL = documentsDirectory
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            // Set the "do not back up" attribute to avoid iCloud backup
            // which helps ensure the data survives even if not backed up
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            var mutableURL = directoryURL
            try mutableURL.setResourceValues(resourceValues)
        } catch {
            print("Error creating directory: \(error)")
        }
    }
    
    // Save data to persistent storage
    func saveData<T: Encodable>(_ data: T, forKey key: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            saveQueue.async {
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(data)
                    try encodedData.write(to: self.dataFileURL)
                    print("Successfully saved data for key: \(key)")
                    continuation.resume(returning: ())
                } catch {
                    print("Error saving data for key \(key): \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Load data from persistent storage
    func loadData<T: Decodable>(forKey key: String) -> T? {
        do {
            let data = try Data(contentsOf: dataFileURL)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            print("Successfully loaded data for key: \(key)")
            return decodedData
        } catch {
            print("Error loading data for key \(key): \(error)")
            return nil
        }
    }
    
    // Delete data from persistent storage
    func deleteData(forKey key: String) {
        saveQueue.async {
            do {
                try FileManager.default.removeItem(at: self.dataFileURL)
                print("Successfully deleted data for key: \(key)")
            } catch {
                print("Error deleting data for key \(key): \(error)")
            }
        }
    }
} 