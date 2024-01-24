//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @EnvironmentObject var captureSession: CaptureSession
    var body: some View {
        ZStack {
            CameraPreviewView()
                .environmentObject(captureSession)
            
            Text("Capture!")
                .font(.headline)
                .onTapGesture {
                    captureSession.captureFrame()
                }
        }
    }
}

#Preview {
    ObjCaptureView()
        .environmentObject(CaptureSession())
}
