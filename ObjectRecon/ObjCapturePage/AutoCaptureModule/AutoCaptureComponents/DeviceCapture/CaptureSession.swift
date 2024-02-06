//
//  CaptureSession.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

class CaptureSession: NSObject {
    private(set) var session: AVCaptureSession
    
    // MARK: Inputs to Session
    @objc private(set) var inputCamera: AVCaptureDeviceInput
    private var lensPosObservation: NSKeyValueObservation?
    @Published private(set) var lensPos: Float
    
    // MARK: Outputs to Session
    private(set) var photoCaptureManager: PhotoCaptureManager
    private(set) var videoDataOutputManager: VideoDataOutputManager
    
    init(with outputAugmentor: MLDetector? = nil) {
        self.session = AVCaptureSession()
        self.inputCamera = AVCaptureDeviceInput.createObjCaptureInputCamera()
        self.photoCaptureManager = PhotoCaptureManager()
        self.videoDataOutputManager = VideoDataOutputManager(with: outputAugmentor)
        self.lensPos = 0
        
        super.init()
        lensPosObservation = observe(
            \.inputCamera.device.lensPosition,
             options: [.new]
        ) { object, change in
            if let newValue = change.newValue {
                self.lensPos = newValue
            }
        }
    }
    
    func startRunning() {
        if !session.isRunning {
            Task {
                configureSession()
                session.startRunning()
            }
        }
    }
    
    func stopRunning() { if session.isRunning { session.stopRunning() } }
    
    func toggleTorch() { self.inputCamera.device.toggleTorch() }
    
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
        self.configureCamera()
        self.configureCaptureOrientations()
        
        self.session.commitConfiguration()
    }
    
    private func configureCamera() {
        self.inputCamera.device.configureCamera()
    }
    
    private func configureCaptureOrientations() {
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
