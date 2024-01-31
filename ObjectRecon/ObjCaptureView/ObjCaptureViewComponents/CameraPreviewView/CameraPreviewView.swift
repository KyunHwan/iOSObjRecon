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
        let view = VideoPreview()
        view.videoPreviewLayer.session = captureSession.session
        
        view.backgroundColor = .black
        view.layer = captureSession.rootLayer
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreview, context: Context) {  }
}
