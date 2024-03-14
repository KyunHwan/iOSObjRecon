//
//  Model3DView.swift
//  Model3DView
//
//  Created by JunHyuk Yoon on 3/7/24.
//

import SwiftUI
import MetalKit
import Metal

struct Model3DView: View {
    @State private var metalView = MTKView()
    @State private var modelController: ModelController?
    //var named: String?
    var file: URL?
    
    var body: some View {
        GeometryReader { reader in
            var lastPos: CGPoint = .zero
            var isFirst = true
            
            Model3DViewRepresentable(metalView: $metalView)
                .onAppear {
                    modelController = ModelController(metalView: metalView)
                    if let file {
                        modelController?.loadModel(file: file)
                    }
                    isFirst = true
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if isFirst {
                                isFirst = false
                            } else {
                                //let _ = print("w: \(reader.size.width), h: \(reader.size.height)")
                                let lastX = 2.0 * (Float(lastPos.x) / Float(reader.size.width)) - 1.0
                                let lastY = 2.0 * (Float(reader.size.height - lastPos.y) / Float(reader.size.height)) - 1.0
                                let curX = 2.0 * (Float(value.location.x) / Float(reader.size.width)) - 1.0
                                let curY = 2.0 * (Float(reader.size.height - value.location.y) / Float(reader.size.height)) - 1.0
                                //let _ = print("     curX: \(curX), curY: \(curY)")
                                
                                var curQuat: Array<Float> = [0, 0, 0, 0]
                                modelController?.scene.trackballQuat.withUnsafeMutableBufferPointer { trackQuatPointer in
                                    curQuat.withUnsafeMutableBufferPointer { curQuatPointer in
                                        trackball(curQuatPointer.baseAddress, lastX, lastY, curX, curY)
                                        add_quats(curQuatPointer.baseAddress, trackQuatPointer.baseAddress, trackQuatPointer.baseAddress)
                                    }
                                }
                            }
                            lastPos = value.location
                        }
                        .onEnded { value in
                            isFirst = true
                        }
                )
        }
    }
}

struct Model3DViewRepresentable: UIViewRepresentable {
    @Binding var metalView: MTKView
    
    func makeUIView(context: Context) -> MTKView {
        metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
    }
    
}


