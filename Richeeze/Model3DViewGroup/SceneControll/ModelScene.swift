//
//  ModelScene.swift
//  Model3DView
//
//  Created by JunHyuk Yoon on 3/13/24.
//

import MetalKit

struct ModelScene {
    var models: [Model] = []
    
    var magnifyScale: Float = 1.0
    var trackballQuat: Array<Float> = [0.0, 0.0, 0.0, 1.0]
    var viewMatrix: matrix_float4x4 = matrix_identity_float4x4
    var projectionMatrix: matrix_float4x4 = matrix_identity_float4x4
    
    var cameraPosition: float3 = [0, 0, -30.0] 
    let lighting = SceneLighting()
    
    init() {
    }
    
    mutating func loadModel(named: String) {
        models = [Model(name: named)] // 우선 싱글모델만 지원.
    }
    
    mutating func loadModel(file: URL) {
        models = [Model(file: file)] // 우선 싱글모델만 지원.
    }
    
    mutating func update(size: CGSize) {
        
        let aspectRatio = Float(size.width / size.height)
        
        // MTEST
        let target: float3 = [0, 0, 0]
        viewMatrix = float4x4(eye: cameraPosition, center: target, up: [0, 1, 0])
        let fov = Float(30).degreesToRadians
        let near: Float = 0.1
        let far: Float = 100
        projectionMatrix = float4x4(projectionFov: fov, near: near, far: far, aspect: aspectRatio)

        //print("viewMatrix = \(viewMatrix)")
        
//        viewMatrix = matrix_identity_float4x4
//        let canvasWidth: Float = 8.0
//        let canvasHeight = canvasWidth / aspectRatio
//        projectionMatrix = float4x4(orthographicWithLeft: -canvasWidth / 2,
//                                        top: canvasHeight / 2,
//                                        right: canvasWidth / 2,
//                                        bottom: -canvasHeight / 2,
//                                        near: -10,
//                                        far: 10)
    }
}
