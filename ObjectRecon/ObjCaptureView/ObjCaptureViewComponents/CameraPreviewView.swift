//
//  CameraPreviewView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/23/24.
//

import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    @EnvironmentObject var captureSession: CaptureSession
    
    func makeUIView(context: Context) -> VideoPreview {
        captureSession.setPreviewSession()
        captureSession.outputCameraPreview.videoPreviewLayer.videoGravity = .resizeAspectFill
        return captureSession.outputCameraPreview
    }
    
    func updateUIView(_ uiView: VideoPreview, context: Context) {  }
}
