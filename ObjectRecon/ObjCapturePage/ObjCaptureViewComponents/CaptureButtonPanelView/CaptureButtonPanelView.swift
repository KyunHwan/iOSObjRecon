//
//  CaptureButtonPanelView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct CaptureButtonPanelView: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    @ObservedObject var arModelManager: ARModelManager
    
    /// This property stores the full width of the bar. The view uses this to place items.
    var width: CGFloat
    
    var body: some View {
        // Add the bottom panel, which contains the thumbnail and capture button.
        ZStack(alignment: .center) {
            HStack {
                FlashSwitchButton(objCaptureViewModel: objCaptureViewModel)
                    .frame(width: width / 3)
                    .padding(Edge.Set.horizontal)
                Spacer()
            }
            HStack {
                Spacer()
                CaptureButton(objCaptureViewModel: objCaptureViewModel, arModelManager: arModelManager)
                Spacer()
            }
            HStack {
                Spacer()
                ResetARModelOrientationButton(objCaptureViewModel: objCaptureViewModel,
                                              arModelManager: arModelManager,
                                              frameWidth: width / 3)
                    .padding(Edge.Set.horizontal)
            }
        }
    }
}


#Preview {
    CaptureButtonPanelView(objCaptureViewModel: ObjCaptureViewModel(),
                           arModelManager: ARModelManager(),
                           width: 3)
}

