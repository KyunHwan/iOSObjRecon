//
//  PhotoOutputSettings.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

class PhotoCaptureManager {
    let photoOutput: AVCapturePhotoOutput
    private var photoCaptureDelegateContainer: Set<PhotoCaptureProcessor>
    
    init() {
        photoOutput = AVCapturePhotoOutput.createConfiguredPhotoOutput()
        photoCaptureDelegateContainer = Set<PhotoCaptureProcessor>()
    }
    
    // MARK: Capture & Save Photo
    @MainActor
    func saveFrame(with directoryManager: DirectoryManager) {
        if let path = directoryManager.nextImagePath {
            // Setup delegate & AVcapturePhotoSettings
            let photoCaptureSettings = AVCapturePhotoSettings.createConfiguredAVCapturePhotoSettings(format: self.photoOutput.appropriatePhotoCodecType())
            let photoCaptureDelegate = PhotoCaptureProcessor(with: { [weak self] photo in self?.save(photo, at: path) })
            photoCaptureDelegate.completionHandler = { [weak self] in self?.updateDelegateContainer(for: photoCaptureDelegate) }
            
            // Add photoCaptureDelegate to the container to hold reference so that it doesn't get garbage collected
            updateDelegateContainer(for: photoCaptureDelegate)
            Task { self.photoOutput.capturePhoto(with: photoCaptureSettings, delegate: photoCaptureDelegate) }
            
            directoryManager.incrementNumPhotos() /// Should be accessed only by one thread each time
        }
        else { print("Could not find path for saving image") }
    }
}

// MARK: saveFrame Helper Functions
extension PhotoCaptureManager {
    private func save(_ photo: AVCapturePhoto, at path: URL) {
        let photoData = photo.fileDataRepresentation()
        //DirectoryManager.createFile(at: path, contents: photoData)
        DirectoryManager.createResizedFile(at: path, contents: photoData)
    }
    
    private func updateDelegateContainer(for delegate: PhotoCaptureProcessor) {
        if photoCaptureDelegateContainer.contains(delegate) {
            photoCaptureDelegateContainer.remove(delegate)
        } else {
            photoCaptureDelegateContainer.insert(delegate)
        }
    }
}
