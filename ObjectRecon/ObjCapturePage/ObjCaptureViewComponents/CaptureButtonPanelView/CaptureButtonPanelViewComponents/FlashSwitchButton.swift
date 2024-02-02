//
//  FlashToggler.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct FlashSwitchButton: View {
    
    var body: some View {
        Button(action: {
            model.flashButtonPressed()
        }, label: {
            Label("Flash", systemImage: model.isFlashOn ? "lightswitch.on" : "lightswitch.off")
                .labelStyle(.iconOnly)
                .foregroundColor(model.isFlashOn ? .green : .blue)
                .scaleEffect(4)
                .padding(30)
        })
    }
}
