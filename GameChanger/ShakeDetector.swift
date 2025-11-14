import SwiftUI
import Combine
import UIKit
import CoreMotion

final class ShakeManager: ObservableObject {
    static let shared = ShakeManager()
    let shakePublisher = PassthroughSubject<Void, Never>()
    private init() {}
    
    func deviceShaken() {
        shakePublisher.send(())
    }
}

final class CoreMotionShakeDetector{
    private let motionManager = CMMotionManager()
    private let shakeThreshold: Double = 2.5
    private let updateInterval: TimeInterval = 0.01
    private var lastAcceleration: CMAcceleration?
    private var isShaking = false
    private var cooldownDuration: TimeInterval = 1.5
    
    init()
    {if motionManager.isAccelerometerAvailable {
        motionManager.accelerometerUpdateInterval = updateInterval
        startDetection()
    }
    }
    private func startDetection() {
        guard !motionManager.isAccelerometerActive else { return }
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let acceleration = data?.acceleration else { return }
            
            if self .isShaking{return}
            
            if let lastAccel = self.lastAcceleration {
                let deltaX = abs(lastAccel.x - acceleration.x)
                let deltaY = abs(lastAccel.y - acceleration.y)
                let deltaZ = abs(lastAccel.z - acceleration.z)
                
                let totalDelta = deltaX + deltaY + deltaZ
                if totalDelta > self.shakeThreshold {
                    self .isShaking = true
                    ShakeManager.shared.deviceShaken()
                    //self.stopDetection()
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.cooldownDuration)
                    {self.isShaking = false
                        
                    }
                }
                
            }
            self.lastAcceleration = acceleration
        }
    }
    private func stopDetection() {
        motionManager.stopAccelerometerUpdates()
        self.lastAcceleration = nil
        self.isShaking = false
    }
    deinit {
        stopDetection()
    }
}
final class ShakeDetectorPersistentWrapper: ObservableObject {
    let detector = CoreMotionShakeDetector()
}

struct ShakeViewModifier: ViewModifier {
    let action: () -> Void
    @StateObject private var shakeManager: ShakeManager = .shared
    @StateObject private var detectorWrapper = ShakeDetectorPersistentWrapper()
    
    func body(content: Content) -> some View {
        content.onReceive(shakeManager.shakePublisher) { _ in
            action()
        }
    }
}
extension View { func onShake (perform action: @escaping () -> Void) -> some View {modifier(ShakeViewModifier(action: action))}}
