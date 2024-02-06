//
//  ObjCaptureViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import Foundation
import AVFoundation
import RealityKit
import Combine
import UIKit

@MainActor
final class ObjCaptureViewModel: ObservableObject {
    private let autoCaptureManager: AutoCaptureManager
    var session: AVCaptureSession { autoCaptureManager.session }
    @Published private(set) var isFlashOn: Bool
    @Published private(set) var deviceOrientation: simd_quatf
    @Published private(set) var numPhotosTaken: UInt32
    
    @Published private(set) var lensPos: Float
    @Published private(set) var accelMag: Double
    @Published private(set) var detectionBox: CGRect {
        willSet(newBox) {
            // Update Focus Position
            if !(newBox == CGRect()) {
                autoCaptureManager.updateFocusLocation(focusPoint: CGPoint(x: newBox.midX, y: newBox.midY))
            } else {
                autoCaptureManager.updateFocusLocation(focusPoint: CGPoint(x: 0.5, y: 0.5))
            }
        }
    }
    @Published private(set) var detectionConfidence: Float
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        autoCaptureManager = AutoCaptureManager()
        
        isFlashOn = false
        deviceOrientation = simd_quatf()
        numPhotosTaken = 0
        lensPos = 0
        accelMag = 0
        detectionBox = CGRect()
        detectionConfidence = 0
        
        cancellables = Set<AnyCancellable>()
        addSubscribers()
    }
}

// MARK: Subscribers for @Published
extension ObjCaptureViewModel {
    private func addSubscribers() {
        addSubscribersDirectoryManager()
        addSubscribersDetector()
        addSubscribersCaptureSession()
        addSubscribersDeviceMotion()
    }
    
    private func addSubscribersDirectoryManager() {
        autoCaptureManager.directoryManager.$numPhotos
            .sink(receiveValue: { [weak self] returnedValue in
                self?.numPhotosTaken = returnedValue
            })
            .store(in: &cancellables)
    }
    
    private func addSubscribersDetector() {
        autoCaptureManager.detector.$objBoundingBox
            .sink(receiveValue: { [weak self] returnedValue in
                self?.detectionBox = returnedValue
            })
            .store(in: &cancellables)
        
        autoCaptureManager.detector.$detectionConfidence
            .sink(receiveValue: { [weak self] returnedValue in
                self?.detectionConfidence = returnedValue
            })
            .store(in: &cancellables)
    }
    
    private func addSubscribersCaptureSession() {
        autoCaptureManager.captureSession.$lensPos
            .sink(receiveValue: { [weak self] returnedValue in
                self?.lensPos = returnedValue
            })
            .store(in: &cancellables)
    }
    
    private func addSubscribersDeviceMotion() {
        autoCaptureManager.deviceMotion.$deviceOrientation
            .sink(receiveValue:  { [weak self] returnedValue in
                self?.deviceOrientation = returnedValue
            })
            .store(in: &cancellables)
        
        autoCaptureManager.deviceMotion.$accelMag
            .sink(receiveValue: { [weak self] returnedValue in
                self?.accelMag = returnedValue
            })
            .store(in: &cancellables)
    }
}

// MARK: Controlling Flashlight
extension ObjCaptureViewModel {
    func flashButtonPressed() {
        isFlashOn.toggle()
        autoCaptureManager.toggleTorch()
    }
}

// MARK: Auto Capture
extension ObjCaptureViewModel {
    
    func setAutoCaptureMode() {
        autoCaptureManager.setAutoCaptureMode()
    }
    
    func setManualCaptureMode() {
        autoCaptureManager.setManualCaptureMode()
    }
    
    func captureConditionsMet(lensPos: Float, accelMag: Double, box: CGRect, confidence: Float) -> Bool {
        autoCaptureManager.captureConditionsMet(lensPos: lensPos, accelMag: accelMag, box: box, confidence: confidence)
    }
    
    func playMusic() {
        autoCaptureManager.playMusic()
    }
    
    func pauseMusic() {
        autoCaptureManager.pauseMusic()
    }
    
    func startAutoSession() {
        autoCaptureManager.startSession()
    }
    
    func stopAutoSession() {
        autoCaptureManager.stopSession()
    }
    
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
