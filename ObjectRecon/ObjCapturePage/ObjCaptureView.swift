//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @StateObject var objCaptureViewModel = ObjCaptureViewModel()
    @StateObject var arModelManager = ARModelManager()
    
    var body: some View {
        ZStack {
            CameraPreviewView()
            
        }
        .task {
            objCaptureViewModel.startAutoSession()
        }
        .onDisappear {
            objCaptureViewModel.stopAutoSession()
        }
        .environmentObject(objCaptureViewModel)
        .environmentObject(arModelManager)
        
    }
    
}

#Preview {
    ObjCaptureView()
}
