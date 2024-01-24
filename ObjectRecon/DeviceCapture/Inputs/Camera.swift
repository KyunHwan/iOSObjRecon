//
//  CaptureDevice.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import Foundation
import AVFoundation

// MARK: Create & Configure Input Device Camera
extension AVCaptureDeviceInput {
    static func createObjCaptureInputCamera() -> AVCaptureDeviceInput {
        let inputCamera: AVCaptureDeviceInput
        if let device = AVCaptureDevice.createObjCaptureCamera() {
            do {
                inputCamera = try AVCaptureDeviceInput(device: device)
                inputCamera.device.configureCamera()
                return inputCamera
            } catch {
                fatalError("Error: \(error.localizedDescription) occurred during input device initialization")
            }
        } else {
            fatalError("Device input couldn't be initialized")
        }
    }
}

// MARK: Camera Creation/Properties
extension AVCaptureDevice {
    static func createObjCaptureCamera() -> AVCaptureDevice? {
        guard let device = AVCaptureDevice.default(ObjCaptureCameraProperties.device,
                                                   for: ObjCaptureCameraProperties.media,
                                                   position: ObjCaptureCameraProperties.devicePos)
        else {
            fatalError("Capture device couldn't be created")
        }
        return device
    }
    private struct ObjCaptureCameraProperties {
        static let device = AVCaptureDevice.DeviceType.builtInUltraWideCamera
        static let media = AVMediaType.video
        static let devicePos = AVCaptureDevice.Position.back
    }
}

// MARK: Camera Configuration
extension AVCaptureDevice {
    func configureCamera() {
        configureSetting(for: .focus, PoI: CameraFocusSettings.focusPoI)
        configureSetting(for: .exposure, PoI: CameraExposureSettings.exposurePoI)
        configureSetting(for: .whiteBalance)
        configureSetting(for: .zoom)
    }
    
    func configureSetting(for settings: SettingsType, PoI: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        do {
            try self.lockForConfiguration()
            switch settings {
                case .focus:
                    configureFocusSettings(focusPoI: PoI)
                case .exposure:
                    configureExposureSettings(exposurePoI: PoI)
                case .whiteBalance:
                    configureWhiteBalanceSettings()
                case .zoom:
                    configureZoomSettings()
            }
        } catch {
            print("\(error.localizedDescription) occurred during \(settings.rawValue) configuration")
        }
        self.unlockForConfiguration()
    }
    
    enum SettingsType: String {
        case focus = "Focus"
        case whiteBalance = "White Balance"
        case exposure = "Exposure"
        case zoom = "Zoom"
    }
}

// MARK: Focus Settings
extension AVCaptureDevice {
    private struct CameraFocusSettings {
        static let adjustFaceDrivenAutoFocus = false
        static let faceDrivenAutoFocusEnabled = false
        static let focusPoI = CGPoint(x: 0.5, y: 0.5)
        static let focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
        static let smoothAutoFocusEnabled = false
    }
    private func configureFocusSettings(focusPoI: CGPoint) {
        if self.isFaceDrivenAutoFocusEnabled {
            self.automaticallyAdjustsFaceDrivenAutoFocusEnabled = CameraFocusSettings.adjustFaceDrivenAutoFocus
            self.isFaceDrivenAutoFocusEnabled = CameraFocusSettings.faceDrivenAutoFocusEnabled
        }
        if self.isFocusPointOfInterestSupported {
            self.focusPointOfInterest = focusPoI
        }
        if self.isFocusModeSupported(CameraFocusSettings.focusMode) {
            self.focusMode = CameraFocusSettings.focusMode
        }
        if self.isSmoothAutoFocusSupported {
            self.isSmoothAutoFocusEnabled = CameraFocusSettings.smoothAutoFocusEnabled
        }
    }
}

// MARK: Exposure Settings
extension AVCaptureDevice {
    private struct CameraExposureSettings {
        static let adjustFaceDrivenAutoExposure = false
        static let faceDrivenAutoExposureEnabled = false
        static let exposurePoI = CGPoint(x: 0.5, y: 0.5)
        static let exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
        static let activeMaxExposureDuration = CMTimeMake(value: 1, timescale: 60)
    }
    private func configureExposureSettings(exposurePoI: CGPoint) {
        if self.isFaceDrivenAutoExposureEnabled {
            self.automaticallyAdjustsFaceDrivenAutoExposureEnabled = CameraExposureSettings.adjustFaceDrivenAutoExposure
            self.isFaceDrivenAutoExposureEnabled = CameraExposureSettings.faceDrivenAutoExposureEnabled
        }
        if self.isExposurePointOfInterestSupported {
            self.exposurePointOfInterest = exposurePoI
        }
        if self.isExposureModeSupported(CameraExposureSettings.exposureMode) {
            self.exposureMode = CameraExposureSettings.exposureMode
        }
        self.activeMaxExposureDuration = CameraExposureSettings.activeMaxExposureDuration
    }
}

// MARK: White Balance Settings
extension AVCaptureDevice {
    private struct CameraWhiteBalanceSettings {
        static let whiteBalanceMode = AVCaptureDevice.WhiteBalanceMode.continuousAutoWhiteBalance
    }
    private func configureWhiteBalanceSettings() {
        if self.isWhiteBalanceModeSupported(CameraWhiteBalanceSettings.whiteBalanceMode) {
            self.whiteBalanceMode = CameraWhiteBalanceSettings.whiteBalanceMode
        }
    }
}

// MARK: Zoom Settings
extension AVCaptureDevice {
    private struct CameraZoomSettings {
        static let videoZoomFactor: CGFloat = 2.0
    }
    private func configureZoomSettings() {
        self.videoZoomFactor = CameraZoomSettings.videoZoomFactor
    }
}
