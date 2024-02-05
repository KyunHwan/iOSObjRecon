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
            CameraPreviewView(objCaptureViewModel: objCaptureViewModel)
            VStack {
                Text("\(objCaptureViewModel.deviceOrientation.angle)")
                //BlurView()
                Spacer()
                ProgressBarView(objCaptureViewModel: objCaptureViewModel, arModelManager: arModelManager,
                                width: 150, height: 100, progressBarLocation: .center)
                
                //ARModelPresentationView(arModelManager: arModelManager,
                //                        objCaptureViewModel: objCaptureViewModel)
                Spacer()
                CaptureButtonPanelView(objCaptureViewModel: objCaptureViewModel,
                                       arModelManager: arModelManager,
                                       width: 3)
            }
        }
        .task {
            objCaptureViewModel.startAutoSession()
        }
        .onDisappear {
            objCaptureViewModel.stopAutoSession()
        }        
    }
}

#Preview {
    ObjCaptureView()
}
