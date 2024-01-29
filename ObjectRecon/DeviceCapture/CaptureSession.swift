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
    
    // MARK: Connector to Photo Capture Manager
    private let photoCaptureConnector: PhotoCaptureConnector
    
    // MARK: Outputs During the Session
    let outputCameraPreview: VideoPreview
    
    init() {
        self.session = AVCaptureSession()
        self.inputCamera = AVCaptureDeviceInput.createObjCaptureInputCamera()
        self.photoCaptureConnector = PhotoCaptureConnector()
        self.outputCameraPreview = VideoPreview()
    }
    
    func configureSession() {
        guard self.session.canAddInput(inputCamera), self.session.canAddOutput(photoCaptureConnector.photoOutput)
        else { fatalError("Session could not be configured") }
        
        self.session.beginConfiguration()
        
        self.session.addInput(inputCamera)
        self.session.addOutput(photoCaptureConnector.photoOutput)
        self.session.setPhotoPreset()
        
        self.session.commitConfiguration()
    }
    
    func startRunning() async {
        if !session.isRunning {
            self.configureSession()
            session.startRunning()
            await MainActor.run { setPreviewSession() }
        }
    }
    
    func stopRunning() { if session.isRunning { session.stopRunning() } }
}

// MARK: AVCaptureSession Photo Preset
extension AVCaptureSession {
    func setPhotoPreset() { self.sessionPreset = .photo }
}

// MARK: Video Preview Output
extension CaptureSession {
    /// This needs to run on Main thread since this updates the UIView
    @MainActor
    func setPreviewSession() { self.outputCameraPreview.session = self.session }
}

// MARK: Photo Capture Output
extension CaptureSession {
    /// This needs to run on Main thread since it increments numPhotos,
    /// which should be accessed by one thread at a time
    @MainActor
    func captureFrame() { self.photoCaptureConnector.captureFrame() }
}
