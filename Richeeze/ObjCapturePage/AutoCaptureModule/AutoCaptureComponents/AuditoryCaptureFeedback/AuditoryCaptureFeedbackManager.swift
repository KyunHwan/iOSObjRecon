//
//  SoundManager.swift
//  CaptureSample
//
//  Created by Kyun Hwan  Kim on 12/7/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import AVKit

class AuditoryCaptureFeedbackManager {
    private var musicPlayer: AVAudioPlayer?
    private let audioSession: AVAudioSession
    init() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord) // Plays on iPhone mode instead of speaker mode
            try audioSession.setPrefersNoInterruptionsFromSystemAlerts(true)
            try audioSession.setActive(true)
        } catch let error {
            print("\(error.localizedDescription) happened while initializing AVAudioSession")
        }
        
        guard let songURL = Bundle.main.url(forResource: "pororo", withExtension: "mp3") else { return }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: songURL)
            musicPlayer?.numberOfLoops = -1 // Loop indefinitely
        } catch let error {
            musicPlayer = nil
            print("\(error.localizedDescription) happened while initializing AVAudioPlayer")
        }
    }
    
    func playSound() {
        musicPlayer?.play()
    }
    
    func pauseSound() {
        musicPlayer?.pause()
    }
    
    func prepareToPlay() {
        musicPlayer?.prepareToPlay()
    }
    
    func stopSound() {
        musicPlayer?.stop()
    }
    func isPlaying() -> Bool? {
        return musicPlayer?.isPlaying
    }
}
