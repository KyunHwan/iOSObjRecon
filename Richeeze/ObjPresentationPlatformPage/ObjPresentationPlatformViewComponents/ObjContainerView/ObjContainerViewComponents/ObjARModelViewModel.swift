//
//  ObjARModelViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import Foundation
import SwiftUI
import RealityKit

@MainActor
final class ObjARViewModel: ObservableObject {
    let arView: ARView
    private var model: ModelEntity?
    private let anchor: AnchorEntity
    
    init() {
        arView = ARView(frame: .zero, cameraMode: ARView.CameraMode.nonAR, automaticallyConfigureSession: false)
        model = nil
        anchor = AnchorEntity(.camera)
    }
    
    func initConfigureModel(with modelPath: URL) {
        model = try? Entity.loadModel(contentsOf: modelPath)
        anchor.children.append(model!)
        
        arView.scene.anchors.append(anchor)
        arView.environment.background = ARView.Environment.Background.color(UIColor.clear)
    }
}
