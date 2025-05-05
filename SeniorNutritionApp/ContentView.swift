//
//  ContentView.swift
//  SeniorNutritionApp
//
//  Created by Samuel Eskenasy on 4/22/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        if userSettings.isOnboardingComplete {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
}
