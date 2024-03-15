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
    @State private var modelCtr: ModelController?
    //var named: String?
    var file: URL?
    
    var body: some View {
        GeometryReader { reader in
            var lastPos: CGPoint = .zero
            var lastMagnification: Float = 1.0
            var isFirst = true
            
            Model3DViewRepresentable(metalView: $metalView)
                .onAppear {
                    modelCtr = ModelController(metalView: metalView)
                    if let file {
                        modelCtr?.loadModel(file: file)
                    }
                    isFirst = true
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if isFirst {
                                isFirst = false
                            } else {
                                modelCtr?.scene.updateQuat(viewSize: reader.size, lastPos: lastPos, curPos: value.location)
                            }
                            lastPos = value.location
                        }
                        .onEnded { value in
                            isFirst = true
                        })
                .gesture(
                    MagnifyGesture()
                        .onChanged{ value in
                            if let modelCtr {
                                modelCtr.scene.magnifyScale = lastMagnification * Float(value.magnification)
                            }
                        }
                        .onEnded {_ in
                            if let modelCtr {
                                lastMagnification = modelCtr.scene.magnifyScale
                            }
                        })
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


