//
//  VideoDataOutput.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/30/24.
//

import Foundation
import AVFoundation

class VideoDataOutputManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let videoDataOutput: AVCaptureVideoDataOutput
    private let dataOutputQueue: DispatchQueue
    
    // MARK: Output Augmentation
    private var outputAugmentor: MLDetector?
    
    init(with outputAugmentor: MLDetector? = nil) {
        videoDataOutput = AVCaptureVideoDataOutput()
        dataOutputQueue = DispatchQueue(label: "data output queue")
        self.outputAugmentor = outputAugmentor
        super.init()
        self.configure()
    }
    
    private func configure() {
        self.videoDataOutput.configureVideoCapture()
        self.videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
    }
}

extension VideoDataOutputManager {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        if let augmentor = outputAugmentor {
            let imageRequestHandler = MLDetector.createImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try imageRequestHandler.perform(augmentor.mlRequests)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: Configure Video Capture
extension AVCaptureVideoDataOutput {
    func configureVideoCapture() {
        self.alwaysDiscardsLateVideoFrames = VideoCaptureSettings.alwaysDiscardsLateVideoFrames
    }
    
    private struct VideoCaptureSettings {
        static let alwaysDiscardsLateVideoFrames = true
    }
}
