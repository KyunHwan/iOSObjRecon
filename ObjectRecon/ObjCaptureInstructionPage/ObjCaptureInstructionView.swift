//
//  ObjCaptureInstructionView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/1/24.
//

import SwiftUI
import AVKit

struct ObjCaptureInstructionView: View {
    @StateObject private var objCaptureInstVid = ObjCaptureInstructionViewModel()
    var page: AppPage
    
    var body: some View {
        ZStack {
            VideoPlayer(player: objCaptureInstVid.avPlayerQueue)
                .onAppear {
                    objCaptureInstVid.playInstructionVidInLoop()
                }
                .onDisappear {
                    objCaptureInstVid.pauseInstructionVidInLoop()
                }
            VStack {
                Spacer()
                NavigationLink {
                    PageNavigationControllerView(page: PageNavigationControllerView.pageTransition(from: page))
                } label: {
                    Text("Start")
                        .frame(maxWidth: ButtonConstants.infoWindowMaxWidth)
                        .frame(height: ButtonConstants.infoWindowHeight)
                        .background(ButtonConstants.backgroundColor)
                        .foregroundStyle(ButtonConstants.fontColor)
                        .cornerRadius(ButtonConstants.cornerRadius)
                        .padding()
                }
            }
        }
    }
}

// MARK: Constants {
extension ObjCaptureInstructionView {
    private struct ButtonConstants {
        static let infoWindowMaxWidth: CGFloat = .infinity
        static let infoWindowHeight: CGFloat = 55
        static let backgroundColor: Color = .blue
        static let fontColor: Color = .white
        static let cornerRadius: CGFloat = 10
    }
}
