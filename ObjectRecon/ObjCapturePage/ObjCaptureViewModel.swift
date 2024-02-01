//
//  ObjCaptureViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import Foundation
import AVFoundation

class ObjCaptureViewModel: ObservableObject {
    private let autoCaptureManager: AutoCaptureManager
    var session: AVCaptureSession { autoCaptureManager.session }
    
    init() {
        autoCaptureManager = AutoCaptureManager()
    }
    
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
    
    func startDetection(with layer: CALayer) {
        autoCaptureManager.startDetection(with: layer)
    }
}
