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
        Menu("Capture Modes") {
            Button("Manual") { objCaptureViewModel.setManualCaptureMode() }
            Button("Auto") { objCaptureViewModel.setAutoCaptureMode() }
        }
    }
}
