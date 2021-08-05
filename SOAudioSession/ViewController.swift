//
//  ViewController.swift
//  SOAudioSession
//
//  Created by Wl Alili on 2021/7/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var  audioPlayer: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SOAudioSession.shared.preferredSampleRate = 44100.0
        SOAudioSession.shared.active = true
        SOAudioSession.shared.addRouteChangeListener()
        SOAudioSession.shared.addAudioSessionInterruptedListener()
        SOAudioSession.shared.delegate = self
        SOAudioSession.shared.interruption = self
        startAudio()
    }
    
    func startAudio() {
        if audioPlayer == nil {
            let url = Bundle.main.url(forResource: "output", withExtension: "m4a")
            if let url = url {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                } catch let error {
                    print("Unable to initialize player \(error.localizedDescription)")
                }
            }
            audioPlayer?.numberOfLoops = 1
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func resumeAudio() {
        audioPlayer?.play()
    }
}

extension ViewController: SOAVAudioSessionRouteDelegate {
    func currentRouteType(audioSession: SOAudioSession, routeType: SORouteType) {
        print("audioSession == \(audioSession)")
        print("routeType == \(routeType)")
    }
}

extension ViewController: SOAVAudioSessionInterruptionDelegate{
    func interruptionType(audioSession: SOAudioSession, type: SOInterruptionType) {
        print("audioSession == \(audioSession)")
        print("routeType == \(type)")
    }
}
