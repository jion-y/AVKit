//
//  AKAudioCaptureSessionWriter.swift
//  AVKit
//
//  Created by liuming on 2021/8/2.
//

import AVFoundation
import Foundation

// MARK: - AKAudioCaptureSessionWriter

public class AKAudioCaptureSessionWriter: AKAudioInput {
    private var audioFormat = AKAudioFormat()
    private var audioInput: AVAssetWriterInput?
    private var assetWriter: AVAssetWriter?
    private var hasPrepareAudio: Bool = false
    private var audioPath: String = ""
    public var isWritting: Bool = false

    private func prepareAudio() throws {
        if hasPrepareAudio {
            return
        }
        hasPrepareAudio = true
        do {
            guard let fileType = audioPath.fileType() else {
                throw NSError(domain: "com.lyAVKit.AKAudioCaptureSessionWriter", code: -99, userInfo: ["errorInfo": "\(audioPath) not exist file type"])
            }
            assetWriter = try AVAssetWriter(outputURL: URL(fileURLWithPath: audioPath), fileType: fileType)

            audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioFormat.toDic())
            audioInput?.expectsMediaDataInRealTime = true
            if assetWriter!.canAdd(audioInput!) {
                assetWriter!.add(audioInput!)
            }

        } catch {
            throw error
        }
    }

    override public func input(sampleBuffer: CMSampleBuffer) {
        if isWritting {
            audioInput?.append(sampleBuffer)
        }
    }
}

// MARK: AudioWiterEnable

extension AKAudioCaptureSessionWriter: AudioWiterEnable {
    public func setWritePath(path: String) {
        audioPath = path
    }

    public func startWriter() {
        if !hasPrepareAudio {
            try? prepareAudio()
        }
        if !isWritting {
            isWritting = true
            assetWriter?.startWriting()
        }
    }

    public func pasueWriter() {
        isWritting = false
    }

    public func endWriter() {
        if assetWriter?.status == .writing {
            assetWriter?.finishWriting {}
        }
    }

    public func setAuidoFomart(format: AKAudioFormat) {
        audioFormat = format
    }
}
