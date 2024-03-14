
import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!
    
    var uniforms = Uniforms()
    var params = Params()
    
    init(metalView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        // create the shader function library
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction =
        library?.makeFunction(name: "fragment_main")
        
        // create the pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        depthStencilState = Renderer.buildDepthStencilState()
        super.init()
        metalView.clearColor = MTLClearColor(red: 1.0, green: 153.0/255.0, blue: 0.0, alpha: 1.0) // CheezeColor
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.depthStencilPixelFormat = .depth32Float
        
        //        metalView.preferredFramesPerSecond = 60
        //        metalView.isOpaque = true
        //        metalView.framebufferOnly = true
        //        metalView.drawableSize = metalView.frame.size
        //        metalView.enableSetNeedsDisplay = false
        //        metalView.contentMode = .scaleAspectFit
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(
            descriptor: descriptor)
    }
}

extension Renderer {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(scene: ModelScene, in view: MTKView) {
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        uniforms.viewMatrix = scene.viewMatrix
        uniforms.projectionMatrix = scene.projectionMatrix
        params.lightCount = UInt32(scene.lighting.lights.count)
        params.cameraPosition = scene.cameraPosition
        
//        renderEncoder.setFrontFacing(.clockwise)
//        renderEncoder.setCullMode(.back)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var lights = scene.lighting.lights
        renderEncoder.setFragmentBytes(&lights, length: MemoryLayout<Light>.stride * lights.count, index: LightBuffer.index)
        
        // ---------------------- update trackballMat -----------------------------
        /*
         var trackballQuat = scene.trackballQuat
        var matFromQuat = [Float](repeating: 0, count: 16)
        trackballQuat.withUnsafeMutableBufferPointer { trackQuatBufPointer in
            matFromQuat.withUnsafeMutableBufferPointer { matFromQuatBufPointer in
                build_rotmatrix(matFromQuatBufPointer.baseAddress, trackQuatBufPointer.baseAddress)
            }
        }
        var trackballMat = matrix_identity_float4x4 // column major
        for y in 0..<4 {
            for x in 0..<4 {
                trackballMat[y][x] = matFromQuat[4*y + x]
            }
        }
        */
        
        // MTEST : 왜 마지막에 transpose(inverse)해줘야 할까?
        let trackballQuat = scene.trackballQuat
        let trackballMat = simd_float4x4(simd_quatf(ix: trackballQuat[0], iy: trackballQuat[1], iz: trackballQuat[2], r: trackballQuat[3])).transpose
        
        for model in scene.models {
            params.tiling = model.tiling
            params.renderMode = model.renderMode
            uniforms.modelMatrix = trackballMat * model.transform.modelMatrix
            uniforms.normalMatrix = uniforms.modelMatrix.upperLeft
            
            renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: UniformsBuffer.index)
            renderEncoder.setFragmentBytes(&params, length: MemoryLayout<Params>.stride, index: ParamsBuffer.index)
            
            for mesh in model.meshes {
                for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
                }
                
                for submesh in mesh.submeshes {
                    renderEncoder.setFragmentTexture(submesh.textures.baseColor, index: BaseColor.index)
                    renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer, indexBufferOffset: submesh.indexBufferOffset
                    )
                }
            }
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
