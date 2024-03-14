//
//  FireModel3DView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by JunHyuk Yoon on 2/21/24.
//

import SwiftUI

struct FireModel3DView: View {
    var scanResultPath: String
    @State var filePathUrl: URL? = nil
    
//    init(scanResultPath: String, filePathUrl: URL? = nil, camera: PerspectiveCamera = PerspectiveCamera(fov: .degrees(30))) {
//        self.scanResultPath = scanResultPath
//        self.filePathUrl = filePathUrl
//        self.camera = camera
//        
//        print("ppppppppppppp")
//    }
    
    var body: some View {
        ZStack {
            Color("CheezeColor").edgesIgnoringSafeArea(.all)
            VStack {
                if let filePathUrl {
                    Model3DView(file: filePathUrl)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("3D Model View")
            .onAppear {
                Task {
                    do {
                        filePathUrl = try await StorageManager.shared.downloadToCacheFile(fireStoragePath: scanResultPath)
                    } catch {
                        print("Failed to downloadToCacheFile =\"\(scanResultPath)\" error=\(String(describing: error))")
                    }
                }
            }
        }
    }
}
