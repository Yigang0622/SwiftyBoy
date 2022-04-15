//
//  SoundChannel3.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit
import AudioKit

class SoundChannel3: SoundChannelBase {

    var waveTableArray: [Int] = Array(repeating: 0, count: 32)
    
    var _soundLength: Int = 0
    var soundLength: Int = 0
    
    var outputLevel: WaveOutputLevel = .mute
    var frequencyData: Int = 0
    var lengthEnable: Bool = false
    
    override func onTriggerEvent() {
        // channel is enabled
        osc.start()
        // length counter reset
        self._soundLength = 256 - soundLength
        
        // freq & waveform update
        setOscFrequency(x: frequencyData)
        osc.setWaveTable(waveform: waveform())
        // vol
        switch outputLevel {
        case .mute:
            osc.amplitude = 0
            print("\(self) level mute")
            break
        case .unmodified:
            osc.amplitude = oscBaseAmplitude
            print("\(self) level unmodified")
            break
        case .shift1bit:
            osc.amplitude = oscBaseAmplitude * 0.5
            print("\(self) level shift1bit")
            break
        case .shift2bit2:
            osc.amplitude = oscBaseAmplitude * 0.25
            print("\(self) level shift2bit2")
            break
        }
        
    }
    
    override func onLengthCounterTick() {
        if lengthEnable && _soundLength > 0 {
            _soundLength -= 1
            if _soundLength == 0 {
                print("\(self)  stop")
                osc.stop()
            }
        }
    }
    
    private func waveform() -> Table {
        let elementes: [Table.Element] = waveTableArray.map { step in
            return Float(step) / 16.0
        }
        print(elementes)
        return Table(elementes)
    }
    
    
}
