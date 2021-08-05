# SOAudioSession

使用Swift封装的AudioSession库。

### 集成

下载代码后，把**AVAudioSession+Routers.swift**   和 **SOAudioSession.swift** 复制到项目中即可。

### 使用

1. 初始化

````swift
SOAudioSession.shared.preferredSampleRate = 44100.0
SOAudioSession.shared.active = true
//  添加监听方法
SOAudioSession.shared.addRouteChangeListener()
SOAudioSession.shared.addAudioSessionInterruptedListener()
// 添加代理
SOAudioSession.shared.delegate = self
SOAudioSession.shared.interruption = self
````

2. 实现代理

````swift
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
````

