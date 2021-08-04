//
//  AKAudioOutput.swift
//  LYAVKit
//
//  Created by liuming on 2021/8/4.
//

import AVFoundation
import Foundation

public class AKAudioOutput: NSObject {
    private let outputs = ThreadSafeHashTable<AKAudioInput>()
}

public extension AKAudioOutput {
    func addIntputer(inputer: AKAudioInput) {
        outputs.add(inputer)
    }

    func push(sampleBuffer: CMSampleBuffer) {
        outputs.forEach { input in
            guard let inputObj = input else { return }
            inputObj.input(sampleBuffer: sampleBuffer)
        }
    }
}
