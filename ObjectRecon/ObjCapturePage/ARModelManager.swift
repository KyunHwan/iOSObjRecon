//
//  ARModelPresentationViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI
import RealityKit

class ARModelManager: ObservableObject {
    let arView: ARView
    let model: ModelEntity?
    let anchor: AnchorEntity
    
    let referenceOrientation: simd_quatf
    @Published private(set) var initialModelOrientation: simd_quatf
    
    init() {
        arView = ARView(frame: .zero, cameraMode: ARView.CameraMode.nonAR, automaticallyConfigureSession: true)
        model = try? Entity.loadModel(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: InitialModelConfiguration.modelFileName,
                                                                                        ofType: InitialModelConfiguration.modelFileType)!))
        anchor = AnchorEntity(.camera)
        initialModelOrientation = simd_quatf()
        referenceOrientation = InitialModelConfiguration.referenceOrientation
    }
    
    func initConfigureModel() {
        anchor.children.append(model!)
        
        model?.position = InitialModelConfiguration.modelInitPosition
        model?.scale = SIMD3<Float>(InitialModelConfiguration.modelScale,
                                    InitialModelConfiguration.modelScale,
                                    InitialModelConfiguration.modelScale)
        model?.orientation = InitialModelConfiguration.referenceOrientation
        
        arView.scene.anchors.append(anchor)
        arView.environment.background = ARView.Environment.Background.color(UIColor.clear)
    }
    
    func resetInitialOrientation(using deviceOrientation: simd_quatf) {
        initialModelOrientation = deviceOrientation
    }
    
    /// (self.initialOrientation * deviceOrientation.inverse) calculates the relative rotation with respect to the referenceOrientation
    func modelOrientation(using deviceOrientation: simd_quatf) -> simd_quatf {
        deviceOrientation.inverse.normalized * initialModelOrientation.normalized * referenceOrientation
    }

    func relativeZOrientation(using deviceOrientation: simd_quatf) -> Float {
        return RollFromQuaternion(from: deviceOrientation.inverse.normalized * initialModelOrientation.normalized)
    }
    func relativeXOrientation(using deviceOrientation: simd_quatf) -> Float {
        return YawFromQuaternion(from: deviceOrientation.inverse.normalized * initialModelOrientation.normalized)
    }
}


// MARK: Helpers
extension ARModelManager {
    private func RollFromQuaternion(from quaternion: simd_quatf) -> Float {
            let w = quaternion.real
            let x = quaternion.imag.x
            let y = quaternion.imag.y
            let z = quaternion.imag.z

            let sinp = 2.0 * (w * y - z * x)
            var pitch: Float

            // Ensure sinp is within the range [-1, 1] for asin
            if abs(sinp) >= 1 {
                pitch = copysign(Float.pi / 2, sinp) // use 90 degrees if out of range
            } else {
                pitch = asin(sinp)
            }

            // Convert the pitch from radians to degrees if needed
            let pitchInDegrees = 90 + -pitch * 180.0 / .pi

            return pitchInDegrees
    }

    private func YawFromQuaternion(from quaternion: simd_quatf) -> Float {
        let w = quaternion.real
        let x = quaternion.imag.x
        let y = quaternion.imag.y
        let z = quaternion.imag.z

        let roll = atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))

        // Convert the roll from radians to degrees if needed
        let rollInDegrees = 90 + roll * 180.0 / .pi

        return rollInDegrees
    }
    
    private struct InitialModelConfiguration {
        static let modelFileName: String = "captureObj"
        static let modelFileType: String = "usdz"
        static let modelScale: Float = 2.5
        static let modelInitPosition: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, -5)
        static let referenceOrientation: simd_quatf = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1.0, 0.0, 0.0)).normalized *
                                                      simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(0.0, 0.0, 1.0)).normalized
    }
}
