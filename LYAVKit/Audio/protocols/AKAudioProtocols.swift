//
//  AKAudioProtocols.swift
//  AVKit
//
//  Created by liuming on 2021/8/2.
//

import Foundation
import AVFoundation

public enum AKAudioRecordStatus {
    case none
    case recording
    case pause
    case stop
}

public protocol AudioRecordDelegate:NSObjectProtocol{
    func audioRecorderDidFinishRecording(_ recorder:AudioRecordEnable , successfully flag: Bool)
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AudioRecordEnable, error: Error?)
    
    func audioRecorderBeginInterruption(_ recorder: AudioRecordEnable)
    
    func audioRecorderEndInterruption(_ recorder: AudioRecordEnable, withOptions flags: Int)
    
}

//音频录制协议，实现改协议的类具有采集音频并写入指定文件的功能
public protocol AudioRecordEnable {
    var status:AKAudioRecordStatus { get }
    func setDelegate(delegate:AudioRecordDelegate)
    func setAudioFormat(format:AKAuidoFormat)
    func setSavePath(path:String)
    func start()
    func pause()
    func stop()
    //开启多端录制
    func enableMutaleRecord(enable:Bool)
}

//负责音频采集协议,实现该协议的类具有采集音频数据的能力
public protocol AudioCaptureEanbel {
    func setAudioFormat(format:AKAuidoFormat)
    func start()
    func pause()
    func stop()
    
}

public protocol AudioWiterEnable {
    func setSession(session:AVCaptureSession)
}

public protocol AudioOutputEnable {
    func addIntputer(inputer:AudioInputEanble)
    func push(sampleBuffer:CMSampleBuffer)
}
public protocol AudioInputEanble {
    func input(sampleBuffer:CMSampleBuffer)
}


