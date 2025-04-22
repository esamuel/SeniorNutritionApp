import SwiftUI

enum TextSize: String, CaseIterable, Identifiable, Codable {
    case small = "Small (16pt)"
    case medium = "Medium (18pt)"
    case large = "Large (20pt)"
    case extraLarge = "Extra Large (22pt)"
    
    var id: String { self.rawValue }
    
    var size: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 18
        case .large: return 20
        case .extraLarge: return 22
        }
    }
} 