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
    func saveData<T: Encodable>(_ data: T, forKey key: String) {
        saveQueue.async {
            do {
                let encoder = JSONEncoder()
                let encodedData = try encoder.encode(data)
                try encodedData.write(to: self.dataFileURL)
            } catch {
                print("Error saving data: \(error)")
            }
        }
    }
    
    // Load data from persistent storage
    func loadData<T: Decodable>(forKey key: String) -> T? {
        do {
            let data = try Data(contentsOf: dataFileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error loading data: \(error)")
            return nil
        }
    }
    
    // Remove all saved data
    func clearAllData() {
        saveQueue.async {
            do {
                if FileManager.default.fileExists(atPath: self.dataFileURL.path) {
                    try FileManager.default.removeItem(at: self.dataFileURL)
                    print("All data cleared")
                }
            } catch {
                print("Error clearing data: \(error)")
            }
        }
    }
} 