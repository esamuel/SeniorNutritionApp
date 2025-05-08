import SwiftUI
import UIKit

// Renamed to avoid conflict with Enhanced3DPillPreview in Enhanced3DPillView.swift
struct ClassicPillPreview: View {
    // Sample medication colors with pharmaceutical-inspired names
    let medicationColors: [(name: String, color: Color)] = [
        ("White", Color(red: 0.98, green: 0.98, blue: 0.98)),
        ("Cream", Color(red: 0.96, green: 0.93, blue: 0.86)),
        ("Yellow", Color(red: 0.97, green: 0.85, blue: 0.3)),
        ("Orange", Color(red: 0.98, green: 0.6, blue: 0.3)),
        ("Pink", Color(red: 0.99, green: 0.75, blue: 0.8)),
        ("Red", Color(red: 0.95, green: 0.3, blue: 0.25)),
        ("Purple", Color(red: 0.6, green: 0.4, blue: 0.8)),
        ("Blue", Color(red: 0.35, green: 0.55, blue: 0.85)),
        ("Light Blue", Color(red: 0.7, green: 0.85, blue: 0.98)),
        ("Mint", Color(red: 0.75, green: 0.95, blue: 0.8)),
        ("Green", Color(red: 0.3, green: 0.75, blue: 0.4)),
        ("Brown", Color(red: 0.65, green: 0.45, blue: 0.25)),
        ("Gray", Color(red: 0.75, green: 0.75, blue: 0.75)),
        ("Black", Color(red: 0.25, green: 0.25, blue: 0.25))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("3D Pill Shape Options")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    pillShapesPreview
                    
                    Text("Medication Color Options")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    colorPalettePreview
                }
                .padding(.vertical)
            }
            .navigationTitle("Classic Medication Visuals")
        }
    }
    
    private var pillShapesPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // Round tablet
                pillCard(name: "Round Tablet") {
                    ZStack {
                        // Pill body
                        Circle()
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            // Inner shadow for 3D effect
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                            // Outer shadow
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                        
                        // Top highlight for 3D effect
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0)]),
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 70
                            ))
                            .frame(width: 80, height: 80)
                    }
                }
                
                // Oval tablet
                pillCard(name: "Oval Tablet") {
                    ZStack {
                        // Pill body
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 100, height: 60)
                            // Inner shadow for 3D effect
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                            // Outer shadow
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                        
                        // Top highlight for 3D effect
                        Capsule()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0)]),
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 80
                            ))
                            .frame(width: 100, height: 60)
                    }
                }
                
                // Capsule
                pillCard(name: "Capsule") {
                    ZStack {
                        // Left half
                        Capsule()
                            .fill(Color.red)
                            .frame(width: 100, height: 40)
                            
                        // Right half
                        Capsule()
                            .fill(Color.blue)
                            .frame(width: 50, height: 40)
                            .offset(x: 25)
                            .mask(
                                Rectangle()
                                    .frame(width: 100, height: 40)
                                    .offset(x: 25)
                            )
                        
                        // Shading and highlights
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0.5), location: 0),
                                    .init(color: Color.white.opacity(0), location: 0.6)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 98, height: 38)
                            
                        // Outer shadow
                        Capsule()
                            .fill(Color.clear)
                            .frame(width: 100, height: 40)
                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 2, y: 2)
                    }
                }
                
                // Rectangle tablet with score line
                pillCard(name: "Scored Tablet") {
                    ZStack {
                        // Pill body
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.98, green: 0.9, blue: 0.4))
                            .frame(width: 90, height: 60)
                            // Inner shadow for 3D effect
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                            // Outer shadow
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                        
                        // Score line
                        Rectangle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 70, height: 2)
                        
                        // Top highlight for 3D effect
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0.6), location: 0),
                                    .init(color: Color.white.opacity(0), location: 0.6)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 88, height: 58)
                    }
                }
                
                // Diamond-shaped tablet
                pillCard(name: "Diamond Tablet") {
                    ZStack {
                        // Pill body
                        PillDiamondShape()
                            .fill(Color(red: 0.3, green: 0.8, blue: 0.6))
                            .frame(width: 70, height: 70)
                            // Inner shadow for 3D effect
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                            // Outer shadow
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                        
                        // Top highlight for 3D effect
                        PillDiamondShape()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0.6), location: 0),
                                    .init(color: Color.white.opacity(0), location: 0.6)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 68, height: 68)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var colorPalettePreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(medicationColors, id: \.name) { colorInfo in
                    colorCard(name: colorInfo.name, color: colorInfo.color)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func pillCard(name: String, @ViewBuilder content: () -> some View) -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 120, height: 120)
                
                content()
            }
            
            Text(name)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(width: 100)
        }
    }
    
    private func colorCard(name: String, color: Color) -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 80, height: 100)
                
                // Pill representation
                ZStack {
                    Capsule()
                        .fill(color)
                        .frame(width: 60, height: 40)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                    
                    // Top highlight for 3D effect
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white.opacity(0.6), location: 0),
                                .init(color: Color.white.opacity(0), location: 0.6)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 58, height: 38)
                }
            }
            
            Text(name)
                .font(.caption)
                .foregroundColor(.primary)
                .padding(.top, 4)
        }
    }
}

// Rename the preview provider as well
struct ClassicPillPreview_Previews: PreviewProvider {
    static var previews: some View {
        ClassicPillPreview()
    }
} 