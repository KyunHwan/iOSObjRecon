//
//  RootView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var captureSession: CaptureSession
    @EnvironmentObject var deviceMotionProvider: DeviceMotionProvider
    
    var body: some View {
        ObjCaptureView()
            .task{
                await captureSession.startRunning()
                deviceMotionProvider.startMotionUpdate()
            }
            .onDisappear {
                captureSession.stopRunning()
            }
            .environmentObject(captureSession)
            .environmentObject(deviceMotionProvider)
    }
}

#Preview {
    RootView()
        .environmentObject(CaptureSession())
}
