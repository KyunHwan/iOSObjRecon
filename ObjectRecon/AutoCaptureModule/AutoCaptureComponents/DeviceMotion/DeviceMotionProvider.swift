//
//  DeviceMotion.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import SwiftUI
import CoreMotion
import RealityKit

class DeviceMotionProvider: ObservableObject {
    private let motionManager: CMMotionManager
    private let motionQueue: OperationQueue
    private var accel: CMAcceleration
    
    var accelMag: Double { magnitude(of: accel) }
    
    init() {
        motionQueue = OperationQueue()
        motionManager = CMMotionManager()
        accel = CMAcceleration()
    }
    
    // to: takes in an operation queue provided by the caller.
    // Because the processed events might arrive at a high rate, using the main operation queue is not recommeded.
    func startMotionUpdate() {
        motionManager.deviceMotionUpdateInterval = MotionProviderConstants.deviceMotionUpdateInterval
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: motionQueue) { (motionData, error) in
            // A block that is invoked with each update to handle new device-motion data.
            // Process the incoming data in this closure, which will be run on the motionQueue
            guard let data = motionData, error == nil else {
                print("Could not get motion data")
                return
            }
            
            self.collectData(data)
        }
    }
    
    func stopMotionUpdate() { motionManager.stopDeviceMotionUpdates() }

    private func collectData(_ data: CMDeviceMotion) {
        /// userAcceleration is in g, not m/s^2
        self.accel = data.userAcceleration
    }
    
    private struct MotionProviderConstants {
        static let deviceMotionUpdateInterval: TimeInterval = 1/60
    }
}
