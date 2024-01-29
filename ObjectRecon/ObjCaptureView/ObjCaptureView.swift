//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @EnvironmentObject var captureSession: CaptureSession
    @EnvironmentObject var deviceMotionProvider: DeviceMotionProvider

    var body: some View {
        ZStack {
            CameraPreviewView()
                .environmentObject(captureSession)
            VStack {
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
                
                Spacer()
                
                Text("Accel: 0")
            }
        }
    }
}

#Preview {
    ObjCaptureView()
        .environmentObject(CaptureSession())
}
