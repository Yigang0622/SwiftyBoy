//
//  ToneSoundChannelTypedef.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/9.
//

import Foundation
import AudioKit

class ToneSoundChannel: SoundChannelBase {
    
    var regNRx1: RegSoundLengthAndWaveDuty = RegSoundLengthAndWaveDuty(val: 0)
    var regNRx2: RegEnvelopParam = RegEnvelopParam(val: 0)
    var regNRx3: RegFrequencyLo = RegFrequencyLo(val: 0)
    var regNRx4: RegInitializeParam = RegInitializeParam(val: 0)
    
    internal var waveDuty: WaveDuty {
        get {
            regNRx1.waveDuty
        }
        set {
            regNRx1.waveDuty = newValue
        }
    }
    
    internal var frequencyData: Int {
        get {
            return regNRx4.frequencyHiData << 8 | regNRx3.frequencyLoData
        }
        set {
            regNRx3.frequencyLoData = newValue & 0xFF
            regNRx4.frequencyHiData = (newValue & 0b111_00000000) >> 8
        }
    }
    
    internal var lengthEnable: Bool {
        get {
            return regNRx4.lengthEnable
        }
        set {
            regNRx4.lengthEnable = newValue
        }
    }
    
    
    internal var startVolume: Int {
        get {
            return regNRx2.startVolume
        }
        set {
            regNRx2.startVolume = newValue
        }
    }
    
    internal var volEnvelopePeriod: Int {
        get {
            return regNRx2.volEnvelopePeriod
        }
        set {
            regNRx2.volEnvelopePeriod = newValue
        }
    }
    
    internal var volEnvelopeMode: EnvelopMode {
        get {
            return regNRx2.volEnvelopeMode
        }
        set {
            regNRx2.volEnvelopeMode = newValue
        }
    }
    
    internal var soundLength: Int {
        get {
            return regNRx1.soundLength
        }
        set {
            regNRx1.soundLength = newValue
        }
    }
    
    private var _volume: Int = 0xF
    private var _volEnvelopPeriodCounter = 0
    private var _soundLength = 0
    
    private let TICK_NUM_ONE_SEC = 4194304

    private var waveTable: [WaveDuty: Table]!
    
    override init() {
        super.init()
        waveTable = [
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
        
        self._soundLength = 64 - soundLength
        // Volume envelope timer is reloaded with period.
        _volEnvelopPeriodCounter = 0
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
        _volEnvelopPeriodCounter += 1
        if _volEnvelopPeriodCounter == volEnvelopePeriod {
            _volEnvelopPeriodCounter = 0
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
