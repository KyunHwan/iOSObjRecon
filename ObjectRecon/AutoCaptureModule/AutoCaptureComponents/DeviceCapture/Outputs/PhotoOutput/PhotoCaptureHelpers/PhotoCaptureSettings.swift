//
//  PhotoOutputSettings.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

// MARK: Create Configured Instance
extension AVCapturePhotoSettings {
    static func createConfiguredAVCapturePhotoSettings(format: [String: Any]?) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings(format: format)
        return configureSettings(for: settings)
    }
    
    private static func configureSettings(for settings: AVCapturePhotoSettings) -> AVCapturePhotoSettings {
        // Add more configurations if needed
        let settings = configurePhotoSettings(for: settings)
        return settings
    }
}

// MARK: Capture Photo Settings
extension AVCapturePhotoSettings {
    private static func configurePhotoSettings(for settings: AVCapturePhotoSettings) -> AVCapturePhotoSettings {
        settings.flashMode = ConfigPhotoSettings.flashMode
        settings.isAutoRedEyeReductionEnabled = ConfigPhotoSettings.autoRedEyeReduction
        settings.photoQualityPrioritization = ConfigPhotoSettings.speedQuality
        return settings
    }
    private struct ConfigPhotoSettings {
        static let flashMode = AVCaptureDevice.FlashMode.off
        static let autoRedEyeReduction = false
        static let speedQuality = AVCapturePhotoOutput.QualityPrioritization.speed
    }
}
