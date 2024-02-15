//
//  PhotoCaptureDelegate.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {

    private var photoProcessingHandler: (_ photo: AVCapturePhoto) -> Void
    var completionHandler: () -> ()
    
    init(with photoProcessingHandler: @escaping (_ photo: AVCapturePhoto) -> Void) {
        self.photoProcessingHandler = photoProcessingHandler
        self.completionHandler = {}
    }
    
    // MARK: Monitoring Capture Progress
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {  }
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) { AudioServicesDisposeSystemSoundID(1108) }
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings)  {  }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {  }
    
    // MARK: Receiving Capture Results
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) { 
        // Where captured photo should be caught and saved
        print("Finished Processing Photo!")
        Task {
            photoProcessingHandler(photo)
            await MainActor.run { completionHandler() }
        }
    }
    
    // MARK: Receiving Capture Results for Live Photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {  }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {  }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCapturingDeferredPhotoProxy deferredPhotoProxy: AVCaptureDeferredPhotoProxy?, error: Error?) {  }
}
