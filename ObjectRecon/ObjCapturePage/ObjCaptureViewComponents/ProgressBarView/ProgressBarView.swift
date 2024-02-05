//
//  SwiftUIView.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    @StateObject private var progressBarViewModel = ProgressBarViewModel()
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    @ObservedObject var arModelManager: ARModelManager
    @State private var numPhotosTaken: UInt32 {
        willSet {
            progressBarViewModel.updateProgressIndicator(ZRotation: arModelManager.relativeZOrientation(using: objCaptureViewModel.deviceOrientation),
                                                         XRotation: arModelManager.relativeXOrientation(using: objCaptureViewModel.deviceOrientation))
        }
    }
    
    let width: CGFloat
    let height: CGFloat
    let progressBarLocation: ProgressBarViewModel.ProgressBarLocation
    
    init(objCaptureViewModel: ObjCaptureViewModel, arModelManager: ARModelManager,
         width: CGFloat, height: CGFloat, progressBarLocation: ProgressBarViewModel.ProgressBarLocation) {
        self.arModelManager = arModelManager
        self.objCaptureViewModel = objCaptureViewModel
        self.numPhotosTaken = objCaptureViewModel.numPhotosTaken
        
        self.width = width
        self.height = height
        self.progressBarLocation = progressBarLocation
    }
    
    private var progressBar: Array<ProgressBarModel.ProgressIndicator> {
        switch progressBarLocation {
        case .top: progressBarViewModel.topProgressBar
        case .center: progressBarViewModel.centerProgressBar
        case .bottom: progressBarViewModel.bottomProgressBar
        }
    }
    
    private var VPadding: Edge.Set {
        switch progressBarLocation {
        case .top: [.top]
        case .center: []
        case .bottom: [.bottom]
        }
    }
    
    var body: some View {
        HStack(spacing:0.0){
            ForEach(progressBar) { indicator in
                VStack{
                    ProgressBarIndicatorView(progressBarViewModel: progressBarViewModel,
                                             width: width, 
                                             height: height,
                                             indicator: indicator,
                                             VPadding: VPadding)
                }
            }
        }
    }
}
