//
//  PageNavigationControllerView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct PageNavigationControllerView: View {
    var page: AppPage
    
    var body: some View {
        switch page {
        case .authentication:
            AuthenticationView(page: .authentication)//path: $path)
        case .instruction:
            ObjCaptureInstructionView(page: .instruction)//path: $path)
        case .photoCapture:
            ObjCaptureView(page: .photoCapture)//path: $path)
        case .reconPresentation:
            //ObjPresentationPlatformView()
            MyCapturesView()            
        }
    }
    
    static func pageTransition(from page: AppPage) -> AppPage {
        switch page {
        case .authentication:
            return .instruction
        case .instruction:
            return .photoCapture
        case .photoCapture:
            return .reconPresentation
        case .reconPresentation:
            return .instruction
        }
    }
}

enum AppPage: String {
    case instruction
    case authentication
    case photoCapture
    case reconPresentation
}

