//
//  ResetARModelOrientationButton.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct ResetARModelOrientationButton: View {
    @EnvironmentObject var arModelManager: ARModelManager
    
    var frameWidth: CGFloat
    
    var body: some View {
        Button(action: {
            withAnimation {
                arModelManager.resetInitialOrientation(using: objCaptureViewModel.deviceOrientation)
            }
        }, label: {
            ZStack {
                Circle()
                    .frame(width: CaptureModeButton.backingDiameter,
                           height: CaptureModeButton.backingDiameter)
                    .foregroundColor(Color.white)
                    .opacity(Double(CameraView.buttonBackingOpacity))
                Circle()
                    .frame(width: CaptureModeButton.toggleDiameter,
                           height: CaptureModeButton.toggleDiameter)
                    .foregroundColor(Color.white)
                Text("R")
                    .foregroundColor(Color.black)
                    .frame(width: CaptureModeButton.toggleDiameter,
                           height: CaptureModeButton.toggleDiameter,
                           alignment: .center)
            }
        })
        .frame(width: frameWidth, height: CaptureModeButton.backingDiameter, alignment: .top)
    }
}

#Preview {
    ResetARModelOrientationButton()
}
