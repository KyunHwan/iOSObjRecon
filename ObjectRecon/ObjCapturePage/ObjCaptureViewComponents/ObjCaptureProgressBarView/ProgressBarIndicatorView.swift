//
//  ProgressBarIndicatorView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct ProgressBarIndicatorView: View {
    @ObservedObject var progressBarViewModel: ProgressBarViewModel
    
    let width: CGFloat
    let height: CGFloat
    let priority: Double
    let indicator: ProgressBarModel.ProgressIndicator
    
    let cornerRadius: CGFloat
    let alpha: CGFloat
    let beta: CGFloat
    let VPadding: Edge.Set
        
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(progressToColor(progress: CGFloat.minimum(indicator.progress, ProgressBarViewModel.numPhotosPerIndicator)))
            .frame(width: width/CGFloat(progressBarViewModel.photoCaptureNumBars*alpha),
                   height: height * (1 + CGFloat.minimum(indicator.progress, ProgressBarViewModel.numPhotosPerIndicator)/3) / 12,
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
              saturation: progress/ProgressBarViewModel.numPhotosPerIndicator,
              brightness: 1.0)
    }
    // Pick horizontal padding direction depending on the index of the progress bar
    private func paddingHDirection(indicatorId: CGFloat) -> Edge.Set {
        if indicatorId <= progressBarViewModel.photoCaptureNumBars/2 { return Edge.Set.trailing }
        else { return Edge.Set.leading }
    }
    // Calculate the horizontal padding length for each progress bar
    private func eachIndicatorHPaddingLength(indicatorId: CGFloat) -> CGFloat {
        if indicatorId == progressBarViewModel.photoCaptureNumBars/2 || 
           indicatorId - 1 == progressBarViewModel.photoCaptureNumBars/2 {
            return 0.5 * beta * indicatorId / progressBarViewModel.photoCaptureNumBars
        }
        else if indicatorId <= progressBarViewModel.photoCaptureNumBars/2 {
            return beta * indicatorId / progressBarViewModel.photoCaptureNumBars
        }
        else {
            return beta * (progressBarViewModel.photoCaptureNumBars - indicatorId + 1)/progressBarViewModel.photoCaptureNumBars
        }
    }
    // Calculate the vertical padding length for each progress bar
    private func eachIndicatorVPaddingLength(indicatorId: CGFloat) -> CGFloat {
        if indicatorId <= progressBarViewModel.photoCaptureNumBars/2 {
            return beta*(progressBarViewModel.photoCaptureNumBars - indicatorId + 1)/progressBarViewModel.photoCaptureNumBars
        }
        else {
            return beta * indicatorId / progressBarViewModel.photoCaptureNumBars
        }
    }
}
