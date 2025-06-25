import Foundation
import SwiftUI

// MARK: - Medication Models

struct NextMedicationDose: Identifiable {
    let medication: Medication
    let nextDose: Date
    var id: UUID { medication.id }
}

// The isDue method is already implemented in the Medication struct in Models.swift
// No need to redefine it here 