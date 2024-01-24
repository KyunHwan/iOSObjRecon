//
//  CaptureSession.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

class CaptureSession: ObservableObject {
    private let session: AVCaptureSession
    
    // MARK: Inputs During the Session
    private let inputCamera: AVCaptureDeviceInput
    
    // MARK: Outputs During the Session
    private let outputPhotoCapture: AVCapturePhotoOutput
    let outputCameraPreview: VideoPreview
    
    // MARK: File Manager
    private let directoryManager: DirectoryManager
    
    init() {
        self.session = AVCaptureSession()
        self.inputCamera = .createObjCaptureInputCamera()
        self.outputPhotoCapture = .createConfiguredPhotoOutput()
        self.outputCameraPreview = VideoPreview()
        self.directoryManager = DirectoryManager(filePrefixInDirectory: "IMG_")
    }
    
    func configureSession() {
        guard self.session.canAddInput(inputCamera), self.session.canAddOutput(outputPhotoCapture) else {
            fatalError("Session could not be configured")
        }
        self.session.beginConfiguration()
        
        self.session.addInput(self.inputCamera)
        self.session.addOutput(self.outputPhotoCapture)
        self.setPreviewSession()
        
        self.session.commitConfiguration()
    }
    
    func startRunning() async {
        if !session.isRunning {
            self.configureSession()
            session.startRunning()
            setPreviewSession()
        }
    }
    
    func stopRunning() {
        if session.isRunning { session.stopRunning() }
    }
}

// MARK: Video Preview Output
extension CaptureSession {
    func setPreviewSession() {
        self.outputCameraPreview.session = self.session
    }
}

// MARK: Photo Capture Output
extension CaptureSession {
    @MainActor 
    func captureFrame() {
        self.outputPhotoCapture.saveFrame(to: directoryManager.nextImagePath)
        self.directoryManager.incrementNumPhotos() // Should be accessed only by one thread each time
    }
}
