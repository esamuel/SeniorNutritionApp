import Foundation

struct UnitConverter {
    static let volumeUnits = ["ml", "cups", "tbsp", "tsp", "fl oz"]
    static let weightUnits = ["g", "kg", "oz", "lb"]
    static let heightUnits = ["cm", "ft", "in", "m"]
    
    static func convert(_ value: Double, from sourceUnit: String, to targetUnit: String) -> Double {
        // First convert to base unit (g or ml)
        let baseValue = toBaseUnit(value, from: sourceUnit)
        
        // Then convert from base unit to target unit
        return fromBaseUnit(baseValue, to: targetUnit)
    }
    
    static func toBaseUnit(_ value: Double, from unit: String) -> Double {
        switch unit.lowercased() {
        // Weight conversions to grams
        case "g": return value
        case "kg": return value * 1000
        case "oz": return value * 28.3495
        case "lb": return value * 453.592
        
        // Volume conversions to milliliters
        case "ml": return value
        case "cups": return value * 236.588
        case "tbsp": return value * 14.7868
        case "tsp": return value * 4.92892
        case "fl oz": return value * 29.5735
        
        // Height conversions to centimeters
        case "cm": return value
        case "m": return value * 100
        case "ft": return value * 30.48
        case "in": return value * 2.54
        
        default: return value
        }
    }
    
    static func fromBaseUnit(_ value: Double, to unit: String) -> Double {
        switch unit.lowercased() {
        // Grams to weight units
        case "g": return value
        case "kg": return value / 1000
        case "oz": return value / 28.3495
        case "lb": return value / 453.592
        
        // Milliliters to volume units
        case "ml": return value
        case "cups": return value / 236.588
        case "tbsp": return value / 14.7868
        case "tsp": return value / 4.92892
        case "fl oz": return value / 29.5735
        
        // Centimeters to height units
        case "cm": return value
        case "m": return value / 100
        case "ft": return value / 30.48
        case "in": return value / 2.54
        
        default: return value
        }
    }
    
    static func isVolumeUnit(_ unit: String) -> Bool {
        volumeUnits.contains(unit.lowercased())
    }
    
    static func isWeightUnit(_ unit: String) -> Bool {
        weightUnits.contains(unit.lowercased())
    }
    
    static func isHeightUnit(_ unit: String) -> Bool {
        heightUnits.contains(unit.lowercased())
    }
    
    static func defaultUnitFor(foodCategory: FoodCategory) -> String {
        switch foodCategory {
        case .beverages, .condiments:
            return "ml"
        default:
            return "g"
        }
    }
    
    static func suggestedUnitsFor(foodCategory: FoodCategory) -> [String] {
        switch foodCategory {
        case .beverages, .condiments:
            return volumeUnits
        default:
            return weightUnits
        }
    }
}
