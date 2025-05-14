import SwiftUI

/// A view to demonstrate enhanced 3D pill shapes and colors
struct Enhanced3DPillPreview: View {
    // Pharmaceutical-inspired color palette
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
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedColor: Color = Color(red: 0.35, green: 0.55, blue: 0.85) // Default blue
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    pillTitle("Enhanced 3D Pill Shapes")
                    pillShapesGrid
                    
                    pillTitle("Medication Color Palette")
                    colorPaletteGrid
                    
                    VStack(alignment: .leading, spacing: 10) {
                        pillTitle("Two-Tone Capsules")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                twoToneCapsule(color1: .red, color2: .blue)
                                twoToneCapsule(color1: .orange, color2: .green)
                                twoToneCapsule(color1: .yellow, color2: .purple)
                                twoToneCapsule(color1: .pink, color2: .mint)
                                twoToneCapsule(color1: .white, color2: .blue)
                                twoToneCapsule(color1: .gray, color2: .red)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        pillTitle("Score Lines")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                scoredTablet(scoreCount: 1, color: .white)
                                scoredTablet(scoreCount: 2, color: .yellow)
                                scoredTablet(scoreCount: 3, color: .blue)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    pillTitle("Implementation Notes")
                    implementationNotes
                }
                .padding(.vertical)
            }
            .navigationTitle(NSLocalizedString("Enhanced Medication Visuals", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func pillTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
    }
    
    private var pillShapesGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                pillCard(name: "Round Tablet") {
                    Enhanced3DPill(shape: .round, color: selectedColor)
                }
                
                pillCard(name: "Oval Tablet") {
                    Enhanced3DPill(shape: .oval, color: selectedColor)
                }
                
                pillCard(name: "Capsule") {
                    Enhanced3DPill(shape: .capsule, color: selectedColor)
                }
                
                pillCard(name: "Rectangle") {
                    Enhanced3DPill(shape: .rectangle, color: selectedColor)
                }
                
                pillCard(name: "Diamond") {
                    Enhanced3DPill(shape: .diamond, color: selectedColor)
                }
                
                pillCard(name: "Triangle") {
                    Enhanced3DPill(shape: .triangle, color: selectedColor)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var colorPaletteGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(medicationColors, id: \.name) { colorInfo in
                    colorCard(name: colorInfo.name, color: colorInfo.color)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var implementationNotes: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("These enhanced 3D pill designs use:")
                .font(.subheadline)
                .padding(.horizontal)
            
            Text("• Shadow effects for depth")
                .font(.caption)
                .padding(.horizontal)
            
            Text("• Gradient overlays for highlights")
                .font(.caption)
                .padding(.horizontal)
            
            Text("• Realistic color palette based on real medications")
                .font(.caption)
                .padding(.horizontal)
            
            Text("• Multi-color options for capsules")
                .font(.caption)
                .padding(.horizontal)
            
            Text("• Score line details for tablets")
                .font(.caption)
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
        Button(action: {
            selectedColor = color
        }) {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(width: 80, height: 100)
                    
                    // Pill representation
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                    
                    if color == selectedColor {
                        Circle()
                            .strokeBorder(Color.blue, lineWidth: 3)
                            .frame(width: 60, height: 60)
                    }
                }
                
                Text(name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
            }
        }
    }
    
    private func twoToneCapsule(color1: Color, color2: Color) -> some View {
        ZStack {
            // Left half
            Capsule()
                .fill(color1)
                .frame(width: 100, height: 40)
                
            // Right half
            Capsule()
                .fill(color2)
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
    
    private func scoredTablet(scoreCount: Int, color: Color) -> some View {
        ZStack {
            // Pill body
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 90, height: 60)
                // Inner shadow for 3D effect
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                // Outer shadow
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
            
            // Score lines
            VStack(spacing: 10) {
                ForEach(0..<scoreCount, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 70, height: 2)
                }
            }
            
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
}

/// A reusable 3D pill shape component
struct Enhanced3DPill: View {
    enum PillShape {
        case round, oval, capsule, rectangle, diamond, triangle
    }
    
    let shape: PillShape
    let color: Color
    
    var body: some View {
        switch shape {
        case .round:
            ZStack {
                // Pill body
                Circle()
                    .fill(color)
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
            
        case .oval:
            ZStack {
                // Pill body
                Capsule()
                    .fill(color)
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
            
        case .capsule:
            ZStack {
                // Pill body
                Capsule()
                    .fill(color)
                    .frame(width: 100, height: 40)
                    // Inner shadow for 3D effect
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                    // Outer shadow
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                
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
                    .frame(width: 98, height: 38)
            }
            
        case .rectangle:
            ZStack {
                // Pill body
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 90, height: 60)
                    // Inner shadow for 3D effect
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                    // Outer shadow
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                
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
            
        case .diamond:
            ZStack {
                // Pill body
                Enhanced3DDiamondShape()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    // Inner shadow for 3D effect
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                    // Outer shadow
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                
                // Top highlight for 3D effect
                Enhanced3DDiamondShape()
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
            
        case .triangle:
            ZStack {
                // Pill body
                Enhanced3DTriangleShape()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    // Inner shadow for 3D effect
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                    // Outer shadow
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                
                // Top highlight for 3D effect
                Enhanced3DTriangleShape()
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
}

struct Enhanced3DDiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        
        return path
    }
}

struct Enhanced3DTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct Enhanced3DPillPreview_Previews: PreviewProvider {
    static var previews: some View {
        Enhanced3DPillPreview()
    }
} 