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

class ObjCaptureViewModel: ObservableObject {
    private let autoCaptureManager: AutoCaptureManager
    var session: AVCaptureSession { autoCaptureManager.session }
    @Published var isFlashOn: Bool
    @Published var deviceOrientation: simd_quatf
    @Published var numPhotosTaken: UInt32
    private var cancellables: Set<AnyCancellable>
    
    init() {
        autoCaptureManager = AutoCaptureManager()
        deviceOrientation = simd_quatf()
        numPhotosTaken = 0
        isFlashOn = false
        
        cancellables = Set<AnyCancellable>()
        addSubscribers()
    }
}

// MARK: Subscribers for @Published
extension ObjCaptureViewModel {
    private func addSubscribers() {
        autoCaptureManager.$numPhotosTaken
            .sink(receiveValue: { [weak self] returnedValue in
                self?.numPhotosTaken = returnedValue
            })
            .store(in: &cancellables)
        
        autoCaptureManager.$deviceOrientation
            .sink(receiveValue:  { [weak self] returnedValue in
                self?.deviceOrientation = returnedValue
            })
            .store(in: &cancellables)
    }
}

extension ObjCaptureViewModel {
    func flashButtonPressed() {
        isFlashOn.toggle()
        autoCaptureManager.toggleTorch()
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
