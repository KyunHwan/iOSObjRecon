//
//  CaptureModeMenu.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/6/24.
//

import SwiftUI

struct CaptureModeMenu: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    
    var body: some View {
        Menu("\(Image(systemName: "camera.fill"))") {
            Button("Manual") { objCaptureViewModel.setManualCaptureMode() }
            Button("Auto") { objCaptureViewModel.setAutoCaptureMode() }
        }
    }
}

