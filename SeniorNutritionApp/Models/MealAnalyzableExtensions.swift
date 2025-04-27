import Foundation
import SwiftUI

// MARK: - MealAnalyzable Conformance
extension Meal: MealAnalyzable {
    // We need to expose the adjustedNutritionalInfo computed property
    // as the NutritionalInfoProvider required by the protocol
    var nutritionalContent: NutritionalInfoProvider {
        return adjustedNutritionalInfo
    }
}

// MARK: - NutritionalInfoProvider Conformance
extension NutritionalInfo: NutritionalInfoProvider {} 