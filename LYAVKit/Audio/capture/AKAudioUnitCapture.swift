//
//  AKAudioUnitCapture.swift
//  AVKit
//
//  Created by liuming on 2021/8/1.
//

import AudioToolbox
import AVFoundation
import Foundation

// MARK: - AKAudioUnitCapture

public class AKAudioUnitCapture: AKAudioOutput {
    private let inputBus:UInt32 = 1
    private let outputBus:UInt32 = 0
    
    
    private var status_: AKAudioRecordStatus = .none
    private weak var delegate: AudioRecordDelegate?
    private var audioFormat = AKAudioFormat()
    private var audioUnit: AudioComponentInstance?
    private func configAudioUnit() {
        if audioUnit == nil {
            var status: OSStatus = 0
            var des = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                                componentSubType: kAudioUnitSubType_RemoteIO,
                                                componentManufacturer: 0,
                                                componentFlags: 0,
                                                componentFlagsMask: kAudioUnitManufacturer_Apple)

            let inputComponent: AudioComponent? = AudioComponentFindNext(nil, &des)
            guard let input = inputComponent else {
                return
            }
            status = AudioComponentInstanceNew(input, &audioUnit)

            status.debugLog()
            assert(status.checkNoError())
            
            //为录制打开io
            var flag:UInt32 = 1
            status = AudioUnitSetProperty(self.audioUnit!,
                                          kAudioOutputUnitProperty_EnableIO,
                                          kAudioUnitScope_Input,
                                          inputBus,
                                          &flag,
                                          UInt32(MemoryLayout.size(ofValue: flag)))
            status.debugLog()
            assert(status.checkNoError())
            
            
            
        }
    }
}

// MARK: AudioCaptureEanbel

extension AKAudioUnitCapture: AudioCaptureEanbel {
    public func setAudioFormat(format: AKAudioFormat) {
        audioFormat = format
    }

    public func start() {}

    public func pause() {}

    public func stop() {}

//    public var status: AKAudioRecordStatus {
//        return status_
//    }
//
//    public func setDelegate(delegate: AudioRecordDelegate) {
//        self.delegate = delegate
//    }
//
//    public func setAudioFormat(format: AKAudioFormat) {
//        self.audioFormat = format
//    }
//
//    public func setSavePath(path: String) {
//
//    }
//
//    public func start() {
//
//    }
//
//    public func pause() {
//
//    }
//
//    public func stop() {
//
//    }
//
//    public func enableMutaleRecord(enable: Bool) {
//
//    }
}
