//
//  AudioRecordProtocol.swift
//  
//
//  Created by liuming on 2021/7/30.
//

import Foundation
//音频录制协议，实现改协议的类具有采集音频并写入指定文件的功能
public protocol AudioRecordEnable {
    func setSavePath(path:String)
    func start()
    func pause()
    func stop()
    //开启多端录制
    func enableMutaleRecord(enable:Bool)
}

//负责音频采集协议,实现该协议的类具有采集音频数据的能力
public protocol AudioCaptureEanbel {
    
}
