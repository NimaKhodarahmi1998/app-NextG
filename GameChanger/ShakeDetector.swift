import SwiftUI
import Combine
import UIKit

final class ShakeManager: ObservableObject {
    static let shared = ShakeManager()
    let shakePublisher = PassthroughSubject<Void, Never>()
    private init() {}
    
    func deviceShaken() {
        shakePublisher.send(())
    }
}

class ShakeDetectingViewController: UIViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            ShakeManager.shared.deviceShaken()
        }
    }
}

struct ShakeDetectorInjector: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        ShakeDetectingViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ShakeViewModifier: ViewModifier {
    let action: () -> Void
    @StateObject private var shakeManager: ShakeManager = .shared
    
    func body(content: Content) -> some View {
        content
            .overlay(ShakeDetectorInjector().frame(width: 0, height: 0))
            .onReceive(shakeManager.shakePublisher) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(ShakeViewModifier(action: action))
    }
}
