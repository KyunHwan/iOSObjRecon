//
//  ResetARModelOrientationButton.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct ResetARModelOrientationButton: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    @ObservedObject var arModelManager: ARModelManager
    
    var frameWidth: CGFloat
    
    var body: some View {
        Button(action: {
            withAnimation {
                arModelManager.resetInitialOrientation(using: objCaptureViewModel.deviceOrientation)
            }
        }, label: {
            ZStack {
                Circle()
                    .frame(width: ButtonParameters.backingDiameter,
                           height: ButtonParameters.backingDiameter)
                    .foregroundColor(Color.white)
                    .opacity(ButtonParameters.buttonBackingOpacity)
                Circle()
                    .frame(width: ButtonParameters.toggleDiameter,
                           height: ButtonParameters.toggleDiameter)
                    .foregroundColor(Color.white)
                Text("R")
                    .foregroundColor(Color.black)
                    .frame(width: ButtonParameters.toggleDiameter,
                           height: ButtonParameters.toggleDiameter,
                           alignment: .center)
            }
        })
        .frame(width: frameWidth, height: ButtonParameters.backingDiameter, alignment: .top)
    }
}
