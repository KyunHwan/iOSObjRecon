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
    
    var body: some View {
        VideoPlayer(player: objCaptureInstVid.avPlayerQueue)
            .onAppear {
                objCaptureInstVid.playInstructionVidInLoop()
            }
            .onDisappear {
                objCaptureInstVid.pauseInstructionVidInLoop()
            }
    }
}

#Preview {
    ObjCaptureInstructionView()
}
