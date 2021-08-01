//
//  AKRecorder.swift
//  AVKit
//
//  Created by liuming on 2021/7/30.
//

import Foundation
import AVFoundation

public enum RecorderType {
    case  AVRecoder
    case  AudioQueue
    case  AudioUint
}

/*
 kAudioFormatFlagIsFloat
 是否是浮点数， 没有设置，默认是 int 类型

 kAudioFormatFlagIsBigEndian
 是否是大端， 没有设置，默认是小端

 kAudioFormatFlagIsSignedInteger
 是否是 signed int， 没有设置，默认是 unsigned int

 kAudioFormatFlagIsPacked
 是否mBitsPerChannel 会占满整个通道，如果没有占满， 就会依高位对齐或低位对齐。
 没有设置的时候，满足 ((mBitsPerSample / 8) * mChannelsPerFrame) == mBytesPerFrame 的条件，默认会设置此选项。

 kAudioFormatFlagIsNonInterleaved
 是否是平面类型，是否是交错类型。

 双声道的情况

 交错类型的存储为,只有一个通道，通道内左右声道交错存储 LRLRLRLRLRLR
 非交错情况为， 左右声道分开存储，每个平面，存单独的声道
 平面1 LLLLLLLL
 平面2 RRRRRRR
 
 */
public class AKAuidoFormat {
    
    /// 采样率
    public var mSampleRate = 44100
    
    /// 数据流格式
    public var mFormatID:AudioFormatID = kAudioFormatLinearPCM
    /// 描述AudioBufferList的格式
    public var mFormatFlags:AudioFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
    
    /// 每个数据包，包含的采样数
    public var mFramesPerPacket:UInt32 = 1
    
    /*每个数据帧的字节。例如： kAudioFormatFlagIsSignedInteger 16 ， 每个通道 2 byte
     交错类型 mBitsPerChannel / 8 * mChannelsPerFrame
     非交错类型 mBitsPerChannel / 8
     */
    public var mBytesPerFrame:UInt32 = 2
    
    /// 描述音频通道的个数。单声道 1， 双声道为 2， 多声道 为 n
    public var mChannelsPerFrame:UInt32 = 1
    /*
     每个通道的位深 8, 16, 32等。
     kAudioFormatFlagIsSignedInteger 16 ， 每个通道 2 byte
     kAudioFormatFlagIsFloat 32，每个通道 4 byte
     */
    public var mBitsPerChannel:UInt32 = 16
    
    public var mReserved = 0
}

extension AKAuidoFormat {
    public func PCMIsFloat() -> Bool {
        return self.mBitsPerChannel == 32 ? true : false;
    }
    public func IsBigEndian() -> Bool {
        self.mFormatFlags & kAudioFormatFlagIsBigEndian  == kAudioFormatFlagIsBigEndian ? true: false
    }
}

open class AKRecorder {
    static func getRecoder(type:RecorderType)->AudioRecordEnable? {
        return nil
    }
}
