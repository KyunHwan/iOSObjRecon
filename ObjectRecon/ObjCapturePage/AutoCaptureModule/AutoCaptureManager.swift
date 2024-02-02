//
//  AutoCaptureModule.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import Foundation
import Combine
import AVFoundation

class AutoCaptureManager: ObservableObject {
    // MARK: Camera
    private(set) var captureSession: CaptureSession
    private let directoryManager: DirectoryManager
    private var photoCaptureMode: PhotoCaptureMode
    private var timer: AnyCancellable?
    var session: AVCaptureSession { captureSession.session }
    var cameraCloseEnough: Bool { lensPosConditionMet() }
    
    // MARK: MLDetector
    private(set) var detector: MLDetector
    var objDetected: Bool { detectionConditionMet() }
    
    // MARK: Device Motion
    private(set) var deviceMotion: DeviceMotionProvider
    var motionSlowEnough: Bool { accelMagConditionMet() }
    var deviceOrientation: simd_quatf { deviceMotion.deviceOrientation }
    
    // MARK: Auditory Capture Feedback
    private let auditoryCaptureFeedbackManager: AuditoryCaptureFeedbackManager
    
    init() {
        deviceMotion = DeviceMotionProvider()
        detector = MLDetector()
        captureSession = CaptureSession(with: detector)
        auditoryCaptureFeedbackManager = AuditoryCaptureFeedbackManager()
        
        directoryManager = DirectoryManager(filePrefixInDirectory: "IMG_", fileSuffixInDirectory: ".JPG")
        photoCaptureMode = .auto
        timer = nil
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
    
    func startSession() {
        captureSession.startRunning()
        deviceMotion.startMotionUpdate()
        auditoryCaptureFeedbackManager.prepareToPlay()
    }
    
    func stopSession() {
        captureSession.stopRunning()
        deviceMotion.stopMotionUpdate()
        auditoryCaptureFeedbackManager.stopSound()
    }
    
    func startDetection(with previewLayer: CALayer) {
        detector.initRootLayer(with: previewLayer)
        detector.startDetectionSession()
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

// MARK: Conditioned Photo Capture
extension AutoCaptureManager {
    @MainActor
    private func conditionsCheckedPhotoCapture() {
        if captureConditionsMet() {
            photoCapture()
        }
    }
    
    private func captureConditionsMet() -> Bool {
        lensPosConditionMet() &&
        accelMagConditionMet() &&
        detectionConditionMet()
    }
    
    /// Lens Position Condition Checker
    private func lensPosConditionMet() -> Bool {
        captureSession.inputCamera.device.lensPosition < PhotoCaptureConditions.lensPosThreshold
    }
    
    /// Acceleration Magnitude Condition Checker
    private func accelMagConditionMet() -> Bool {
        deviceMotion.accelMag < PhotoCaptureConditions.accelMagThreshold
    }
    
    /// Detection Condition Checker
    private func detectionConditionMet() -> Bool {
        detectionConfidenceMet() && detectionBoxConditionsMet()
    }
    
    private func detectionBoxConditionsMet() -> Bool {
        self.detector.objBoundingBox.maxY > PhotoCaptureConditions.detectionBoxMaxYThreshold &&
        self.detector.objBoundingBox.minY < PhotoCaptureConditions.detectionBoxMinYThreshold &&
        self.detector.objBoundingBox.maxX > PhotoCaptureConditions.detectionBoxMaxXThreshold &&
        self.detector.objBoundingBox.minX < PhotoCaptureConditions.detectionBoxMinXThreshold
    }
    
    private func detectionConfidenceMet() -> Bool {
        self.detector.detectionConfidence > PhotoCaptureConditions.detectionConfidenceTheshold
    }
    
    private struct PhotoCaptureConditions {
        // MARK: Camera & Device Motion Thresholds
        static let lensPosThreshold: Float = 0.6
        static let accelMagThreshold: Double = 0.4
        
        // MARK: Detection Thresholds
        static let detectionConfidenceTheshold: Float = 0.5
        static let detectionBoxMaxYThreshold: Double = 0.5
        static let detectionBoxMinYThreshold: Double = 0.5
        static let detectionBoxMaxXThreshold: Double = 0.5
        static let detectionBoxMinXThreshold: Double = 0.5
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
