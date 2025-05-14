import Foundation

extension String {
    var localized: String {
        let localized = NSLocalizedString(self, comment: "")
        
        // If the localized string is the same as the key, it means the string wasn't found
        // in the current language's Localizable.strings. In this case, try to fall back to the
        // base language or English.
        if localized == self {
            // Try to get the string from the Base.lproj bundle first
            if let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj"),
               let baseBundle = Bundle(path: basePath) {
                let baseString = baseBundle.localizedString(forKey: self, value: nil, table: nil)
                if baseString != self {
                    return baseString
                }
            }
            
            // If not found in Base, try English as a last resort
            if let enPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
               let enBundle = Bundle(path: enPath) {
                let enString = enBundle.localizedString(forKey: self, value: nil, table: nil)
                if enString != self {
                    return enString
                }
            }
        }
        
        return localized
    }
    
    // Localize with format arguments
    func localized(_ args: CVarArg...) -> String {
        String(format: self.localized, arguments: args)
    }
} 