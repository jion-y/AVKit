//
//  AKAudioOutput.swift
//  LYAVKit
//
//  Created by liuming on 2021/8/4.
//

import Foundation
import AVFoundation

public class AKAudioOutput:NSObject {
    private let outputs = ThreadSafeHashTable<AKAudioInput>()
}
extension AKAudioOutput {
    
    public func addIntputer(inputer: AKAudioInput) {
        self.outputs.add(inputer)
    }
    
    public func push(sampleBuffer: CMSampleBuffer) {
        self.outputs.forEach { input in
            guard let inputObj = input else { return }
            inputObj.input(sampleBuffer: sampleBuffer)
        }
    }
    
    
}
