import SwiftUI

struct PillShapeView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedShape: PillShape
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Select Pill Shape")
                        .font(.headline)
                        .padding(.top)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                        ForEach(PillShape.allCases) { shape in
                            shapeButton(shape: shape)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Pill Shape", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func shapeButton(shape: PillShape) -> some View {
        Button {
            selectedShape = shape
        } label: {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .frame(height: 80)
                        .shadow(radius: 1)
                        .overlay(
                            Group {
                                switch shape {
                                case .round:
                                    Circle()
                                        .fill(Color.blue.opacity(0.7))
                                        .frame(width: 60, height: 60)
                                case .oval:
                                    Capsule()
                                        .fill(Color.blue.opacity(0.7))
                                        .frame(width: 70, height: 40)
                                case .capsule:
                                    Capsule()
                                        .fill(Color.blue.opacity(0.7))
                                        .frame(width: 80, height: 30)
                                case .rectangle:
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.blue.opacity(0.7))
                                        .frame(width: 70, height: 40)
                                case .diamond:
                                    PillDiamondShape()
                                        .fill(selectedShape == shape ? Color.blue : Color.gray.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .overlay(PillDiamondShape().stroke(Color.gray, lineWidth: 1))
                                case .triangle:
                                    PillTriangleShape()
                                        .fill(selectedShape == shape ? Color.blue : Color.gray.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .overlay(PillTriangleShape().stroke(Color.gray, lineWidth: 1))
                                case .other:
                                    Text("?")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color.blue.opacity(0.7))
                                }
                            }
                        )
                    
                    if selectedShape == shape {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                            .position(x: 80, y: 15)
                    }
                }
                
                Text(shape.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

// Custom shapes for pill visualization in PillShapeView
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

struct PillShapeView_Previews: PreviewProvider {
    static var previews: some View {
        PillShapeView(selectedShape: .constant(.capsule))
    }
}
