//
//  ModelController.swift
//  Model3DView
//
//  Created by JunHyuk Yoon on 3/13/24.
//

import MetalKit

class ModelController: NSObject {
    var scene: ModelScene
    var renderer: Renderer
    
    init(metalView: MTKView) {
        renderer = Renderer(metalView: metalView)
        scene = ModelScene()
        super.init()
        metalView.delegate = self
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
    
    func loadModel(named: String) {
        scene.loadModel(named: named)
    }
    
    func loadModel(file: URL) {
        scene.loadModel(file: file)
    }
}

extension ModelController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
        renderer.mtkView(view, drawableSizeWillChange: size)
    }
    
    func draw(in view: MTKView) {
        renderer.draw(scene: scene, in: view)
    }
}
