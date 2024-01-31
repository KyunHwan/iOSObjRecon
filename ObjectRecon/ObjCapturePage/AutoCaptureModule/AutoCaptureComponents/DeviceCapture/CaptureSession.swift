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
                session.startRunning()
            }
        }
    }
    
    func stopRunning() { if session.isRunning { session.stopRunning() } }
    
    private func configureSession() {
        self.checkAddInputOutput()
        
        self.session.beginConfiguration()
        
        self.addInputs()
        self.addOutputs()
        self.session.setPhotoPreset()
        
        self.session.commitConfiguration()
    }
}

// MARK: Adding input and output to session
extension CaptureSession {
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

// MARK: Photo Capture Output
extension CaptureSession {
    /// This needs to run on Main thread since it increments numPhotos,
    /// which should be accessed by one thread at a time
    @MainActor
    func captureFrame(with directoryManager: DirectoryManager) { self.photoCaptureManager.saveFrame(with: directoryManager) }
}

// MARK: AVCaptureSession Photo Preset
extension AVCaptureSession {
    func setPhotoPreset() { self.sessionPreset = AVCaptureSessionSettings.sessionPreset }
    
    private struct AVCaptureSessionSettings {
        static let sessionPreset: AVCaptureSession.Preset = .photo
    }
}
