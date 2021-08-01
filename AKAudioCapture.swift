//
//  AKAudioCapure.swift
//  AVKit
//
//  Created by liuming on 2021/8/1.
//

import Foundation
import AVFoundation

public class AKAudioUnitCapture:NSObject {
    
    private let session : AVCaptureSession = AVCaptureSession()
    private let dataOutput:AVCaptureAudioDataOutput = AVCaptureAudioDataOutput()
    private var audioFormat:AKAuidoFormat = AKAuidoFormat()
    private let audioCaptureQueue = DispatchQueue.init(label: "ak.auido.capturession")
    
    public var status:AKAudioRecordStatus = .none
    private var hasConfigSession:Bool = false
    
}
extension AKAudioUnitCapture:AudioCaptureEanbel {
    public func setAudioFormat(format: AKAuidoFormat) {
        self.audioFormat = format
    }
    
    public func start() {
        if !self.status.canRecording() {
            return
        }
        if !self.hasConfigSession {
            
        }
        self.status = .recording
        self.session .startRunning()
    }
    
    public func pause() {
        self.status = .pause
    }
    
    public func stop() {
        if self.status.canStop() {
            self.session.stopRunning()
            self.status = .stop
        }
        
    }
    
    private func configSession() {
        if self.hasConfigSession {
            return
        }
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return  }
        self.hasConfigSession = true
        do {
           let deivceInput =  try AVCaptureDeviceInput(device: audioDevice)
            self.session.usesApplicationAudioSession = true
            self.session.automaticallyConfiguresApplicationAudioSession = false
            self.dataOutput.setSampleBufferDelegate(self, queue: self.audioCaptureQueue)
            self.session.beginConfiguration()
            if self.session .canAddInput(deivceInput) {
                self.session.addInput(deivceInput)
            }
            if self.session.canAddOutput(self.dataOutput) {
                self.session.addOutput(self.dataOutput)
            }
            self.session.commitConfiguration()
            
        } catch let _ {
            
        }
        

    }
}
extension AKAudioUnitCapture:AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
