//
//  ObjCaptureViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import Foundation
import AVFoundation
import RealityKit

class ObjCaptureViewModel: ObservableObject {
    private let autoCaptureManager: AutoCaptureManager
    var session: AVCaptureSession { autoCaptureManager.session }
    @Published var cameraCloseEnough: Bool
    @Published var objDetected: Bool
    @Published var motionSlowEnough: Bool
    @Published var deviceOrientation: simd_quatf
    
    init() {
        autoCaptureManager = AutoCaptureManager()
        cameraCloseEnough = autoCaptureManager.cameraCloseEnough
        objDetected = autoCaptureManager.objDetected
        motionSlowEnough = autoCaptureManager.motionSlowEnough
        deviceOrientation = autoCaptureManager.deviceOrientation
    }
}

// MARK: Auto Capture Session
extension ObjCaptureViewModel {
    func startAutoSession() {
        autoCaptureManager.startSession()
    }
    
    func stopAutoSession() {
        autoCaptureManager.stopSession()
    }
    
    @MainActor
    func captureFrame() {
        autoCaptureManager.captureFrame()
    }
}


// MARK: MLDetector
extension ObjCaptureViewModel {
    func startDetection(with layer: CALayer) {
        autoCaptureManager.startDetection(with: layer)
    }
}
