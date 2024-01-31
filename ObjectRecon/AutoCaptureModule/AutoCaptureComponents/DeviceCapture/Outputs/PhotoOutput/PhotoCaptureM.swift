//
//  PhotoCaptureConnector.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import Foundation
import AVFoundation
import Combine

class PhotoCaptureM {
    private let photoCaptureHelper: PhotoCaptureHelper
    private var photoCaptureMode: PhotoCaptureMode
    private var timer: AnyCancellable?
    private let directoryManager: DirectoryManager
    var photoOutput: AVCapturePhotoOutput { photoCaptureHelper.photoOutput }
    
    init() {
        self.photoCaptureHelper = PhotoCaptureHelper()
        self.photoCaptureMode = .auto
        self.timer = nil
        self.directoryManager = DirectoryManager(filePrefixInDirectory: "IMG_", fileSuffixInDirectory: ".JPG")
    }
    
    @MainActor
    func captureFrame() {
        switch photoCaptureMode {
        case .manual:
            photoCapture()
        case .auto:
            autoPhotoCapture()
        }
    }
    
    private enum PhotoCaptureMode: String {
        case manual
        case auto
    }
}

// MARK: Manual Photo Capture
extension PhotoCaptureM {
    @MainActor
    private func photoCapture() {
        directoryManager.checkCreateNewDirectory()
        photoCaptureHelper.saveFrame(with: directoryManager)
    }
}

// MARK: Automatic Photo Capture
extension PhotoCaptureM {
    @MainActor
    private func autoPhotoCapture() {
        if let _ = self.timer { stopAutoPhotoCapture() }
        else { startAutoPhotoCapture() }
    }
    
    @MainActor
    private func startAutoPhotoCapture() {
        directoryManager.createNewDirectory()
        self.timer = Timer.publish(every: AutoCaptureConstants.updateEverySecs, on: .main, in: .common)
                                .autoconnect()
                                .sink(receiveValue: { _ in self.photoCapture() })
    }
    
    @MainActor
    private func stopAutoPhotoCapture() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    private struct AutoCaptureConstants {
        static let updateEverySecs: Double = 0.25
    }
}
