import SwiftUI

// Common pill shapes used throughout the app
struct PillDiamondShape: Shape {
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

struct PillTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

// Enhanced 3D version of pill shapes
struct Pill3DView: View {
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
                PillDiamondShape()
                    .fill(color)
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
            
        case .triangle:
            ZStack {
                // Pill body
                PillTriangleShape()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    // Inner shadow for 3D effect
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: -2, y: -2)
                    // Outer shadow
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                
                // Top highlight for 3D effect
                PillTriangleShape()
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