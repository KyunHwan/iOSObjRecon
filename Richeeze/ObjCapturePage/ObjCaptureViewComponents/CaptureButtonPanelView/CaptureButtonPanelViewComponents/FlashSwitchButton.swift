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
//            Label(FlashButtonParameters.label, systemImage: objCaptureViewModel.isFlashOn ? FlashButtonParameters.onLabel : FlashButtonParameters.offLabel)
//                .labelStyle(.iconOnly)
//                //.foregroundColor(objCaptureViewModel.isFlashOn ? .green : .blue)
//                .foregroundColor(objCaptureViewModel.isFlashOn ? Color("SecondaryAccentColor") : Color("BluePurpleColor"))
//                .scaleEffect(FlashButtonParameters.buttonScaleEffect)
//                .padding(FlashButtonParameters.buttonPadding)
            
            Image(systemName: objCaptureViewModel.isFlashOn ? FlashButtonParameters.onLabel : FlashButtonParameters.offLabel)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .background(
                    Circle()
                        .fill(
                            .linearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 70, height: 70)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0.0, y: 6)
                )
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
