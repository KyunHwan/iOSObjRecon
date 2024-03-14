//
//  Model.swift
//  Model3DView
//
//  Created by JunHyuk Yoon on 3/13/24.
//

import MetalKit
import SceneKit.ModelIO

class Model: Transformable {
    var transform = Transform()
    var meshes: [Mesh] = []
    var name: String = "Untitled"
    var tiling: UInt32 = 1
    var renderMode: UInt32 = 0
    var minBounds: vector_float3 = [ Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude]
    var maxBounds: vector_float3 = [ -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude]
    var boundScale: Float {
        (maxBounds.max() - minBounds.min())
    }
    var boundCenter: float3 {
        (minBounds + maxBounds) / 2.0
    }
    
    init() {}
    
    init(file: URL) {
        let assetURL = file
        
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayout, bufferAllocator: allocator)
        asset.loadTextures()
      
        // aaa
        guard let mdlMeshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh] else {
          fatalError()
        }
        
        let mtkMeshes = try! mdlMeshes.map { mdlMesh in
            
            // 노말벡터 가지고 있는지 체크.. (근데 MDLAsset 생성할때 이미 노멀요청해서 이건 무조건 가지고 있다..)
            //let hasNormals = mdlMesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeNormal) != nil
            
            // normal vector 없는 메쉬에만 적용하자!
            mdlMesh.addNormals(withAttributeNamed: MDLVertexAttributeNormal, creaseThreshold: 0.5)
            
            // 메쉬 여러 조각일 수 있으므로 다 합친 boundingBox 구하자!
            minBounds = simd_min(minBounds, mdlMesh.boundingBox.minBounds)
            maxBounds = simd_max(maxBounds, mdlMesh.boundingBox.maxBounds)
            
            return try MTKMesh(mesh: mdlMesh, device: Renderer.device)
        }
        //print("minBounds= \(minBounds)")
        //print("maxBounds= \(maxBounds)")
                
        //print("assetURL.description = \(assetURL.description)")
        //print("mdlMeshes.count = \(mdlMeshes.count)")
        //print("mtkMeshes.count = \(mtkMeshes.count)")
        
        meshes = zip(mdlMeshes, mtkMeshes).map {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        
        // mesh transform 적당히? 조절.
        if assetURL.pathExtension.lowercased() == "obj" {
            renderMode = 1 // no texture, color vertex
            transform.rotation = [0.0, Float.pi, 0.0]
        }
        if boundScale != 0.0 {
            transform.scale = 1.0 / boundScale
        }
        transform.position = -transform.scale * boundCenter
    }
    
    init(name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else {
            fatalError("Model: \(name) not found")
        }
        
        self.name = name
        
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayout, bufferAllocator: allocator)
        asset.loadTextures()
      
        // aaa
        guard let mdlMeshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh] else {
          fatalError()
        }
        
        let mtkMeshes = try! mdlMeshes.map { mdlMesh in
            
            // 노말벡터 가지고 있는지 체크.. (근데 MDLAsset 생성할때 이미 노멀요청해서 이건 무조건 가지고 있다..)
            //let hasNormals = mdlMesh.vertexAttributeData(forAttributeNamed: MDLVertexAttributeNormal) != nil
            
            // normal vector 없는 메쉬에만 적용하자!
            mdlMesh.addNormals(withAttributeNamed: MDLVertexAttributeNormal, creaseThreshold: 0.5)
            
            // 메쉬 여러 조각일 수 있으므로 다 합친 boundingBox 구하자!
            minBounds = simd_min(minBounds, mdlMesh.boundingBox.minBounds)
            maxBounds = simd_max(maxBounds, mdlMesh.boundingBox.maxBounds)
            
            return try MTKMesh(mesh: mdlMesh, device: Renderer.device)
        }
        //print("minBounds= \(minBounds)")
        //print("maxBounds= \(maxBounds)")
                
        //print("assetURL.description = \(assetURL.description)")
        //print("mdlMeshes.count = \(mdlMeshes.count)")
        //print("mtkMeshes.count = \(mtkMeshes.count)")
        
        meshes = zip(mdlMeshes, mtkMeshes).map {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        self.name = name
        
        // mesh transform 적당히? 조절.
        if assetURL.pathExtension.lowercased() == "obj" {
            renderMode = 1 // no texture, color vertex
            transform.rotation = [0.0, Float.pi, 0.0]
        }
        if boundScale != 0.0 {
            transform.scale = 1.0 / boundScale
        }
        transform.position = -transform.scale * boundCenter
    }
}

extension Model {
    func setTexture(name: String, type: TextureIndices) {
        if let texture = TextureController.loadTexture(name: name) {
            switch type {
            case BaseColor:
                meshes[0].submeshes[0].textures.baseColor = texture
            default: break
            }
        }
    }
}
