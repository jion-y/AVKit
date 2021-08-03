//
//  String+Extension.swift
//  LYAVKit
//
//  Created by liuming on 2021/8/3.
//

import AVFoundation
import Foundation

let fileTypeMap: [String: AVFileType] = [
    "mp3": .mp3,
    "mov": .mov,
    "mp4": .mp4,
    "m4v": .m4v,
    "m4a": .m4a,
    "3gp": .mobile3GPP,
    "3gpp": .mobile3GPP,
    "sdv": .mobile3GPP,
    "3g2": .mobile3GPP2,
    "3gp2": .mobile3GPP2,
    "caf": .caf,
    "wav": .wav,
    "aif": .aiff,
    "aifc": .aifc,
    "amr": .amr,
    "mp3": .mp3,
    "au": .au,
    "ac3": .ac3,
    "eac3": .eac3,
//    "heic":.heic,
//    "jpg":.jpg,
//    "jpeg":.jpg
]
public extension String {
    func fileType() -> AVFileType? {
        let url = URL(fileURLWithPath: self)
        if !url.isFileURL {
            return nil
        }
        let lasComponent: String = url.pathExtension.lowercased()
        return fileTypeMap[lasComponent]
    }
}
