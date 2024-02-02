//
//  CameraPreviewView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/23/24.
//

import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    @EnvironmentObject var objCaptureViewModel: ObjCaptureViewModel
    
    func makeUIView(context: Context) -> VideoPreview {
        let view = VideoPreview()
        view.videoPreviewLayer.session = objCaptureViewModel.session
        
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        
        objCaptureViewModel.startDetection(with: view.layer)
        return view
    }
    
    func updateUIView(_ uiView: VideoPreview, context: Context) {  }
}
