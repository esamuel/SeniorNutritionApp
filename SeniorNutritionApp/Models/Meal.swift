import Foundation
import SwiftUI

struct Meal: Identifiable, Codable {
    var id: UUID
    var name: String
    var type: MealType
    var time: Date
    var portion: MealPortion
    var nutritionalInfo: NutritionalInfo
    var notes: String?
    var imageURL: URL?
    
    // Computed property to get portion-adjusted nutritional info
    var adjustedNutritionalInfo: NutritionalInfo {
        let multiplier = portion.multiplier
        return NutritionalInfo(
            calories: nutritionalInfo.calories * multiplier,
            protein: nutritionalInfo.protein * multiplier,
            carbohydrates: nutritionalInfo.carbohydrates * multiplier,
            fat: nutritionalInfo.fat * multiplier,
            fiber: nutritionalInfo.fiber * multiplier,
            sugar: nutritionalInfo.sugar * multiplier,
            vitaminA: nutritionalInfo.vitaminA * multiplier,
            vitaminC: nutritionalInfo.vitaminC * multiplier,
            vitaminD: nutritionalInfo.vitaminD * multiplier,
            vitaminE: nutritionalInfo.vitaminE * multiplier,
            vitaminK: nutritionalInfo.vitaminK * multiplier,
            thiamin: nutritionalInfo.thiamin * multiplier,
            riboflavin: nutritionalInfo.riboflavin * multiplier,
            niacin: nutritionalInfo.niacin * multiplier,
            vitaminB6: nutritionalInfo.vitaminB6 * multiplier,
            vitaminB12: nutritionalInfo.vitaminB12 * multiplier,
            folate: nutritionalInfo.folate * multiplier,
            calcium: nutritionalInfo.calcium * multiplier,
            iron: nutritionalInfo.iron * multiplier,
            magnesium: nutritionalInfo.magnesium * multiplier,
            phosphorus: nutritionalInfo.phosphorus * multiplier,
            potassium: nutritionalInfo.potassium * multiplier,
            sodium: nutritionalInfo.sodium * multiplier,
            zinc: nutritionalInfo.zinc * multiplier,
            selenium: nutritionalInfo.selenium * multiplier,
            omega3: nutritionalInfo.omega3 * multiplier,
            omega6: nutritionalInfo.omega6 * multiplier,
            cholesterol: nutritionalInfo.cholesterol * multiplier
        )
    }
    
    // Coding keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, name, type, time, portion, nutritionalInfo, notes, imageURL
    }
    
    // Initializer with default values
    init(
        id: UUID = UUID(),
        name: String,
        type: MealType,
        time: Date = Date(),
        portion: MealPortion = .medium,
        nutritionalInfo: NutritionalInfo = NutritionalInfo(),
        notes: String? = nil,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.time = time
        self.portion = portion
        self.nutritionalInfo = nutritionalInfo
        self.notes = notes
        self.imageURL = imageURL
    }
    
    // Custom encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(time, forKey: .time)
        try container.encode(portion, forKey: .portion)
        try container.encode(nutritionalInfo, forKey: .nutritionalInfo)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
    }
    
    // Custom decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(MealType.self, forKey: .type)
        time = try container.decode(Date.self, forKey: .time)
        portion = try container.decode(MealPortion.self, forKey: .portion)
        nutritionalInfo = try container.decode(NutritionalInfo.self, forKey: .nutritionalInfo)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
    }
} 