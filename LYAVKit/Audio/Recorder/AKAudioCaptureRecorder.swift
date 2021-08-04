//
//  File.swift
//  AVKit
//
//  Created by liuming on 2021/8/2.
//

import AVFoundation
import Foundation

// MARK: - AKAudioCaptureRecorder

public class AKAudioCaptureRecorder {
    private var audioPath: String = ""
    private var mutableRecord: Bool = false
    private var recoder: AVAudioRecorder?
    private var format = AKAudioFormat()
    private var status_: AKAudioRecordStatus = .none
    private weak var delegate: AudioRecordDelegate?

    private let audioCapture = AKAudioCapture()
    private let audioWtriter = AKAudioCaptureSessionWriter()
}

// MARK: AudioRecordEnable

extension AKAudioCaptureRecorder: AudioRecordEnable {
    public var status: AKAudioRecordStatus {
        return status_
    }

    public func setDelegate(delegate: AudioRecordDelegate) {
        self.delegate = delegate
    }

    public func setAudioFormat(format: AKAudioFormat) {
        self.format = format
        audioCapture.setAudioFormat(format: self.format)
        audioWtriter.setAuidoFomart(format: self.format)
    }

    public func setSavePath(path: String) {
        audioPath = path
        audioWtriter.setWritePath(path: path)
    }

    public func start() {
        if status_ != .recording {
            status_ = .recording
            audioCapture.start()
            audioWtriter.startWriter()
        }
    }

    public func pause() {
        if status_ == .recording {
            audioCapture.pause()
            audioWtriter.pasueWriter()
        }
    }

    public func stop() {
        if status_ == .recording || status_ == .stop {
            audioCapture.stop()
            audioWtriter.endWriter()
        }
    }

    public func enableMutaleRecord(enable _: Bool) {}
}
