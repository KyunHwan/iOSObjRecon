//
//  ObjARModelView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import SwiftUI
import RealityKit


struct ObjARModelView: UIViewRepresentable {
    @StateObject private var vm = ObjARViewModel()
    let modelPath: URL
    
    func makeUIView(context: Context) -> ARView {
        vm.initConfigureModel(with: modelPath)
        return vm.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // TODO: Gesture to move obj model
    }
}
