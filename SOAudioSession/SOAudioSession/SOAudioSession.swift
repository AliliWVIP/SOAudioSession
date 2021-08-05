//
//  SOAudioSession.swift
//  SOAudioSession
//
//  Created by Wl Alili on 2021/7/20.
//

import AVFoundation

let SOAudioSessionLatency_Background = 0.0929;
let SOAudioSessionLatency_Default = 0.0232;
let SOAudioSessionLatency_LowLatency = 0.0058;
enum SORouteType {
    case wiredMicrophone
    case blueTooth
    case earphoneAlert
}
enum SOInterruptionType {
    case ended
    case began
}
public class SOAudioSession {
    static let shared = SOAudioSession()
    weak var delegate: SOAVAudioSessionRouteDelegate?
    weak var interruption: SOAVAudioSessionInterruptionDelegate?
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var preferredSampleRate: Float64 {
        set (newValue){
            do {
                try audioSession.setPreferredSampleRate(newValue)
            } catch {
                print("Error when setting preferredSampleRate")
            }
        }
        get {
            return audioSession.preferredSampleRate
        }
    }
    var currentSampleRate: Float64 {
        get {
            return self.audioSession.sampleRate
        }
    }
    // 延迟
    var preferredLatency: TimeInterval{
        set{
            do {
                try self.audioSession.setPreferredIOBufferDuration(newValue)
            } catch {
                print("Error when setting preferred I/O buffer duration")
            }
        }
        get{
            return self.audioSession.preferredIOBufferDuration
        }
    }
    var active: Bool{
        set {
            do {
                try self.audioSession.setPreferredSampleRate(self.preferredSampleRate)
                try self.audioSession.setActive(newValue)
            }catch {
                print("Could note set category on audio session\(error.localizedDescription)")
            }
        }
        get {
            return self.active
        }
    }
    private init(){
        preferredSampleRate = 44100.0
    }
    var category: String {
        set (newValue){
            do {
                try self.audioSession.setCategory(AVAudioSession.Category.init(rawValue: newValue))
            } catch {
                print("Could note set category on audio session\(error.localizedDescription)")
            }
        }
        get{
            return self.category
        }
    }
    func addRouteChangeListener() {
        removeRouteChangeListener()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationAudioRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
        adjustOnRouteChange()
    }
    
    func addAudioSessionInterruptedListener() {
        removeAudioSessionInterruptedListener()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationAudioInterrupted(info:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func removeAudioSessionInterruptedListener() {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func removeRouteChangeListener() {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    @objc func onNotificationAudioInterrupted(info: Notification){
        let interruptionType: AVAudioSession.InterruptionType = info.userInfo?[AVAudioSessionInterruptionTypeKey] as! AVAudioSession.InterruptionType
        var type: SOInterruptionType? = .began
        switch interruptionType {
        case .began:
            type = .began
            break
        case .ended:
            type = .ended
            break
        @unknown default: break
            
        }
        if interruption != nil && ((interruption?.responds(to: Selector(("interruptionType::")))) != nil) {
            interruption?.interruptionType(audioSession: self, type: type!)
        }
        
    }
    
    @objc func onNotificationAudioRouteChange() {
        adjustOnRouteChange()
    }
    
    func adjustOnRouteChange() {
        var routeType: SORouteType = .earphoneAlert
        if AVAudioSession.sharedInstance().usingWiredMicrophone() {
            routeType = .wiredMicrophone
        } else if AVAudioSession.sharedInstance().usingBlueTooth() {
            routeType = .blueTooth
        }
        if delegate != nil && (delegate?.responds(to: Selector(("currentRouteType::"))))! {
            delegate?.currentRouteType(audioSession: SOAudioSession.shared, routeType: routeType)
        }
    }
    
}

protocol SOAVAudioSessionRouteDelegate: NSObjectProtocol {
    func currentRouteType(audioSession: SOAudioSession, routeType: SORouteType)
}

protocol SOAVAudioSessionInterruptionDelegate: NSObjectProtocol {
    func interruptionType(audioSession: SOAudioSession, type: SOInterruptionType)
}
