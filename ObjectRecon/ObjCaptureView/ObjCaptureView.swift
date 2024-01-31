//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @StateObject var captureSession = CaptureSession()
    @StateObject var deviceMotionProvider = DeviceMotionProvider()

    var body: some View {
        ZStack {
            CameraPreviewView()
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
        .task{
            await captureSession.startRunning()
            deviceMotionProvider.startMotionUpdate()
        }
        .onDisappear {
            captureSession.stopRunning()
        }
    }
    
}

#Preview {
    ObjCaptureView()
}
