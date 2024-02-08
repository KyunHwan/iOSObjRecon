//
//  PageNavigationControllerView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct PageNavigationControllerView: View {
    //@Binding var path: [AppPage]
    var page: AppPage
    
    var body: some View {
        switch page {
        case .instruction:
            ObjCaptureInstructionView(page: .instruction)//path: $path)
        case .authentication:
            ObjCaptureInstructionView(page: .instruction)//path: $path)
        case .photoCapture:
            ObjCaptureView(page: .photoCapture)//path: $path)
        case .reconPresentation:
            ObjPresentationPlatformView()
        }
    }
    
    static func pageTransition(from page: AppPage) -> AppPage {
        switch page {
        case .instruction:
            return .photoCapture
        case .authentication:
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
