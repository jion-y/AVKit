//
//  AKAudioCapure.swift
//  AVKit
//
//  Created by liuming on 2021/8/1.
//

import AVFoundation
import Foundation

public class AKAudioCapture: NSObject {
    private let session = AVCaptureSession()
    private let dataOutput = AVCaptureAudioDataOutput()
    private var audioFormat = AKAudioFormat()
    private let audioCaptureQueue = DispatchQueue(label: "ak.auido.capturession")

    public var status: AKAudioRecordStatus = .none
    private var hasConfigSession: Bool = false
    private let outputs = ThreadSafeArray<AudioInputEanble>()
}

extension AKAudioCapture: AudioCaptureEanbel {
    public func setAudioFormat(format: AKAudioFormat) {
        audioFormat = format
    }

    public func start() {
        if !status.canRecording() {
            return
        }
        if !hasConfigSession {
            configSession()
        }
        status = .recording
        session.startRunning()
    }

    public func pause() {
        status = .pause
    }

    public func stop() {
        if status.canStop() {
            session.stopRunning()
            status = .stop
        }
    }

    private func configSession() {
        if hasConfigSession {
            return
        }
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        hasConfigSession = true
        do {
            let deivceInput = try AVCaptureDeviceInput(device: audioDevice)
            session.usesApplicationAudioSession = true
            session.automaticallyConfiguresApplicationAudioSession = false
            dataOutput.setSampleBufferDelegate(self, queue: audioCaptureQueue)
            session.beginConfiguration()
            if session.canAddInput(deivceInput) {
                session.addInput(deivceInput)
            }
            if session.canAddOutput(dataOutput) {
                session.addOutput(dataOutput)
            }
            session.commitConfiguration()

        } catch _ {}
    }
}

extension AKAudioCapture: AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        push(sampleBuffer: sampleBuffer)
    }
}

extension AKAudioCapture: AudioOutputEnable {
    public func addIntputer(inputer: AudioInputEanble) {
        outputs.append(inputer)
    }

    public func push(sampleBuffer: CMSampleBuffer) {
        outputs.forEach { inputter in
            inputter.input(sampleBuffer: sampleBuffer)
        }
    }
}
