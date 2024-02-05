//
//  FlashToggler.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct FlashSwitchButton: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    
    var body: some View {
        Button(action: {
            objCaptureViewModel.flashButtonPressed()
        }, label: {
            Label(FlashButtonParameters.label, systemImage: objCaptureViewModel.isFlashOn ? FlashButtonParameters.onLabel : FlashButtonParameters.offLabel)
                .labelStyle(.iconOnly)
                .foregroundColor(objCaptureViewModel.isFlashOn ? .green : .blue)
                .scaleEffect(FlashButtonParameters.buttonScaleEffect)
                .padding(FlashButtonParameters.buttonPadding)
        })
    }
    
    private struct FlashButtonParameters {
        static let label: String = "Flash"
        static let onLabel: String = "lightswitch.on"
        static let offLabel: String = "lightswitch.off"
        static let buttonScaleEffect: CGFloat = 4
        static let buttonPadding: CGFloat = 30
    }
}
