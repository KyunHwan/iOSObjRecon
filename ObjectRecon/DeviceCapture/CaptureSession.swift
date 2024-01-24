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
    private let photoCaptureManager: PhotoCaptureManager
    let outputCameraPreview: VideoPreview
    
    // MARK: File Manager
    private let directoryManager: DirectoryManager
    
    init() {
        self.session = AVCaptureSession()
        self.inputCamera = .createObjCaptureInputCamera()
        self.photoCaptureManager = PhotoCaptureManager()
        self.outputCameraPreview = VideoPreview()
        self.directoryManager = DirectoryManager(filePrefixInDirectory: "IMG_", fileSuffixInDirectory: ".JPG")
    }
    
    
    func configureSession() {
        guard self.session.canAddInput(inputCamera), self.session.canAddOutput(photoCaptureManager.photoOutput) else {
            fatalError("Session could not be configured")
        }
        self.session.beginConfiguration()
        
        self.session.addInput(inputCamera)
        self.session.addOutput(photoCaptureManager.photoOutput)
        
        self.session.commitConfiguration()
    }
    
    func startRunning() async {
        if !session.isRunning {
            self.configureSession()
            session.startRunning()
            await MainActor.run {
                setPreviewSession()
            }
        }
    }
    
    func stopRunning() {
        if session.isRunning { session.stopRunning() }
    }
}

// MARK: Video Preview Output
@MainActor
extension CaptureSession {
    // This needs to run on Main thread since this updates the UIView
    func setPreviewSession() {
        self.outputCameraPreview.session = self.session
    }
}

// MARK: Photo Capture Output
extension CaptureSession {
    @MainActor 
    func captureFrame() {
        print("Tapped! Thread: \(Thread.current)")
        self.photoCaptureManager.saveFrame(to: directoryManager.nextImagePath)
        self.directoryManager.incrementNumPhotos() // Should be accessed only by one thread each time
    }
}
