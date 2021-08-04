//
//  OSStatus+Extension.swift
//  LYAVKit
//
//  Created by liuming on 2021/8/4.
//

import AudioToolbox
import AVFoundation
import Foundation
extension OSStatus {
    func asString() -> String? {
        let n = UInt32(bitPattern: littleEndian)
        guard let n1 = UnicodeScalar((n >> 24) & 255), n1.isASCII else { return nil }
        guard let n2 = UnicodeScalar((n >> 16) & 255), n2.isASCII else { return nil }
        guard let n3 = UnicodeScalar((n >> 8) & 255), n3.isASCII else { return nil }
        guard let n4 = UnicodeScalar(n & 255), n4.isASCII else { return nil }
        return String(n1) + String(n2) + String(n3) + String(n4)
    }

    func detailedErrorMessage() -> String? {
        switch self {
        // ***** AUGraph errors
        case kAUGraphErr_NodeNotFound: return "AUGraph Node Not Found"
        case kAUGraphErr_InvalidConnection: return "AUGraph Invalid Connection"
        case kAUGraphErr_OutputNodeErr: return "AUGraph Output Node Error"
        case kAUGraphErr_CannotDoInCurrentContext: return "AUGraph Cannot Do In Current Context"
        case kAUGraphErr_InvalidAudioUnit: return "AUGraph Invalid Audio Unit"

        // ***** MIDI errors
        case kMIDIInvalidClient: return "MIDI Invalid Client"
        case kMIDIInvalidPort: return "MIDI Invalid Port"
        case kMIDIWrongEndpointType: return "MIDI Wrong Endpoint Type"
        case kMIDINoConnection: return "MIDI No Connection"
        case kMIDIUnknownEndpoint: return "MIDI Unknown Endpoint"
        case kMIDIUnknownProperty: return "MIDI Unknown Property"
        case kMIDIWrongPropertyType: return "MIDI Wrong Property Type"
        case kMIDINoCurrentSetup: return "MIDI No Current Setup"
        case kMIDIMessageSendErr: return "MIDI Message Send Error"
        case kMIDIServerStartErr: return "MIDI Server Start Error"
        case kMIDISetupFormatErr: return "MIDI Setup Format Error"
        case kMIDIWrongThread: return "MIDI Wrong Thread"
        case kMIDIObjectNotFound: return "MIDI Object Not Found"
        case kMIDIIDNotUnique: return "MIDI ID Not Unique"
        case kMIDINotPermitted: return "MIDI Not Permitted"

        // ***** AudioToolbox errors
        case kAudioToolboxErr_CannotDoInCurrentContext: return "AudioToolbox Cannot Do In Current Context"
        case kAudioToolboxErr_EndOfTrack: return "AudioToolbox End Of Track"
        case kAudioToolboxErr_IllegalTrackDestination: return "AudioToolbox Illegal Track Destination"
        case kAudioToolboxErr_InvalidEventType: return "AudioToolbox Invalid Event Type"
        case kAudioToolboxErr_InvalidPlayerState: return "AudioToolbox Invalid Player State"
        case kAudioToolboxErr_InvalidSequenceType: return "AudioToolbox Invalid Sequence Type"
        case kAudioToolboxErr_NoSequence: return "AudioToolbox No Sequence"
        case kAudioToolboxErr_StartOfTrack: return "AudioToolbox Start Of Track"
        case kAudioToolboxErr_TrackIndexError: return "AudioToolbox Track Index Error"
        case kAudioToolboxErr_TrackNotFound: return "AudioToolbox Track Not Found"
        case kAudioToolboxError_NoTrackDestination: return "AudioToolbox No Track Destination"

        // ***** AudioUnit errors
        case kAudioUnitErr_CannotDoInCurrentContext: return "AudioUnit Cannot Do In Current Context"
        case kAudioUnitErr_FailedInitialization: return "AudioUnit Failed Initialization"
        case kAudioUnitErr_FileNotSpecified: return "AudioUnit File Not Specified"
        case kAudioUnitErr_FormatNotSupported: return "AudioUnit Format Not Supported"
        case kAudioUnitErr_IllegalInstrument: return "AudioUnit Illegal Instrument"
        case kAudioUnitErr_Initialized: return "AudioUnit Initialized"
        case kAudioUnitErr_InvalidElement: return "AudioUnit Invalid Element"
        case kAudioUnitErr_InvalidFile: return "AudioUnit Invalid File"
        case kAudioUnitErr_InvalidOfflineRender: return "AudioUnit Invalid Offline Render"
        case kAudioUnitErr_InvalidParameter: return "AudioUnit Invalid Parameter"
        case kAudioUnitErr_InvalidProperty: return "AudioUnit Invalid Property"
        case kAudioUnitErr_InvalidPropertyValue: return "AudioUnit Invalid Property Value"
        case kAudioUnitErr_InvalidScope: return "AudioUnit InvalidScope"
        case kAudioUnitErr_InstrumentTypeNotFound: return "AudioUnit Instrument Type Not Found"
        case kAudioUnitErr_NoConnection: return "AudioUnit No Connection"
        case kAudioUnitErr_PropertyNotInUse: return "AudioUnit Property Not In Use"
        case kAudioUnitErr_PropertyNotWritable: return "AudioUnit Property Not Writable"
        case kAudioUnitErr_TooManyFramesToProcess: return "AudioUnit Too Many Frames To Process"
        case kAudioUnitErr_Unauthorized: return "AudioUnit Unauthorized"
        case kAudioUnitErr_Uninitialized: return "AudioUnit Uninitialized"
        case kAudioUnitErr_UnknownFileType: return "AudioUnit Unknown File Type"
        case kAudioUnitErr_RenderTimeout: return "AudioUnit Rendre Timeout"

        // ***** AudioComponent errors
        case kAudioComponentErr_DuplicateDescription: return "AudioComponent Duplicate Description"
        case kAudioComponentErr_InitializationTimedOut: return "AudioComponent Initialization Timed Out"
        case kAudioComponentErr_InstanceInvalidated: return "AudioComponent Instance Invalidated"
        case kAudioComponentErr_InvalidFormat: return "AudioComponent Invalid Format"
        case kAudioComponentErr_NotPermitted: return "AudioComponent Not Permitted "
        case kAudioComponentErr_TooManyInstances: return "AudioComponent Too Many Instances"
        case kAudioComponentErr_UnsupportedType: return "AudioComponent Unsupported Type"

        // ***** Audio errors
        case kAudio_BadFilePathError: return "Audio Bad File Path Error"
        case kAudio_FileNotFoundError: return "Audio File Not Found Error"
        case kAudio_FilePermissionError: return "Audio File Permission Error"
        case kAudio_MemFullError: return "Audio Mem Full Error"
        case kAudio_ParamError: return "Audio Param Error"
        case kAudio_TooManyFilesOpenError: return "Audio Too Many Files Open Error"
        case kAudio_UnimplementedError: return "Audio Unimplemented Error"

        default: return nil
        }
    }

    func debugLog(filePath: String = #file, line: Int = #line, funcName: String = #function) {
        let isDebug = true
        guard isDebug, self != noErr else { return }
        let fileComponents = filePath.components(separatedBy: "/")
        let fileName = fileComponents.last ?? "???"

        var logString = "OSStatus = \(self) in \(fileName) - \(funcName), line \(line)"

        if let errorMessage = detailedErrorMessage() { logString = errorMessage + ", " + logString }
        else if let errorCode = asString() { logString = errorCode + ", " + logString }

        NSLog(logString)
    }

    func checkNoError() -> Bool {
        return self == noErr ? true : false
    }
}
