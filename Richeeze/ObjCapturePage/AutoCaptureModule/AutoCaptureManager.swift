//
//  AutoCaptureModule.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import Foundation
import Combine
import AVFoundation
import ZIPFoundation

class AutoCaptureManager {
    // MARK: Camera
    private(set) var captureSession: CaptureSession
    private var photoCaptureMode: PhotoCaptureMode
    private var timer: AnyCancellable?
    var session: AVCaptureSession { captureSession.session }
    
    private(set) var directoryManager: DirectoryManager
    
    // MARK: Device Motion
    private(set) var deviceMotion: DeviceMotionProvider
    
    // MARK: MLDetector
    private(set) var detector: MLDetector
    
    // MARK: Auditory Capture Feedback
    private let auditoryCaptureFeedbackManager: AuditoryCaptureFeedbackManager
    
    init() {
        deviceMotion = DeviceMotionProvider()
        detector = MLDetector()
        captureSession = CaptureSession(with: detector)
        auditoryCaptureFeedbackManager = AuditoryCaptureFeedbackManager()
        
        directoryManager = DirectoryManager(filePrefixInDirectory: AutoCaptureConstants.imagePrefix,
                                            fileSuffixInDirectory: AutoCaptureConstants.imageSuffix)
        photoCaptureMode = AutoCaptureConstants.captureMode
        timer = nil
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
    
    func playMusic() {
        auditoryCaptureFeedbackManager.playSound()
    }
    
    func pauseMusic() {
        auditoryCaptureFeedbackManager.pauseSound()
    }
    
    func startDetection(with previewLayer: CALayer) {
        detector.initRootLayer(with: previewLayer)
        detector.startDetectionSession()
    }
    
    func toggleTorch() { captureSession.toggleTorch() }
    
    @MainActor
    func captureFrame() {
        switch photoCaptureMode {
            case .manual: manualPhotoCapture()
            case .auto: autoPhotoCapture()
        }
    }
    
    private enum PhotoCaptureMode: String {
        case manual
        case auto
    }
}

// MARK: Update Focus Position
extension AutoCaptureManager {
    func updateFocusLocation(focusPoint: CGPoint) {
        captureSession.updateFocusLocation(focusPoint: focusPoint)
    }
}

// MARK: Automatic Photo Capture
extension AutoCaptureManager {
    func setAutoCaptureMode() {
        photoCaptureMode = .auto
    }
    func setManualCaptureMode() {
        photoCaptureMode = .manual
    }
    
    @MainActor
    private func autoPhotoCapture() {
        if let _ = self.timer { stopPhotoCapture() }
        else { startAutoPhotoCapture() }
    }
    
    @MainActor
    private func manualPhotoCapture() {
        if let _ = self.timer { stopPhotoCapture() }
        else { startManualPhotoCapture() }
    }
    
    @MainActor
    private func startManualPhotoCapture() {
        directoryManager.createNewDirectory()
        self.timer = Timer.publish(every: AutoCaptureConstants.updateEverySecs, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in self.photoCapture() })
    }
    
    @MainActor
    private func startAutoPhotoCapture() {
        directoryManager.createNewDirectory()
        self.timer = Timer.publish(every: AutoCaptureConstants.updateEverySecs, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in self.conditionsCheckedPhotoCapture() })
    }
    
    @MainActor
    private func stopPhotoCapture() {
        self.timer?.cancel()
        self.timer = nil
    }
}

// MARK: Conditioned Photo Capture
extension AutoCaptureManager {
    
    @MainActor
    func captureConditionsMet(lensPos: Float, accelMag: Double, box: CGRect, confidence: Float) -> Bool {
        lensPosConditionMet(for: lensPos) &&
        accelMagConditionMet(for: accelMag) &&
        detectionBoxConditionsMet(for: box) &&
        detectionConfidenceMet(for: confidence)
    }
    
    @MainActor
    private func conditionsCheckedPhotoCapture() {
        if captureConditionsMet() {
            photoCapture()
        }
    }
    
    private func captureConditionsMet() -> Bool {
        lensPosConditionMet(for: self.captureSession.lensPos) &&
        accelMagConditionMet(for: self.deviceMotion.accelMag) &&
        detectionConditionMet()
    }
    
    /// Detection Condition Checker
    private func detectionConditionMet() -> Bool {
        detectionConfidenceMet(for: self.detector.detectionConfidence) &&
        detectionBoxConditionsMet(for: self.detector.objBoundingBox)
    }
    
    /// Lens Position Condition Checker
    private func lensPosConditionMet(for lensPos: Float) -> Bool {
        lensPos < AutoCaptureConditions.lensPosThreshold
    }
    
    /// Acceleration Magnitude Condition Checker
    private func accelMagConditionMet(for accelMag: Double) -> Bool {
        accelMag < AutoCaptureConditions.accelMagThreshold
    }
    
    private func detectionBoxConditionsMet(for box: CGRect) -> Bool {
        box.maxY > AutoCaptureConditions.detectionBoxMaxYThreshold &&
        box.minY < AutoCaptureConditions.detectionBoxMinYThreshold &&
        box.maxX > AutoCaptureConditions.detectionBoxMaxXThreshold &&
        box.minX < AutoCaptureConditions.detectionBoxMinXThreshold
    }
    
    private func detectionConfidenceMet(for confidence: Float) -> Bool {
        confidence > AutoCaptureConditions.detectionConfidenceTheshold
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

// MARK: Firebase Upload
extension AutoCaptureManager {
    
    func uploadCapFolderToFirebase(progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (String) -> Void) {
        
        guard let lastCapFolder = directoryManager.dirPath else {
            print("There's no capture folder to upload !")
            return
        }
        
        let zipURL = lastCapFolder
            .deletingLastPathComponent()
            .appendingPathComponent(lastCapFolder.lastPathComponent)
            .appendingPathExtension("zip")
                    
        if FileManager.default.fileExists(atPath: zipURL.path) {
            do {
                try FileManager.default.removeItem(atPath: zipURL.path)
                print("Old file removed : \(zipURL)")
            } catch {
                print("Cannot remove file \(zipURL), error :\(error)")
            }
        }
        
        do {
            try FileManager.default.zipItem(
                at: lastCapFolder,
                to: zipURL,
                shouldKeepParent: false,
                compressionMethod: .none,
                progress: nil
            )
            print("New file created : \(zipURL)")
            
            FireStorageHelper.writeFileToFireStorage(to: zipURL, progressHandler: progressHandler, completionHandler: completionHandler)
            
        } catch {
            print("Creation of ZIP archive failed with error:\(error)")
        }
    }
}

// MARK: Constants
extension AutoCaptureManager {
    private struct AutoCaptureConditions {
        // MARK: Camera & Device Motion Thresholds
        static let lensPosThreshold: Float = 0.75
        static let accelMagThreshold: Double = 0.7
        
        // MARK: Detection Thresholds
        static let detectionConfidenceTheshold: Float = 0.3
        
        static let detectionBoxMaxYThreshold: Double = 0.5
        static let detectionBoxMinYThreshold: Double = 0.5
        static let detectionBoxMaxXThreshold: Double = 0.5
        static let detectionBoxMinXThreshold: Double = 0.5
    }
    
    private struct AutoCaptureConstants {
        static let updateEverySecs: Double = 0.25
        static let captureMode: PhotoCaptureMode = .auto
        static let imagePrefix: String = "IMG_"
        static let imageSuffix: String = ".JPG"
    }
}
