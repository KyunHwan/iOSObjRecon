//
//  CaptureSession.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

class CaptureSession {
    private(set) var session: AVCaptureSession
    
    // MARK: Inputs to Session
    private(set) var inputCamera: AVCaptureDeviceInput
    
    // MARK: Outputs to Session
    private(set) var photoCaptureManager: PhotoCaptureManager
    private(set) var videoDataOutputManager: VideoDataOutputManager
    
    init(with outputAugmentor: MLDetector? = nil) {
        self.session = AVCaptureSession()
        self.inputCamera = AVCaptureDeviceInput.createObjCaptureInputCamera()
        self.photoCaptureManager = PhotoCaptureManager()
        self.videoDataOutputManager = VideoDataOutputManager(with: outputAugmentor)
    }
    
    func startRunning() {
        if !session.isRunning {
            Task {
                self.configureSession()
                self.configureOrientations()
                session.startRunning()
            }
        }
    }
    
    func stopRunning() { if session.isRunning { session.stopRunning() } }
    
    /// This needs to run on Main thread since it increments numPhotos, which should be accessed by one thread at a time
    @MainActor
    func captureFrame(with directoryManager: DirectoryManager) {
        self.photoCaptureManager.saveFrame(with: directoryManager)
    }
}


// MARK: Configuration Helpers
extension CaptureSession {
    private func configureSession() {
        self.checkAddInputOutput()
        
        self.session.beginConfiguration()
        
        self.addInputs()
        self.addOutputs()
        self.session.setPhotoPreset()
        
        self.session.commitConfiguration()
    }
    
    private func configureOrientations() {
        let rotation = self.session.connections[0].videoRotationAngle
        for connection in self.session.connections {
            connection.videoRotationAngle = rotation
        }
    }
    
    private func checkAddInputOutput() {
        guard self.session.canAddInput(inputCamera),
              self.session.canAddOutput(photoCaptureManager.photoOutput),
              self.session.canAddOutput(videoDataOutputManager.videoDataOutput)
        else { fatalError("Capture session could not be configured") }
    }
    
    private func addInputs() {
        self.session.addInput(inputCamera)
    }
    
    private func addOutputs() {
        self.session.addOutput(photoCaptureManager.photoOutput)
        self.session.addOutput(videoDataOutputManager.videoDataOutput)
    }
}

// MARK: AVCaptureSession Extension
extension AVCaptureSession {
    func setPhotoPreset() { self.sessionPreset = AVCaptureSessionSettings.sessionPreset }
    
    private struct AVCaptureSessionSettings {
        static let sessionPreset: AVCaptureSession.Preset = .photo
    }
}
