//
//  VisualEffectView.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/5/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class VisualEffectView: UIView {
    private let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlur()
    }
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
        setupBlur()
    }
    
    private func setupBlur() {
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurView)
    }
}


