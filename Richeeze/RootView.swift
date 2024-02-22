//
//  RootView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

enum AppPage: String {
    case instruction
    case photoCapture
    case reconPresentation
}

struct RootView: View {
    @StateObject var auth = AuthenticationHelper()
    
    var body: some View {
        ZStack {
            NavigationStack {
                AuthenticationView()
            }
            .environmentObject(auth)
        }
        .task {
            // TODO: Check for log in
            auth.checkSignedIn()
        }
        .fullScreenCover(isPresented: $auth.signedIn) {
            NavigationStack{
                ObjCaptureInstructionView()
                    .navigationDestination(for: AppPage.self) { page in
                        switch page {
                        case .instruction:
                            ObjCaptureInstructionView()
                        case .photoCapture:
                            ObjCaptureView()
                        case .reconPresentation:
                            //ObjPresentationPlatformView()
                            MyCapturesView()
                        }
                    }
                    .navigationDestination(for: Scan.self) { scan in
                        if let scanResultPath = scan.scanResultPath {
                            FireModel3DView(scanResultPath: scanResultPath)
                        }
                    }
            }
            .environmentObject(auth)
        }
    }
}
