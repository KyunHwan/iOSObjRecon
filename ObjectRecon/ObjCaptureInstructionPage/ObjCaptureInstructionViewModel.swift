//
//  ObjCaptureInstructionViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/1/24.
//

import Foundation
import AVKit

class ObjCaptureInstructionViewModel: ObservableObject {
    private(set) var avPlayerQueue: AVQueuePlayer
    private let avPlayerItem: AVPlayerItem
    private let avPlayerLooper: AVPlayerLooper
    
    init() {
        avPlayerItem = AVPlayerItem(url: Bundle.main.url(forResource: "ObjCaptureInstructionVid", withExtension: "mp4")!)
        avPlayerQueue = AVQueuePlayer(items: [avPlayerItem])
        avPlayerLooper = AVPlayerLooper(player: avPlayerQueue, templateItem: avPlayerItem)
    }
    
    func playInstructionVidInLoop() { avPlayerQueue.play() }
    
    func pauseInstructionVidInLoop() { avPlayerQueue.pause() }
}
