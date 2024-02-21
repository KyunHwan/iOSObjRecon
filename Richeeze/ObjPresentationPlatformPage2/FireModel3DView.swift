//
//  FireModel3DView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by JunHyuk Yoon on 2/21/24.
//

import SwiftUI
import Model3DView

struct FireModel3DView: View {
    var scanResultPath: String
    @State var filePathUrl: URL? = nil
    //@State var camera = OrthographicCamera()
    @State var camera = PerspectiveCamera(fov: .degrees(30))
    
//    init(scanResultPath: String, filePathUrl: URL? = nil, camera: PerspectiveCamera = PerspectiveCamera(fov: .degrees(30))) {
//        self.scanResultPath = scanResultPath
//        self.filePathUrl = filePathUrl
//        self.camera = camera
//        
//        print("ppppppppppppp")
//    }
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 153.0/255.0, blue: 0.0).edgesIgnoringSafeArea(.all)
            VStack {
                if let filePathUrl {
                    Model3DView(file: filePathUrl)
                    //.transform(rotate: Euler(y: .degrees(0)), scale: 0.5, translate: [0.0, 0, 0])
                        .transform(scale: 0.3)
                        .cameraControls(OrbitControls(camera: $camera, sensitivity: 0.5))
                } else {
                    ProgressView()
                }
            }
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
