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
                    .frame(width: ButtonViewParameters.backingDiameter,
                           height: ButtonViewParameters.backingDiameter)
                    .foregroundColor(Color.white)
                    .opacity(ButtonViewParameters.buttonBackingOpacity)
                Circle()
                    .frame(width: ButtonViewParameters.toggleDiameter,
                           height: ButtonViewParameters.toggleDiameter)
                    .foregroundColor(Color.white)
                Text("R")
                    .foregroundColor(Color.black)
                    .frame(width: ButtonViewParameters.toggleDiameter,
                           height: ButtonViewParameters.toggleDiameter,
                           alignment: .center)
            }
        })
        .frame(width: frameWidth, height: ButtonViewParameters.backingDiameter, alignment: .top)
    }
}
