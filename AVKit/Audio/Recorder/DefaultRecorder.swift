//
//  DefaultRecorder.swift
//  AVKit
//
//  Created by liuming on 2021/7/30.
//

import Foundation
import AVFoundation
public class DefaultAudioRecoder: NSObject {
    
    private var audioPath:String = ""
    private var mutableRecord:Bool = false
    private var recoder:AVAudioRecorder?
    private var format :AKAuidoFormat = AKAuidoFormat()
    
}
extension DefaultAudioRecoder : AudioRecordEnable {
    public func setSavePath(path: String) {
        assert(!path.isEmpty, "path is empty")
        if FileManager.default.fileExists(atPath: path) {
           try? FileManager.default.removeItem(atPath: path)
        }
        self.audioPath = path
    }
    
    public func start() {
        if self.recoder == nil {
            do {
                try self.recoder = AVAudioRecorder(url: URL(fileURLWithPath: self.audioPath), settings: self.format.toDic())
                self.recoder?.delegate  = self
            } catch _ {
                
            }
            
        }
        self.recoder?.record()
    }
    
    public func pause() {
        self.recoder?.pause()
    }
    
    public func stop() {
        self.recoder?.stop()
    }
    
    public func enableMutaleRecord(enable: Bool) {

    }
    
    public func setAudioFormat(format:AKAuidoFormat) {
        self.format = format
    }
    
}

extension DefaultAudioRecoder : AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
    }
    
    public func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
        self.recoder?.pause()
    }

    public func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        self.recoder?.record()
    }
    
}

extension AKAuidoFormat {
    func toDic() -> Dictionary<String,Any> {
        return [
            AVFormatIDKey:self.mFormatID,
            AVSampleRateKey:self.mSampleRate,
            AVNumberOfChannelsKey:self.mChannelsPerFrame,
            AVEncoderAudioQualityKey:AVAudioQuality.medium,
            AVLinearPCMBitDepthKey:self.mBitsPerChannel,
            AVLinearPCMIsBigEndianKey:false,
            AVLinearPCMIsFloatKey:false
       ]
    }
    
    
}
