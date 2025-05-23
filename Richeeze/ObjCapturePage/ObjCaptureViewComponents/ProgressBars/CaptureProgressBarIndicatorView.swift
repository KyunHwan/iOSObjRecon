//
//  ProgressBarIndicatorView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct CaptureProgressBarIndicatorView: View {
    @ObservedObject var progressBarViewModel: CaptureProgressBarViewModel
    
    let width: CGFloat
    let height: CGFloat
    let indicator: CaptureProgressBarModel.ProgressIndicator
    let VPadding: Edge.Set
    
    // Parameters
    private let alpha: CGFloat = 3
    private var beta: CGFloat { 8*((alpha-1)/alpha)*width / ((progressBarViewModel.photoCaptureNumBars + 2)*0.7*alpha) }
    private let cornerRadius: CGFloat = 2.0
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(progressToColor(progress: CGFloat.minimum(indicator.progress, CaptureProgressBarViewModel.numPhotosPerIndicator)))
            .frame(width: width/CGFloat(progressBarViewModel.photoCaptureNumBars*alpha),
                   height: height * (1 + CGFloat.minimum(indicator.progress, CaptureProgressBarViewModel.numPhotosPerIndicator)/3) / 12,
                   alignment: .bottom)
            .padding([paddingHDirection(indicatorId: CGFloat(indicator.id))], 
                     eachIndicatorHPaddingLength(indicatorId: CGFloat(indicator.id)))
            .padding(VPadding, 
                     eachIndicatorVPaddingLength(indicatorId: CGFloat(indicator.id)))
            .animation(.linear(duration: 0.25), 
                       value: indicator.progress)
    }
    // Map progress value to color value
    private func progressToColor(progress: CGFloat) -> Color {
        Color(hue: 0.33, 
              saturation: progress/CaptureProgressBarViewModel.numPhotosPerIndicator,
              brightness: 1.0)
    }
    // Pick horizontal padding direction depending on the index of the progress bar
    private func paddingHDirection(indicatorId: CGFloat) -> Edge.Set {
        if indicatorId <= progressBarViewModel.halfPhotoCaptureNumBars { return Edge.Set.trailing }
        else { return Edge.Set.leading }
    }
    // Calculate the horizontal padding length for each progress bar
    private func eachIndicatorHPaddingLength(indicatorId: CGFloat) -> CGFloat {
        if indicatorId == progressBarViewModel.halfPhotoCaptureNumBars ||
           indicatorId - 1 == progressBarViewModel.halfPhotoCaptureNumBars {
            return 0.5 * beta * indicatorId / progressBarViewModel.photoCaptureNumBars
        }
        else if indicatorId <= progressBarViewModel.halfPhotoCaptureNumBars {
            return beta * indicatorId / progressBarViewModel.photoCaptureNumBars
        }
        else {
            return beta * (progressBarViewModel.photoCaptureNumBars - indicatorId + 1)/progressBarViewModel.photoCaptureNumBars
        }
    }
    // Calculate the vertical padding length for each progress bar
    private func eachIndicatorVPaddingLength(indicatorId: CGFloat) -> CGFloat {
        if indicatorId <= progressBarViewModel.halfPhotoCaptureNumBars {
            return beta*(progressBarViewModel.photoCaptureNumBars - indicatorId + 1)/progressBarViewModel.photoCaptureNumBars
        }
        else {
            return beta * indicatorId / progressBarViewModel.photoCaptureNumBars
        }
    }
}
