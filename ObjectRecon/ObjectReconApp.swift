//
//  ObjectReconApp.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import SwiftUI

@main
struct ObjectReconApp: App {
    @StateObject var captureSession = CaptureSession()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(captureSession)
        }
    }
}
