//
//  DeviceAcceleration.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import Foundation
import CoreMotion

// MARK: Acceleration
extension DeviceMotionProvider {
    // Calculating acceleration magnitude in m/s^2
    func magnitude(of val: CMAcceleration) -> Double {
        DeviceMotionAccelConstants.motionDataAccelConverter *
        pow(pow(val.x,2) +
            pow(val.y,2) +
            pow(val.z,2),0.5)
    }
    
    private struct DeviceMotionAccelConstants {
        static let motionDataAccelConverter = 9.81
    }
}
