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
    case nr10, nr11, nr12, nr13, nr14, nr21, nr22, nr23, nr24
}

class SoundController {
    
    let engine = AudioEngine()
    
    
    // sound channel 1
    var regNR10: BaseRegister!
    var regNR11: BaseRegister!
    var regNR12: BaseRegister!
    var regNR13: BaseRegister!
    var regNR14: BaseRegister!
    
    // sound channel 2
    var regNR21: BaseRegister!
    var regNR22: BaseRegister!
    var regNR23: BaseRegister!
    var regNR24: BaseRegister!
    
    var soundChannel1: SoundChannel1!
    var soundChannel2: SoundChannel2!
    
    
    private let queue = DispatchQueue(label: "it.miketech.SwiftyBoy.sound")
    private var timer: DispatchSourceTimer!
    
    private var cpuTickCount = 0
    private var frameSequencerTickCount = 0
    private static let CPU_TICK_NUM_ONE_SEC = 4194304
    private static let FRAME_SEQUENCER_FREQUENCE = 512
    private let TICK_NUM_TARGET = CPU_TICK_NUM_ONE_SEC / FRAME_SEQUENCER_FREQUENCE
    
    init() {
        regNR10 = BaseRegister(val: 0)
        regNR11 = BaseRegister(val: 0)
        regNR12 = BaseRegister(val: 0)
        regNR13 = BaseRegister(val: 0)
        regNR14 = BaseRegister(val: 0)
        
        regNR21 = BaseRegister(val: 0)
        regNR22 = BaseRegister(val: 0)
        regNR23 = BaseRegister(val: 0)
        regNR24 = BaseRegister(val: 0)
        
        
        soundChannel2 = SoundChannel2()
        soundChannel1 = SoundChannel1()
        
        let mixer = Mixer(soundChannel2.osc, soundChannel1.osc)
        engine.output = mixer
        
        do {
            try engine.start()
            soundChannel2.osc.start()
            soundChannel1.osc.start()
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    var tempCounter = 0
    func setupTestTimer() {
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer.setEventHandler { [self] in
            print(tempCounter)
            tempCounter = 0
            frameSequencerTickCount = 0
            cpuTickCount = 0
        }
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(10))
        timer.resume()
        
    }
    
    
    func updateFrequency(x: Int, toneSoundChannel: ToneSoundChannel) {
//        toneSoundChannel.frequency = Float(x)
        if x >= 0 && x < 2048 {
            let frequency = 131072 / (2048 - x)
            toneSoundChannel.frequency = Float(frequency)
        }
    }
    
    
    func setReg(reg: SoundRegister, val: Int){
        switch reg {
        case .nr10:
            regNR10.setVal(val: val)
            soundChannel1.sweepPeriod = (val & 0b01110000) >> 4
            print("soundChannel1 period set \((val & 0b01110000) >> 4)")
            soundChannel1.sweepDirection = (val & 0b00001000) >> 3
            soundChannel1.sweepShift = val & 0b00000111
            break
        case .nr11:
            regNR11.setVal(val: val)
            soundChannel1.waveDuty = WaveDuty(rawValue: val >> 6)!
            soundChannel1.soundLength = val & 0b11111
            break
        case .nr12:
            regNR12.setVal(val: val)
            soundChannel1.startVolume = (val & 0xF0) >> 4
            soundChannel1.volEnvelopeMode = (val & 0x0b00001000) >> 3
            soundChannel1.volEnvelopePeriod = val & 0b00000111
            break
        case .nr13:
            regNR13.setVal(val: val)
            let x = val | (regNR14.getVal() & 0b111) << 8
            updateFrequency(x: x, toneSoundChannel: soundChannel1)
        case .nr14:
            regNR14.setVal(val: val)
            let x = val | (regNR14.getVal() & 0b111) << 8
            updateFrequency(x: x, toneSoundChannel: soundChannel1)
            soundChannel1.lengthEnable = !regNR24.getBit(n: 6)
            
            if regNR14.getBit(n: 7) {
                soundChannel1.onTriggerEvent()
            }
            break
            
            
        case .nr21:
            regNR21.setVal(val: val)
            soundChannel2.waveDuty = WaveDuty(rawValue: val >> 6)!
            soundChannel2.soundLength = val & 0b11111
            break
        case .nr22:
            regNR22.setVal(val: val)
            soundChannel2.startVolume = (val & 0xF0) >> 4
            soundChannel2.volEnvelopeMode = (val & 0x0b00001000) >> 3
            soundChannel2.volEnvelopePeriod = val & 0b00000111
            break
        case .nr23:
            regNR23.setVal(val: val)
            let x = val | (regNR24.getVal() & 0b111) << 8
            updateFrequency(x: x, toneSoundChannel: soundChannel2)
            break
        case .nr24:
            regNR24.setVal(val: val)
            let x = val | (regNR24.getVal() & 0b111) << 8
            updateFrequency(x: x, toneSoundChannel: soundChannel2)
            soundChannel2.lengthEnable = !regNR24.getBit(n: 6)
            
            if regNR24.getBit(n: 7) {
                soundChannel2.onTriggerEvent()
            }
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
        case .nr10:
            return regNR10.getVal()
        case .nr11:
            return regNR11.getVal()
        case .nr12:
            return regNR12.getVal()
        case .nr13:
            return regNR13.getVal()
        case .nr14:
            return regNR14.getVal()
        }
    }
    
    

    func tick(cycles: Int) {
        cpuTickCount += cycles
        // 512Hz frequency divide
        if cpuTickCount >= TICK_NUM_TARGET {
            frameSequencerTickCount += 1
            cpuTickCount = 0
            
            let step = frameSequencerTickCount % 8
            
            // 256Hz
            if step == 0 || step == 2 || step == 4 || step == 6 {
                soundChannel2.onLengthCounterTick()
                soundChannel1.onLengthCounterTick()
                // 128 Hz
                if step == 2 || step == 6 {
                    soundChannel2.onSweepTick()
                    soundChannel1.onSweepTick()
                }
                
            } else if step == 7 {
                // 64Hz
                soundChannel2.onVolumEnvlopTick()
                soundChannel1.onVolumEnvlopTick()
            }
            
        }
        if frameSequencerTickCount > 512 {
            frameSequencerTickCount = 0
        }
    }
    
    func audioKitTable(dutyCycle: Double) -> Table {
        let size = 4096
        var content = [Table.Element](zeros: size)
        for i in 0..<Int(Double(size) * dutyCycle) {
            content[i] = 1.0
        }
        return Table(content)
    }

    
}
