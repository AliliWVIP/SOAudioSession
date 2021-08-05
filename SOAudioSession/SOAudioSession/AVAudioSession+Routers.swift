//
//  AVAudioSession+Routers.swift
//  SOAudioSession
//
//  Created by Wl Alili on 2021/7/20.
//

import AVFoundation

extension AVAudioSession{
    /// 使用蓝牙
    func usingBlueTooth() -> Bool {
        let inputs = self.currentRoute.inputs
        let blueToothInputRoutes = [AVAudioSession.Port.bluetoothHFP]
        for description in inputs {
            if blueToothInputRoutes.contains(description.portType) {
                return true
            }
        }
        
        let outputs = self.currentRoute.outputs
        let blueToothOutputRoutes =  [AVAudioSession.Port.bluetoothHFP, AVAudioSession.Port.bluetoothA2DP, AVAudioSession.Port.bluetoothLE]
        for description in outputs {
            if blueToothOutputRoutes.contains(description.portType) {
                return true
            }
        }
        return false
    }
    /// 使用麦克风
    func usingWiredMicrophone() -> Bool {
        let inputs = self.currentRoute.inputs
        let headSetInputRoutes = [AVAudioSession.Port.headsetMic]
        for description in inputs {
            if headSetInputRoutes.contains(description.portType) {
                return true
            }
        }
        let outputs = self.currentRoute.outputs
        let headSetOutputRoutes = [AVAudioSession.Port.headphones, AVAudioSession.Port.usbAudio]
        for description in outputs {
            if headSetOutputRoutes.contains(description.portType) {
                return true
            }
        }
        return false
    }
    /// 使用耳机
    func shouldShowEarphoneAlert() -> Bool {
        //用户如果没有带耳机，则应该提出提示，目前采用保守策略，即尽量减少alert弹出，所以，我们认为只要不是用手机内置的听筒或者喇叭作为声音外放的，都认为用户带了耳机
        let outputs = self.currentRoute.outputs
        let headSetOutputRoutes = [AVAudioSession.Port.builtInReceiver, AVAudioSession.Port.builtInSpeaker];
        for description in outputs {
            if headSetOutputRoutes.contains(description.portType) {
                return true
            }
        }
        return false
    }
}
