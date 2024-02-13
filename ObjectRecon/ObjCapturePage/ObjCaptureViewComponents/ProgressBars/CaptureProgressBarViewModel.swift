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
import Combine

class CaptureProgressBarViewModel: ObservableObject {
    typealias ProgressElement = CaptureProgressBarModel.ProgressIndicator
    
    @Published private var photoCaptureTopProgressBar: CaptureProgressBarModel
    @Published private var photoCaptureCenterProgressBar: CaptureProgressBarModel
    @Published private var photoCaptureBottomProgressBar: CaptureProgressBarModel
    
    static let numPhotosPerIndicator: CGFloat = 2
    
    let photoCaptureNumBars: CGFloat = Constants.photoCaptureNumBars
    private let photoCaptureHRegionRange: Float = Constants.photoCaptureHRegionRange // in degrees
    private var photoCaptureHProgressIndicatorRange: Float { photoCaptureHRegionRange / Float(photoCaptureNumBars) }
    var halfPhotoCaptureNumBars: CGFloat { photoCaptureNumBars / 2 }
    
    private let numPhotoCaptureVRegions: CGFloat = Constants.numPhotoCaptureVRegions
    private let photoCaptureVRegionRange: Float = Constants.photoCaptureVRegionRange // in degrees
    private var photoCaptureVProgressIndicatorRange: Float { photoCaptureVRegionRange / Float(numPhotoCaptureVRegions) }
    
    var topProgressBar: Array<ProgressElement> { photoCaptureTopProgressBar.progressIndicators }
    var centerProgressBar: Array<ProgressElement> { photoCaptureCenterProgressBar.progressIndicators }
    var bottomProgressBar: Array<ProgressElement> { photoCaptureBottomProgressBar.progressIndicators }
    
    init(){
        self.photoCaptureTopProgressBar = CaptureProgressBarModel()
        self.photoCaptureCenterProgressBar = CaptureProgressBarModel()
        self.photoCaptureBottomProgressBar = CaptureProgressBarModel()
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
extension CaptureProgressBarViewModel {
    
    func refreshProgressBars() {
        self.photoCaptureTopProgressBar.refreshProgressBar()
        self.photoCaptureCenterProgressBar.refreshProgressBar()
        self.photoCaptureBottomProgressBar.refreshProgressBar()
        self.setupProgressBar()
    }
    
    // Function to update the progress of a bar based on the angle at which a photo was taken
    func updateProgressIndicator(ZRotation: Float, XRotation: Float) {
        // Only get the rotation around the z-axis (ie. vertical axis)
        let id = findHorizontalRegion(ZRotation: ZRotation)
        
        if Constants.numCaptureBars == 2 {
            updateTopBottom(XRotation: XRotation, id: id)
        } else {
            updateTopCenterBottom(XRotation: XRotation, id: id)
        }
    }
    
    private func findHorizontalRegion(ZRotation: Float) -> Float {
        var halfHRange: Float { (photoCaptureHRegionRange/2) }
        
        var id = ((ZRotation - 90 + halfHRange) / photoCaptureHProgressIndicatorRange).rounded(.down)
        if ZRotation < 90 - halfHRange { id = 0 }
        else if ZRotation > 90 + halfHRange { id = Float(photoCaptureNumBars) - 1 }
        
        return id
    }
    
    private func updateTopBottom(XRotation: Float, id: Float) {
        if XRotation > 90 {
            photoCaptureTopProgressBar.incrementProgress(for: Int(id))
        }
        else if 90 >= XRotation {
            photoCaptureBottomProgressBar.incrementProgress(for: Int(id))
        }
    }
    
    private func updateTopCenterBottom(XRotation: Float, id: Float) {
        if XRotation >= 95 {
            photoCaptureTopProgressBar.incrementProgress(for: Int(id))
        }
        else if 85 < XRotation && XRotation < 95 {
            photoCaptureCenterProgressBar.incrementProgress(for: Int(id))
        }
        else if 85 >= XRotation {
            photoCaptureBottomProgressBar.incrementProgress(for: Int(id))
        }
    }
}

extension CaptureProgressBarViewModel {
    private struct Constants {
        static let numCaptureBars: Int = 2
        
        static let numPhotosPerIndicator: CGFloat = 2
        static let photoCaptureNumBars: CGFloat = 20
        static let photoCaptureHRegionRange: Float = 60 // in degrees
        static let numPhotoCaptureVRegions: CGFloat = 3
        static let photoCaptureVRegionRange: Float = 9 // in degrees
    }
}
