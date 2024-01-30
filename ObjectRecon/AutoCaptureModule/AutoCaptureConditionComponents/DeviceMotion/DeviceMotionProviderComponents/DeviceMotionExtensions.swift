//
//  DeviceMotionExtensions.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import Foundation
import CoreMotion
import RealityKit

extension simd_quatf {
    init(_ cmq: CMQuaternion) {
        self.init(ix: Float(cmq.x), iy: Float(cmq.y), iz: Float(cmq.z), r: Float(cmq.w))
    }
}

extension CMAcceleration {
    init(_ val: Double) {
        self.init(x: val, y: val, z: val)
    }
}

func + (lhs: CMAcceleration, rhs: CMAcceleration) -> CMAcceleration {
    var sum = CMAcceleration()
    sum.x = lhs.x + rhs.x
    sum.y = lhs.y + rhs.y
    sum.z = lhs.z + rhs.z
    return sum
}

func - (lhs: CMAcceleration, rhs: CMAcceleration) -> CMAcceleration {
    var sub = CMAcceleration()
    sub.x = lhs.x - rhs.x
    sub.y = lhs.y - rhs.y
    sub.z = lhs.z - rhs.z
    return sub
}

func * (lhs: CMAcceleration, rhs: CMAcceleration) -> CMAcceleration {
    var mul = CMAcceleration()
    mul.x = lhs.x * rhs.x
    mul.y = lhs.y * rhs.y
    mul.z = lhs.z * rhs.z
    return mul
}

func * (lhs: CMAcceleration, rhs: Double) -> CMAcceleration {
    var mul = CMAcceleration()
    mul.x = lhs.x * rhs
    mul.y = lhs.y * rhs
    mul.z = lhs.z * rhs
    return mul
}

func / (lhs: CMAcceleration, rhs: CMAcceleration) -> CMAcceleration {
    var div = CMAcceleration()
    div.x = lhs.x / rhs.x
    div.y = lhs.y / rhs.y
    div.z = lhs.z / rhs.z
    return div
}
                                   
func / (lhs: CMAcceleration, rhs: Double) -> CMAcceleration {
   var div = CMAcceleration()
   div.x = lhs.x / rhs
   div.y = lhs.y / rhs
   div.z = lhs.z / rhs
   return div
}
