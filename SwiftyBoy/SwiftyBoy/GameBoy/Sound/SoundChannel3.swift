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
    var soundLength: Int {
        get {
            return _soundLength
        }
        set {
            _soundLength = 256 - newValue
        }
    }
    
    var outputLevel: WaveOutputLevel = .mute
    var frequencyData: Int = 0
    var lengthEnable: Bool = false
    
    override func onTriggerEvent() {
        // channel is enabled
        osc.start()
        // length counter reset
        if self._soundLength == 0 {
            self._soundLength = 256
        }
        // freq & waveform update
        setOscFrequency(x: frequencyData)
        let waveform = waveform()
        osc.setWaveTable(waveform: waveform)
        
    }
    
    override func onLengthCounterTick() {
        if lengthEnable && _soundLength > 0 {
            _soundLength -= 1
            if _soundLength == 0 {
                print("channel 3 stop")
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
