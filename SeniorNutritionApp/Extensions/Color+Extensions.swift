import SwiftUI
import UIKit

extension Color {
    /// Convert Color to hex string for comparison (returns non-optional String)
    func toHexString() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "#%02X%02X%02X",
                     Int(red * 255),
                     Int(green * 255),
                     Int(blue * 255))
    }
    
    /// Determine if a color is bright or dark for contrast
    func isBright() -> Bool {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate perceived brightness using the formula
        // (0.299*R + 0.587*G + 0.114*B)
        let brightness = (0.299 * red + 0.587 * green + 0.114 * blue)
        
        return brightness > 0.6
    }
}