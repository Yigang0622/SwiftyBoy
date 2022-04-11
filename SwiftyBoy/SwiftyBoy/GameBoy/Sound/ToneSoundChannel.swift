//
//  ToneSoundChannelTypedef.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/9.
//

import Foundation
import AudioKit

class ToneSoundChannel: SoundChannelBase {
    

    var waveDuty: WaveDuty = .duty0
//    var frequency: Float = 0
    var frequencyData: Int = 0
    var lengthEnable = false
    private var _soundLength = 0
    
    var startVolume: Int = 0xF
    var _volume: Int = 0xF
    var volEnvelopeMode: EnvelopMode = .attenuate
    private var volEnvelopPeriodCounter = 0
    var volEnvelopePeriod: Int = 0
    
    var soundLength: Int {
        get {
            return _soundLength
        }
        set {
            _soundLength = 64 - newValue
        }
    }
    
    private let TICK_NUM_ONE_SEC = 4194304

    private var waveTable: [WaveDuty: Table]!
    
    override init() {
        super.init()
        waveTable = [
            .duty0:  audioKitTable(dutyCycle: 0),
            .duty12_5: audioKitTable(dutyCycle: 0.125),
            .duty25: audioKitTable(dutyCycle: 0.25),
            .duty50: audioKitTable(dutyCycle: 0.50),
            .duty75: audioKitTable(dutyCycle: 0.75)]
    }
    
    private func audioKitTable(dutyCycle: Double) -> Table {
        let size = 4096
        var content = [Table.Element](zeros: size)
        for i in 0..<Int(Double(size) * dutyCycle) {
            content[i] = 1.0
        }
        return Table(content)
    }
    
    override func onTriggerEvent() {
        // channel is enabled
        osc.start()
        // length counter reset
        if self._soundLength == 0 {
            self._soundLength = 64
        }
        // Volume envelope timer is reloaded with period.
        volEnvelopPeriodCounter = 0
        // Channel volume is reloaded from NRx2.
        _volume = startVolume
        // freq & waveform update
        setOscFrequency(x: frequencyData)
        let waveform = self.waveTable[self.waveDuty]
        osc.setWaveTable(waveform: waveform!)
    }
    
 
    
    /**
     Each length counter is clocked at 256 Hz by the frame sequencer. When clocked while enabled by NRx4 and the counter is not zero, it is decremented. If it becomes zero, the channel is disabled.
     */
    override func onLengthCounterTick() {
        if lengthEnable && _soundLength > 0 {
            _soundLength -= 1            
            if _soundLength == 0 {
                print("stop")
                osc.stop()
            }
        }
        
    }
    
    override func onVolumEnvlopTick() {
        volEnvelopPeriodCounter += 1
        if volEnvelopPeriodCounter == volEnvelopePeriod {
            volEnvelopPeriodCounter = 0
            if _volume > 0 && _volume < 16 {
                if volEnvelopeMode == .amplify {
                    print("\(self) update volum + \(_volume)")
                    _volume += 1
                } else if volEnvelopeMode == .attenuate {
                    print("\(self) update volum - \(_volume)")
                    _volume -= 1
                }
            }            
        }
        
        if _volume >= 0 && _volume <= 15 {
            osc.amplitude = oscBaseAmplitude * (Float(_volume) / 15.0)
        } else if _volume < 0 {
            // todo write back to register
            osc.stop()
        }
        
    }
    
    override func onSweepTick() {
        
    }

}
