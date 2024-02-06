//
//  SwiftUIView.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI
import Combine

struct ProgressBarView: View {
    @StateObject private var progressBarViewModel = ProgressBarViewModel()
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    @ObservedObject var arModelManager: ARModelManager
        
    let width: CGFloat
    let height: CGFloat
    let progressBarLocation: ProgressBarViewModel.ProgressBarLocation
    
    init(objCaptureViewModel: ObjCaptureViewModel, arModelManager: ARModelManager,
         width: CGFloat, height: CGFloat, progressBarLocation: ProgressBarViewModel.ProgressBarLocation) {
        self.arModelManager = arModelManager
        self.objCaptureViewModel = objCaptureViewModel
        
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
                .onChange(of: objCaptureViewModel.numPhotosTaken) 
                {
                    if objCaptureViewModel.numPhotosTaken == 0 {
                        progressBarViewModel.refreshProgressBars()
                    } else {
                        progressBarViewModel.updateProgressIndicator(ZRotation: arModelManager.relativeZOrientation(using: objCaptureViewModel.deviceOrientation),
                                                                     XRotation: arModelManager.relativeXOrientation(using: objCaptureViewModel.deviceOrientation))
                    }
                }
            }
        }
    }
}
