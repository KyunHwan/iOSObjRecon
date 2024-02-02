//
//  SwiftUIView.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    @StateObject private var progressBarViewModel: ProgressBarViewModel = ProgressBarViewModel()
    @EnvironmentObject var objCaptureViewModel: ObjCaptureViewModel
    @EnvironmentObject var arModelManager: ARModelManager
    
    let width: CGFloat
    let height: CGFloat
    let priority: Double
    let progressBarLocation: ProgressBarViewModel.ProgressBarLocation
    
    private let cornerRadius: CGFloat = 2.0
    
    // Parameters
    private let alpha: CGFloat = 3
    private var beta: CGFloat { 8*((alpha-1)/alpha)*width / ((progressBarViewModel.photoCaptureNumBars + 2)*0.7*alpha) }

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
                                             priority: priority,
                                             indicator: indicator,
                                             cornerRadius: cornerRadius, 
                                             alpha: alpha,
                                             beta: beta,
                                             VPadding: VPadding)
                }
            }
        }
    }
}
