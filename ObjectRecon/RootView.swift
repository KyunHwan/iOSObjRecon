//
//  RootView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var captureSession: CaptureSession
    
    var body: some View {
        ObjCaptureView()
            .task{
                await captureSession.startRunning()
            }
            .onDisappear {
                captureSession.stopRunning()
            }
            .environmentObject(captureSession)
    }
}

#Preview {
    RootView()
        .environmentObject(CaptureSession())
}
