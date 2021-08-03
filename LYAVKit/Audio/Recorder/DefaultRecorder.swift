//
//  DefaultRecorder.swift
//  AVKit
//
//  Created by liuming on 2021/7/30.
//

import AVFoundation
import Foundation
public class DefaultAudioRecoder: NSObject {
    private var audioPath: String = ""
    private var mutableRecord: Bool = false
    private var recoder: AVAudioRecorder?
    private var format = AKAudioFormat()
    private var status_: AKAudioRecordStatus = .none
    private weak var delegate: AudioRecordDelegate?
}

extension DefaultAudioRecoder: AudioRecordEnable {
    public var status: AKAudioRecordStatus {
        return status_
    }

    public func setSavePath(path: String) {
        assert(!path.isEmpty, "path is empty")
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
        audioPath = path
    }

    public func start() {
        if !status.canRecording() {
            return
        }
        status_ = .recording
        if recoder == nil {
            do {
                try recoder = AVAudioRecorder(url: URL(fileURLWithPath: audioPath), settings: format.toDic())
                recoder?.delegate = self
            } catch _ {}
        }

        recoder?.record()
    }

    public func pause() {
        if status.isRecording() {
            status_ = .pause
            recoder?.pause()
        }
    }

    public func stop() {
        if status.canStop() {
            status_ = .stop
            recoder?.stop()
        }
    }

    public func enableMutaleRecord(enable _: Bool) {}

    public func setAudioFormat(format: AKAudioFormat) {
        self.format = format
    }

    public func setDelegate(delegate _: AudioRecordDelegate) {}
}

extension DefaultAudioRecoder: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        guard let audioDelegate = delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderDidFinishRecording(_:successfully:))) {
            self.delegate?.audioRecorderDidFinishRecording(self, successfully: flag)
        }
    }

    public func audioRecorderEncodeErrorDidOccur(_: AVAudioRecorder, error: Error?) {
        guard let audioDelegate = delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderEncodeErrorDidOccur(_:error:))) {
            self.delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
        }
    }

    public func audioRecorderBeginInterruption(_: AVAudioRecorder) {
        guard let audioDelegate = delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderBeginInterruption(_:))) {
            audioDelegate.audioRecorderBeginInterruption(self)
        }
    }

    public func audioRecorderEndInterruption(_: AVAudioRecorder, withOptions flags: Int) {
        guard let audioDelegate = delegate else {
            return
        }
        if audioDelegate.responds(to: #selector(audioRecorderEndInterruption(_:withOptions:))) {
            audioDelegate.audioRecorderEndInterruption(self, withOptions: flags)
        }
    }
}

extension AKAudioFormat {
    func toDic() -> [String: Any] {
        return [
            AVFormatIDKey: mFormatID,
            AVSampleRateKey: mSampleRate,
            AVNumberOfChannelsKey: mChannelsPerFrame,
            AVEncoderAudioQualityKey: AVAudioQuality.medium,
            AVLinearPCMBitDepthKey: mBitsPerChannel,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
        ]
    }
}
