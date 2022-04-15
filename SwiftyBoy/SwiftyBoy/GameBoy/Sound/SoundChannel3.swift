//
//  SoundChannel3.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit
import AudioKit

class SoundChannel3: SoundChannelBase {
    
    var regNR30: RegNR30 = RegNR30(val: 0)
    var regNR31: RegNR31 = RegNR31(val: 0)
    var regNR32: RegNR32 = RegNR32(val: 0)
    var regNR33: RegNR33 = RegNR33(val: 0)
    var regNR34: RegNR34 = RegNR34(val: 0)
    var waveTableArray: [Int] = Array(repeating: 0, count: 32)
    var waveTableRegisters = Array(repeating: BaseRegister(val: 0), count: 16)
    
    private var _soundLength: Int = 0
    
    private var soundLength: Int {
        get {
            return regNR31.soundLength
        }
        set {
            regNR31.soundLength = newValue
        }
    }
    
    private var outputLevel: WaveOutputLevel {
        get {
            return regNR32.outputLevel
        }
        set {
            regNR32.outputLevel = newValue
        }
    }
    private var frequencyData: Int {
        get {
            return regNR34.frequencyHiData << 8 | regNR33.frequencyLoData
        }
        set {
            regNR33.frequencyLoData = newValue & 0xFF
            regNR34.frequencyHiData = (newValue & 0b111_00000000) >> 8
        }
    }
    private var lengthEnable: Bool {
        get {
            return regNR34.lengthEnabled
        }
        set {
            regNR34.lengthEnabled = newValue
        }
    }
    
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
    
    func setWaveReg(index: Int, val: Int) {
        waveTableRegisters[index].setVal(val: val)
        waveTableArray[index * 2] = (val & 0xF0) >> 4
        waveTableArray[index * 2 + 1] = val & 0x0F
    }
    
    func getWaveReg(index: Int) -> Int {
        return waveTableRegisters[index].getVal()
    }
    
    
}
