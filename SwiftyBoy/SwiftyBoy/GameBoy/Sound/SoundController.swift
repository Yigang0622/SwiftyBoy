//
//  SoundController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/9.
//

import Foundation
import AudioKit

enum WaveDuty: Int {
    case duty0
    case duty12_5
    case duty25
    case duty50
    case duty75
}

enum SoundRegister {
    case nr21, nr22, nr23, nr24
}

class SoundController {
    
    let engine = AudioEngine()
    let osc = DynamicOscillator()
    
    // sound channel 2
    var regNR21: BaseRegister;
    var regNR22: BaseRegister;
    var regNR23: BaseRegister;
    var regNR24: BaseRegister;
    
    var waveDuty: WaveDuty = .duty0
    var frequency = 0
    
    private var waveTable: [WaveDuty: Table]!
    
    
    init() {
        regNR21 = BaseRegister(val: 0)
        regNR22 = BaseRegister(val: 0)
        regNR23 = BaseRegister(val: 0)
        regNR24 = BaseRegister(val: 0)
        
        waveTable = [
            .duty0:  audioKitTable(dutyCycle: 0),
            .duty12_5: audioKitTable(dutyCycle: 0.125),
            .duty25: audioKitTable(dutyCycle: 0.25),
            .duty50: audioKitTable(dutyCycle: 0.50),
            .duty75: audioKitTable(dutyCycle: 0.75)]
        
        engine.output = osc
        osc.amplitude = 0.5
        osc.frequency = 0
        
        do {
            try engine.start()
            osc.start()
        } catch let err {
            print(err.localizedDescription)
        }
            
        
    }
    
    
    func updateFrequency(x: Int) {
        if x >= 0 && x < 2048 {
            frequency = 131072 / (2048 - x)
            // update frequency
            print("changing freq \(frequency)")
            osc.frequency = AUValue(frequency)
        }
    }
    
    func updateWaveDuty(duty: WaveDuty) {
        let waveform = self.waveTable[duty]
        osc.setWaveTable(waveform: waveform!)
    }
    
    func setReg(reg: SoundRegister, val: Int){
        switch reg {
        case .nr21:
            regNR21.setVal(val: val)
            let v = val >> 6
            let duty = WaveDuty(rawValue: v)
            updateWaveDuty(duty: duty!)
            break
        case .nr22:
            
            break
        case .nr23:
            regNR23.setVal(val: val)
            let x = val | (regNR24.getVal() & 0b111) << 8
            updateFrequency(x: x)
            break
        case .nr24:
            regNR24.setVal(val: val)
            let x = val | (regNR24.getVal() & 0b111) << 8
            updateFrequency(x: x)
            break
        }
        
    }
    
    func getReg(reg: SoundRegister) -> Int {
        switch reg {
        case .nr21:
            return regNR21.getVal()
        case .nr22:
            return regNR22.getVal()
        case .nr23:
            return regNR23.getVal()
        case .nr24:
            return regNR24.getVal()
        }
    }
    
    func tick(cycles: Int) {
        
    }
    
    func audioKitTable(dutyCycle: Double) -> Table {
//        return Table(.square)
        let size = 4096
        var content = [Table.Element](zeros: size)
        for i in 0..<Int(Double(size) * dutyCycle) {
            content[i] = 1.0
        }
        return Table(content)
    }

    
}
