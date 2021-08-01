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
    private var status_:AKAudioRecordStatus = .none
    private weak var delegate:AudioRecordDelegate?
    
}
extension DefaultAudioRecoder : AudioRecordEnable {
    public var status: AKAudioRecordStatus {
        return status_
    }
    
    public func setSavePath(path: String) {
        assert(!path.isEmpty, "path is empty")
        if FileManager.default.fileExists(atPath: path) {
           try? FileManager.default.removeItem(atPath: path)
        }
        self.audioPath = path
    }
    
    public func start() {
        if !self.status.canRecording() {
            return
        }
        self.status_ = .recording
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
        if self.status.isRecording() {
            self.status_ = .pause
            self.recoder?.pause()
        }
    }
    
    public func stop() {
        if self.status.canStop() {
            self.status_ = .stop
            self.recoder?.stop()
        }
    }
    
    public func enableMutaleRecord(enable: Bool) {

    }
    
    public func setAudioFormat(format:AKAuidoFormat) {
        self.format = format
    }
    
    public func setDelegate(delegate: AudioRecordDelegate) {
        
    }
}

extension DefaultAudioRecoder : AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let audioDelegate  = self.delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderDidFinishRecording(_:successfully:))) {
            self.delegate?.audioRecorderDidFinishRecording(self, successfully: flag)
        }
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        guard let audioDelegate  = self.delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderEncodeErrorDidOccur(_:error:))) {
            self.delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
        }
    }
    
    public func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
        guard let audioDelegate  = self.delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderBeginInterruption(_:))) {
            audioDelegate.audioRecorderBeginInterruption(self)
        }
    }

    public func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        guard let audioDelegate  = self.delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderEndInterruption(_:withOptions:))) {
            audioDelegate.audioRecorderEndInterruption(self, withOptions: flags)
        }
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
