//
//  DefaultRecorder.swift
//  AVKit
//
//  Created by liuming on 2021/7/30.
//

import Foundation
import AVFoundation
public class DefaultAudioRecoder {
    
    private var audioPath:String = ""
    private var mutableRecord:Bool = false
    private var recoder:AVAudioRecorder?
    private var format :AVAudioFormat = AVAudioFormat()
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
                try self.recoder = AVAudioRecorder(url: URL(fileURLWithPath: self.audioPath), format: self.format)
            } catch _ {
                
            }
            
        }
    }
    
    public func pause() {
        
    }
    
    public func stop() {
        
    }
    
    public func enableMutaleRecord(enable: Bool) {

    }
    
    
}
