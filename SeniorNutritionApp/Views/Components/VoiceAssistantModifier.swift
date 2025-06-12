import SwiftUI

struct VoiceAssistantModifier: ViewModifier {
    @EnvironmentObject var voiceAssistant: VoiceAssistantManager
    let position: VoiceButtonPosition
    
    init(position: VoiceButtonPosition = .topTrailing) {
        self.position = position
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VoiceAssistantButton()
                .position(x: position.x, y: position.y)
                .zIndex(100) // Ensure it's above other content but can still be tapped
        }
    }
}

// Define standard positions for the voice button
struct VoiceButtonPosition {
    let x: CGFloat
    let y: CGFloat
    
    // Standard positions
    static let topTrailing = VoiceButtonPosition(x: UIScreen.main.bounds.width - 40, y: 100)
    static let bottomTrailing = VoiceButtonPosition(x: UIScreen.main.bounds.width - 40, y: UIScreen.main.bounds.height - 100)
    static let custom = { (x: CGFloat, y: CGFloat) in VoiceButtonPosition(x: x, y: y) }
}

extension View {
    func withVoiceAssistant(position: VoiceButtonPosition = .topTrailing) -> some View {
        self.modifier(VoiceAssistantModifier(position: position))
    }
}
