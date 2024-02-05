//
//  ProgressBarViewModel.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI
import Foundation
import RealityKit

class ProgressBarViewModel: ObservableObject {
    typealias ProgressElement = ProgressBarModel.ProgressIndicator
    
    @Published private var photoCaptureTopProgressBar: ProgressBarModel
    @Published private var photoCaptureCenterProgressBar: ProgressBarModel
    @Published private var photoCaptureBottomProgressBar: ProgressBarModel
    
    static let numPhotosPerIndicator: CGFloat = 2
    
    let photoCaptureNumBars: CGFloat = 20
    private let photoCaptureHRegionRange: Float = 60 // in degrees
    private var photoCaptureHProgressIndicatorRange: Float { photoCaptureHRegionRange / Float(photoCaptureNumBars) }
    
    private let numPhotoCaptureVRegions: CGFloat = 3
    private let photoCaptureVRegionRange: Float = 9 // in degrees
    private var photoCaptureVProgressIndicatorRange: Float { photoCaptureVRegionRange / Float(numPhotoCaptureVRegions) }
    
    var topProgressBar: Array<ProgressElement> { photoCaptureTopProgressBar.progressIndicators }
    var centerProgressBar: Array<ProgressElement> { photoCaptureCenterProgressBar.progressIndicators }
    var bottomProgressBar: Array<ProgressElement> { photoCaptureBottomProgressBar.progressIndicators }
    
    init(){
        self.photoCaptureTopProgressBar = ProgressBarModel()
        self.photoCaptureCenterProgressBar = ProgressBarModel()
        self.photoCaptureBottomProgressBar = ProgressBarModel()
        setupProgressBar()
    }
    
    // Setup the progress bar
    private func setupProgressBar() {
        for regionIndex in 1...Int(photoCaptureNumBars) {
            photoCaptureTopProgressBar.addProgressIndicator(id: regionIndex, progress: 0.0)
            photoCaptureCenterProgressBar.addProgressIndicator(id: regionIndex, progress: 0.0)
            photoCaptureBottomProgressBar.addProgressIndicator(id: regionIndex, progress: 0.0)
        }
    }
    
    enum ProgressBarLocation {
        case top
        case center
        case bottom
    }
}

// Updating the progress bar
extension ProgressBarViewModel {
    // Function to update the progress of a bar based on the angle at which a photo was taken
    func updateProgressIndicator(ZRotation: Float, XRotation: Float) {
        // Only get the rotation around the z-axis (ie. vertical axis)
        
        var halfHRange: Float { (photoCaptureHRegionRange/2) }
        
        var id = ((ZRotation - 90 + halfHRange) / photoCaptureHProgressIndicatorRange).rounded(.down)
        if ZRotation < 90 - halfHRange { id = 0 }
        else if ZRotation > 90 + halfHRange { id = Float(photoCaptureNumBars) - 1 }
        // Calculate Yaw
        //print("XRotation: \(XRotation)")
        //var halfVRange: Float { (photoCaptureVRegionRange/2) }
        //if XRotation < 90 - halfVRange || XRotation > 90 + halfVRange { return }
        //let location = Int(((XRotation - 90 + halfVRange) / photoCaptureVProgressIndicatorRange).rounded(.down))
        
        if XRotation >= 95 {
            photoCaptureTopProgressBar.incrementProgress(for: Int(id))
        }
        
        else if 85 < XRotation && XRotation < 95 {
            photoCaptureCenterProgressBar.incrementProgress(for: Int(id))
        }
        else if 85 >= XRotation {
            photoCaptureBottomProgressBar.incrementProgress(for: Int(id))
        }
        /*
         if XRotation > 90 + photoCaptureVProgressIndicatorRange {
             photoCaptureTopProgressBar.incrementProgress(for: Int(id))
         }
        else if 90 - photoCaptureVProgressIndicatorRange <= XRotation && XRotation <= 90 + photoCaptureVProgressIndicatorRange {
            photoCaptureCenterProgressBar.incrementProgress(for: Int(id))
        }
        
        else if 90 - photoCaptureVProgressIndicatorRange > XRotation {
            photoCaptureBottomProgressBar.incrementProgress(for: Int(id))
        }*/
    }
}
