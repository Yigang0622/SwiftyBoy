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
    case nr10, nr11, nr12, nr13, nr14,
         nr21, nr22, nr23, nr24,
         nr30, nr31, nr32, nr33, nr34,
         nr41, nr42, nr43, nr44,
         nr52
}

class SoundController {
    
    let engine = AudioEngine()
    
    // sound channel 1
    var regNR10: RegNR10 = RegNR10(val: 0)
    
    var regNR30: RegNR30 = RegNR30(val: 0)
    var regNR31: RegNR31 = RegNR31(val: 0)
    var regNR32: RegNR32 = RegNR32(val: 0)
    var regNR33: RegNR33 = RegNR33(val: 0)
    var regNR34: RegNR34 = RegNR34(val: 0)
    
    var waveTableRegisters = Array(repeating: BaseRegister(val: 0), count: 16)
    var regNR52: RegNR52 = RegNR52(val: 0)
    
    var soundChannel1: SoundChannel1 = SoundChannel1()
    var soundChannel2: SoundChannel2 = SoundChannel2()
    var soundChannel3: SoundChannel3 = SoundChannel3()
    var soundChannel4: SoundChannel4 = SoundChannel4()
    
    private let queue = DispatchQueue(label: "it.miketech.SwiftyBoy.sound")
    private var timer: DispatchSourceTimer!
    
    private var cpuTickCount = 0
    private var frameSequencerTickCount = 0
    private static let CPU_TICK_NUM_ONE_SEC = 4194304
    private static let FRAME_SEQUENCER_FREQUENCE = 512
    private let TICK_NUM_TARGET = CPU_TICK_NUM_ONE_SEC / FRAME_SEQUENCER_FREQUENCE
    
