//
//  CaptureButtonView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

/// This capture button view is modeled after the Camera app button.
struct CaptureButton: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    @ObservedObject var arModelManager: ARModelManager
    
    var body: some View {
        Button(action: {
            objCaptureViewModel.captureFrame()
            arModelManager.resetInitialOrientation(using: objCaptureViewModel.deviceOrientation)
        }, label: {
            ManualCaptureButtonView(objCaptureViewModel: objCaptureViewModel)
        })
    }
}

/// This is a helper view for the `CaptureButton`. It implements the shape for manual capture mode.
struct ManualCaptureButtonView: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.white, lineWidth: ButtonParameters.strokeWidth)
                .frame(width: ButtonParameters.outerDiameter,
                       height: ButtonParameters.outerDiameter,
                       alignment: .center)
            Circle()
                .foregroundColor(Color.white)
                .frame(width: ButtonParameters.innerDiameter,
                       height: ButtonParameters.innerDiameter,
                       alignment: .center)
            Text(objCaptureViewModel.captureModeLetter)
                .font(.largeTitle)
                .foregroundColor(.black)
                .frame(width: ButtonParameters.innerDiameter,
                       height: ButtonParameters.innerDiameter,
                       alignment: .center)
        }
    }
}

