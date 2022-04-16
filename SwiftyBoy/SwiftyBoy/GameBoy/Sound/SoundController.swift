//
//  SoundController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/9.
//

import Foundation
import AudioKit

enum WaveDuty: Int {
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

enum SoundChannelType {
    case channel1
    case channel2
    case channel3
    case channel4
}

class SoundController {
    
    private let engine = AudioEngine()
    private let mixer = Mixer()
            
    private var regNR52: RegNR52 = RegNR52(val: 0)
    
    private var soundChannel1: SoundChannel1 = SoundChannel1()
    private var soundChannel2: SoundChannel2 = SoundChannel2()
    private var soundChannel3: SoundChannel3 = SoundChannel3()
    private var soundChannel4: SoundChannel4 = SoundChannel4()
    
    private var cpuTickCount = 0
    private var frameSequencerTickCount = 0
    private static let CPU_TICK_NUM_ONE_SEC = 4194304
    private static let FRAME_SEQUENCER_FREQUENCE = 512
    private let TICK_NUM_TARGET = CPU_TICK_NUM_ONE_SEC / FRAME_SEQUENCER_FREQUENCE
    
    init() {
        
        mixer.addInput(soundChannel1.osc)
        mixer.addInput(soundChannel2.osc)
        mixer.addInput(soundChannel3.osc)
        mixer.addInput(soundChannel4.osc)
        engine.output = mixer
    
        do {
            try engine.start()
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func setWaveReg(index: Int, val: Int) {
        soundChannel3.setWaveReg(index: index, val: val)
    }
    
    func getWaveReg(index: Int) -> Int {
        return soundChannel3.getWaveReg(index: index)
    }
    
    func setReg(reg: SoundRegister, val: Int){
        switch reg {
        // square 1
        case .nr10:
            soundChannel1.regNR10.setVal(val: val)
            print("soundChannel1 nr10 \(val.asHexString) sweep period set \(soundChannel1.regNR10.sweepPeriod) shift \(soundChannel1.regNR10.sweepShift)")
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
            soundChannel3.regNR30.setVal(val: val)
            if !soundChannel3.regNR30.soundEnable {
                soundChannel3.stop()
            }
            break
        case .nr31:
            soundChannel3.regNR31.setVal(val: val)
            break
        case .nr32:
            soundChannel3.regNR32.setVal(val: val)
            break
        case .nr33:
            soundChannel3.regNR33.setVal(val: val)
            break
        case .nr34:
            soundChannel3.regNR34.setVal(val: val)
            if soundChannel3.regNR34.initializationFlag {
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
            return soundChannel1.regNR10.getVal()
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
            return soundChannel3.regNR30.getVal()
        case .nr31:
            return soundChannel3.regNR31.getVal()
        case .nr32:
            return soundChannel3.regNR32.getVal()
        case .nr33:
            return soundChannel3.regNR33.getVal()
        case .nr34:
            return soundChannel3.regNR34.getVal()
            
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
    
    func setChannelStatus(channel: SoundChannelType, enable: Bool) {
        let sound: SoundChannelBase
        switch channel {
        case .channel1:
            sound = soundChannel1
        case .channel2:
            sound = soundChannel2
        case .channel3:
            sound = soundChannel3
        case .channel4:
            sound = soundChannel4
        }
        
        if enable {
            mixer.addInput(sound.osc)
        } else {
            mixer.removeInput(sound.osc)
        }
    }
    
}

