//
//  AutoCaptureModule.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import Foundation
import Combine

class AutoCaptureManager: ObservableObject {
    // MARK: Camera
    private let captureSession: CaptureSession
    private let directoryManager: DirectoryManager
    private var photoCaptureMode: PhotoCaptureMode
    private var timer: AnyCancellable?
    var lensPosition: Float { captureSession.inputCamera.device.lensPosition }
    
    // MARK: MLDetector
    private let detector: MLDetector
    var detected: Bool { detector.detected }
    
    // MARK: DeviceMotion
    private let deviceMotion: DeviceMotionProvider
    var accelMag: Double {deviceMotion.accelMag}
    
    init() {
        captureSession = CaptureSession()
        deviceMotion = DeviceMotionProvider()
        detector = MLDetector()
        
        self.directoryManager = DirectoryManager(filePrefixInDirectory: "IMG_", fileSuffixInDirectory: ".JPG")
        self.photoCaptureMode = .auto
        self.timer = nil
    }
    
    @MainActor
    func captureFrame() {
        switch photoCaptureMode {
        case .manual:
            photoCapture()
        case .auto:
            autoPhotoCapture()
        }
    }
    
    private enum PhotoCaptureMode: String {
        case manual
        case auto
    }
}

// MARK: Automatic Photo Capture
extension AutoCaptureManager {
    @MainActor
    private func autoPhotoCapture() {
        if let _ = self.timer { stopAutoPhotoCapture() }
        else { startAutoPhotoCapture() }
    }
    
    @MainActor
    private func startAutoPhotoCapture() {
        directoryManager.createNewDirectory()
        self.timer = Timer.publish(every: AutoCaptureConstants.updateEverySecs, on: .main, in: .common)
                                .autoconnect()
                                .sink(receiveValue: { _ in self.conditionsCheckedPhotoCapture() })
    }
    
    @MainActor
    private func stopAutoPhotoCapture() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    private struct AutoCaptureConstants {
        static let updateEverySecs: Double = 0.25
    }
}

// MARK: Condition-checked Photo Capture
extension AutoCaptureManager {
    @MainActor
    private func conditionsCheckedPhotoCapture() {
        if checkConditions() { photoCapture() }
    }
    
    private func checkConditions() -> Bool {
        lensPosConditionSatisfied() &&
        accelMagConditionSatisfied() &&
        detectionConditionSatisfied()
    }
    
    /// Lens Position Condition Checker
    private func lensPosConditionSatisfied() -> Bool {
        
    }
    
    /// Acceleration Magnitude Condition Checker
    private func accelMagConditionSatisfied() -> Bool {
        
    }
    
    /// Detection Condition Checker
    private func detectionConditionSatisfied() -> Bool {
        
    }
    
    private struct PhotoCaptureConditions {
        static let lensPosThreshold: Float = 0.6
        static let accelMagThreshold: Double = 0.6
        static let detectionConfidence: Double = 0.5
    }
}

// MARK: Photo Capture
extension AutoCaptureManager {
    @MainActor
    private func photoCapture() {
        directoryManager.checkCreateNewDirectory()
        captureSession.captureFrame(with: directoryManager)
    }
}
