//
//  PhotoOutputSettings.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

// MARK: Create Configured Instance
extension AVCapturePhotoOutput {
    static func createConfiguredPhotoOutput() -> AVCapturePhotoOutput {
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.configure()
        return photoOutput
    }
    
    private func configure() {
        configResponsiveCapture()
        configCapturePrioritization()
        configLivePhotoCapture()
        configDepthDataCapture()
        configPortraitEffectsMatteCapture()
    }
}

// MARK: Capture & Save Photo
extension AVCapturePhotoOutput {
    func saveFrame(to path: URL?) {
        // Creates threads for saving photo when needed
        Task {
            // Setup delegate & AVcapturePhotoSettings
            let photoCaptureSettings = AVCapturePhotoSettings.createConfiguredAVCapturePhotoSettings(format: appropriatePhotoCodecType())
            let photoCaptureDelegate = PhotoCaptureProcessor(with: { photo in
                // Save Photo to a Document folder with URL of captureDir
                Task {
                    let photoData = photo.fileDataRepresentation()
                    DirectoryManager.createFile(at: path, contents: photoData)
                }
            })
            // Capture Photo
            self.capturePhoto(with: photoCaptureSettings, delegate: photoCaptureDelegate)
        }
    }
}

// MARK: Setting Appropriate Photo Codec Type for Saving
extension AVCapturePhotoOutput {
    private func appropriatePhotoCodecType() -> [String: Any]? {
        return self.availablePhotoCodecTypes.contains(PhotoCodecTypes.type) ? [AVVideoCodecKey: PhotoCodecTypes.type] : nil
    }
    private struct PhotoCodecTypes {
        static let type = AVVideoCodecType.jpeg
    }
}

// MARK: Set Configurations for Responsive Capture
extension AVCapturePhotoOutput {
    private func configResponsiveCapture() {
        if self.isAutoDeferredPhotoDeliverySupported {
            self.isAutoDeferredPhotoDeliveryEnabled = ResponsiveCaptureConfig.autoDeferredPhotoDelivery
        }
        if self.isFastCapturePrioritizationSupported {
            self.isFastCapturePrioritizationEnabled = ResponsiveCaptureConfig.fastCapturePrioritization
        }
        if self.isResponsiveCaptureSupported {
            self.isResponsiveCaptureEnabled = ResponsiveCaptureConfig.responsiveCapture
        }
        if self.isZeroShutterLagSupported {
            self.isZeroShutterLagEnabled = ResponsiveCaptureConfig.zeroShutterLag
        }
    }
    private struct ResponsiveCaptureConfig {
        static let autoDeferredPhotoDelivery = false
        static let fastCapturePrioritization = true
        static let responsiveCapture = true
        static let zeroShutterLag = true
    }
}

// MARK: Set Configurations for Capture Prioritization
extension AVCapturePhotoOutput {
    private func configCapturePrioritization() {
        self.maxPhotoQualityPrioritization = CapturePrioritizationConfig.speedQuality
    }
    private struct CapturePrioritizationConfig {
        static let speedQuality = AVCapturePhotoOutput.QualityPrioritization.speed
    }
}

// MARK: Set Configurations for Live Photo Capture
extension AVCapturePhotoOutput {
    private func configLivePhotoCapture() {
        if self.isLivePhotoCaptureSupported {
            self.isLivePhotoCaptureEnabled = LivePhotoCaptureConfig.livePhotoCapture
        }
    }
    private struct LivePhotoCaptureConfig {
        static let livePhotoCapture = false
    }
}

// MARK: Set Configurations for Depth Data Capture
extension AVCapturePhotoOutput {
    private func configDepthDataCapture() {
        if self.isDepthDataDeliverySupported {
            self.isDepthDataDeliveryEnabled = DepthDataCaptureConfig.depthData
        }
    }
    private struct DepthDataCaptureConfig {
        static let depthData = false
    }
}

// MARK: Set Configurations for Portrait Effects Matte Capture
extension AVCapturePhotoOutput {
    private func configPortraitEffectsMatteCapture() {
        if self.isPortraitEffectsMatteDeliverySupported {
            self.isPortraitEffectsMatteDeliveryEnabled = PortraitEffectsMatteCapture.portraitEffectsMatte
        }
    }
    private struct PortraitEffectsMatteCapture {
        static let portraitEffectsMatte = false
    }
}
