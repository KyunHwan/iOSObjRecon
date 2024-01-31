//
//  CameraPreviewView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/23/24.
//

import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var autoCaptureManager: AutoCaptureManager
    
    init(with autoCaptureManager: AutoCaptureManager) {
        self.autoCaptureManager = autoCaptureManager
    }
    
    func makeUIView(context: Context) -> VideoPreview {
        let view = VideoPreview()
        view.videoPreviewLayer.session = autoCaptureManager.captureSession.session
        
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        autoCaptureManager.initRootLayer(with: view.layer)
        autoCaptureManager.startDetection()
        return view
    }
    
    func updateUIView(_ uiView: VideoPreview, context: Context) {  }
}
