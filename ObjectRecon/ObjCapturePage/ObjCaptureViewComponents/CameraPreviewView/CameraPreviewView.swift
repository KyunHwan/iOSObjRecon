//
//  CameraPreviewView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/23/24.
//

import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    
    func makeUIView(context: Context) -> VideoPreview {
        let view = VideoPreview()
        
        view.videoPreviewLayer.session = objCaptureViewModel.session
        
        view.backgroundColor = CameraPreviewViewParameters.backgroundColor
        view.videoPreviewLayer.cornerRadius = CameraPreviewViewParameters.cornerRadius
        
        objCaptureViewModel.startDetection(with: view.layer)
        return view
    }
    
    func updateUIView(_ uiView: VideoPreview, context: Context) {}
    
    private struct CameraPreviewViewParameters {
        static let backgroundColor: UIColor = .black
        static let cornerRadius: CGFloat = 0.0
    }
}