    init() {
        
        let mixer = Mixer(soundChannel1.osc,
                          soundChannel2.osc,
                          soundChannel3.osc,
                          soundChannel4.osc)
    
        engine.output = mixer
    
        do {
            try engine.start()
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
    
    func setWaveReg(index: Int, val: Int) {
        waveTableRegisters[index].setVal(val: val)
        soundChannel3.waveTableArray[index * 2] = (val & 0xF0) >> 4
        soundChannel3.waveTableArray[index * 2 + 1] = val & 0x0F
    }
    
    func getWaveReg(index: Int) -> Int {
        return waveTableRegisters[index].getVal()
    }
    
    func setReg(reg: SoundRegister, val: Int){
        switch reg {
        // square 1
        case .nr10:
            regNR10.setVal(val: val)
            soundChannel1.sweepPeriod = regNR10.sweepPeriod
            soundChannel1.sweepDirection = regNR10.sweepDirection
            soundChannel1.sweepShift = regNR10.sweepShift
            print("soundChannel1 nr10 \(val.asHexString) sweep period set \(soundChannel1.sweepPeriod) shift \(soundChannel1.sweepShift)")
            break
        case .nr11:
            soundChannel1.regNRx1.setVal(val: val)
            break
        case .nr12:
            soundChannel1.regNRx2.setVal(val: val)
            break
        case .nr13:
            soundChannel1.regNRx3.setVal(val: val)
            break
        case .nr14:
            soundChannel1.regNRx4.setVal(val: val)
            if soundChannel1.regNRx4.initialize {
                soundChannel1.onTriggerEvent()
            }
            break
                 
        // square 2
        case .nr21:
            soundChannel2.regNRx1.setVal(val: val)
            break
        case .nr22:
            soundChannel2.regNRx2.setVal(val: val)
            break
        case .nr23:
            soundChannel2.regNRx3.setVal(val: val)
            break
        case .nr24:
            soundChannel2.regNRx4.setVal(val: val)
            
            if soundChannel2.regNRx4.initialize {
                soundChannel2.onTriggerEvent()
            }
            break
            
        // wave
        case .nr30:
            regNR30.setVal(val: val)
            if !regNR30.soundEnable {
                soundChannel3.stop()
            }
            break
        case .nr31:
            regNR31.setVal(val: val)
            soundChannel3.soundLength = regNR31.soundLength
            break
        case .nr32:
            regNR32.setVal(val: val)
            soundChannel3.outputLevel = regNR32.outputLevel
            break
        case .nr33:
            regNR33.setVal(val: val)
            soundChannel3.frequencyData = regNR33.frequencyDataLo | regNR34.frequencyDataHi << 8
            break
        case .nr34:
            regNR34.setVal(val: val)
            soundChannel3.frequencyData = regNR33.frequencyDataLo | regNR34.frequencyDataHi << 8
            soundChannel3.lengthEnable = regNR34.lengthEnabled
            if regNR34.initializationFlag {
                soundChannel3.onTriggerEvent()
            }
            break
            
        // white noise
        case .nr41:
            soundChannel4.regNR41.setVal(val: val)
            break
        case .nr42:
            soundChannel4.regNR42.setVal(val: val)
            break
        case .nr43:
            soundChannel4.regNR43.setVal(val: val)
            break
        case .nr44:
            soundChannel4.regNR44.setVal(val: val)
            if soundChannel4.regNR44.initialize {
                soundChannel4.onTriggerEvent()
            }
            break
        
        // sound control
        case .nr52:
            regNR52.setVal(val: val)
            
            if !regNR52.allSoundEnabled {
                soundChannel1.stop()
                soundChannel2.stop()
                soundChannel3.stop()
                soundChannel4.stop()
            }
            
            if !regNR52.sound1Enabled {
                soundChannel1.stop()
            }
            
            if !regNR52.sound2Enabled {
                soundChannel2.stop()
            }
            
            if !regNR52.sound3Enabled {
                soundChannel3.stop()
            }
            
            if !regNR52.sound4Enabled {
                soundChannel4.stop()
            }
            break
        
        }
        
    }
    
    func getReg(reg: SoundRegister) -> Int {
        switch reg {
      
        case .nr10:
            return regNR10.getVal()
        case .nr11:
            return soundChannel1.regNRx1.getVal()
        case .nr12:
            return soundChannel1.regNRx2.getVal()
        case .nr13:
            return soundChannel1.regNRx3.getVal()
        case .nr14:
            return soundChannel1.regNRx4.getVal()
            
            
        case .nr21:
            return soundChannel2.regNRx1.getVal()
        case .nr22:
            return soundChannel2.regNRx2.getVal()
        case .nr23:
            return soundChannel2.regNRx3.getVal()
        case .nr24:
            return soundChannel2.regNRx4.getVal()
            
            
        case .nr52:
            return regNR52.getVal()
        case .nr30:
            return regNR30.getVal()
        case .nr31:
            return regNR31.getVal()
        case .nr32:
            return regNR32.getVal()
        case .nr33:
            return regNR33.getVal()
        case .nr34:
            return regNR34.getVal()
            
        case .nr41:
            return soundChannel4.regNR41.getVal()
        case .nr42:
            return soundChannel4.regNR42.getVal()
        case .nr43:
            return soundChannel4.regNR43.getVal()
        case .nr44:
            return soundChannel4.regNR44.getVal()
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
                soundChannel1.onLengthCounterTick()
                soundChannel2.onLengthCounterTick()                
                soundChannel3.onLengthCounterTick()
                soundChannel4.onLengthCounterTick()
                // 128 Hz
                if step == 2 || step == 6 {
                    soundChannel1.onSweepTick()
                }
                
            } else if step == 7 {
                // 64Hz
                soundChannel1.onVolumEnvlopTick()
                soundChannel2.onVolumEnvlopTick()
                soundChannel4.onVolumEnvlopTick()
            }
            
        }
        if frameSequencerTickCount > 512 {
            frameSequencerTickCount = 0
        }
    }
    
    func reset() {
        soundChannel1.reset()
        soundChannel2.reset()
        soundChannel3.reset()
        soundChannel4.reset()
    }
    
}

