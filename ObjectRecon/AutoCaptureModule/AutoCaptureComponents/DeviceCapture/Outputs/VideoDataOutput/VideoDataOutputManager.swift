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
    
    override init() {
        videoDataOutput = AVCaptureVideoDataOutput()
        dataOutputQueue = DispatchQueue(label: "data output queue")
    }
    
    private func configure() {
        self.videoDataOutput.configureVideoCapture()
        self.videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
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
