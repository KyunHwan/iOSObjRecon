//
//  ContentView.swift
//  RealityKitPlayground
//
//  Created by Kyun Hwan  Kim on 11/30/23.
//

import SwiftUI
import RealityKit

struct ARModelPresentationView: UIViewRepresentable {
    @EnvironmentObject private var arModelManager: ARModelManager
    @Binding var deviceOrientation: simd_quatf
    
    func makeUIView(context: Context) -> ARView {
        arModelManager.initConfigureModel()
        return arModelManager.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = uiView.scene.anchors[0].children.first as? ModelEntity {
            
            model.orientation = arModelManager.modelOrientation(using: deviceOrientation)
        }
    }
}
