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
            
            Button(action: { captureSession.captureFrame() }, label: {
                Text("Capture!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            })
            .frame(height: 55)
        }
    }
}

#Preview {
    ObjCaptureView()
        .environmentObject(CaptureSession())
}
