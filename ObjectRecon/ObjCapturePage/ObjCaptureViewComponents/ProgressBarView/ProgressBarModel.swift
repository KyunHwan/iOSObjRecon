//
//  ProgressBarModel.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/14/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct ProgressBarModel {
    // Array of objects that each indicate the degree of photo capture completion
    private(set) var progressIndicators: Array<ProgressIndicator>
    
    init() {
        progressIndicators = []
    }
    
    mutating func incrementProgress(for id: Int) { progressIndicators[id].progress += 1 }
    
    mutating func addProgressIndicator(id: Int, progress: CGFloat) {
        progressIndicators.append(ProgressIndicator(id: id, progress: progress))
    }
    
    struct ProgressIndicator: Identifiable {
        var id: Int
        var progress: CGFloat
    }
}
