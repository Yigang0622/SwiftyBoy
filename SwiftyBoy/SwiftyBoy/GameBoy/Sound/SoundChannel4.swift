//
//  SoundChannel4.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/14.
//

import UIKit
import AudioKit
import AVFAudio

class SoundChannel4: SoundChannelBase {
    
    var regNR41: RegNR41 = RegNR41(val: 0)
    var regNR42: RegNR42 = RegNR42(val: 0)
    var regNR43: RegNR43 = RegNR43(val: 0)
    var regNR44: RegNR44 = RegNR44(val: 0)
    
    private var lsfr7: LSFR = LSFR(length: 7)
    private var lsfr15: LSFR = LSFR(length: 15)
    
    internal var lengthEnable: Bool {
        get {
            return regNR44.lengthEnable
        }
        set {
            regNR44.lengthEnable = newValue
        }
    }
    
    
    internal var soundLength: Int {
        get {
            return regNR41.soundLength
        }
        set {
            regNR41.soundLength = newValue
        }
    }
    
    
    internal var startVolume: Int {
        get {
            return regNR42.startVolume
        }
        set {
            regNR42.startVolume = newValue
        }
    }
    
    internal var volEnvelopePeriod: Int {
        get {
            return regNR42.volEnvelopePeriod
        }
        set {
            regNR42.volEnvelopePeriod = newValue
        }
    }
    
    internal var volEnvelopeMode: EnvelopMode {
        get {
            return regNR42.volEnvelopeMode
        }
        set {
            regNR42.volEnvelopeMode = newValue
        }
    }
    
    
    private var _volume: Int = 0xF
    private var _volEnvelopPeriodCounter = 0
    private var _soundLength = 0
    
   
    override init() {
        super.init()
        osc.frequency = AUValue(1)
        
    }
    override func onTriggerEvent() {
        super.onTriggerEvent()
        osc.start()
        self._soundLength = 64 - soundLength
        
        _volEnvelopPeriodCounter = 0
        // Channel volume is reloaded from NRx2.
        _volume = startVolume
        
        let s: Int = regNR43.shiftClockFrequency
        let r: Int = regNR43.dividingRatio
        let divRatop: [Float] = [1/2.0, 1/4.0,1 / 8.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0, 1/16.0 ]
        let shiftRatio: [Float] = [2.0, 1.0, 1/2.0 , 1/3.0, 1/4.0, 1/5.0, 1/6.0, 1/7.0]
        let frequency = 4194304.0 * divRatop[s] / 8.0 * shiftRatio[r]
        
        print("\(self) pre calc \(frequency) s\(s) r\(r)")
        setOscFrequency(x: Int(frequency))
       
    }
    
    override func setOscFrequency(x: Int) {
        print("\(self) freq \(x)")
        
        let div = regNR43.counterStep == .step15 ? 32768 : 128
        
        var oscFreq = Int(x / div)
        
        var count = div
        if oscFreq == 0 {
            oscFreq = 1
            count = 32768
        }
        
        osc.frequency = AUValue(oscFreq)
        
        print("\(self) --> f \(oscFreq) count \(count) step \(regNR43.counterStep)")
        var table: [Float] = []
        switch regNR43.counterStep {
        case .step7:
            table = lsfr7.next(step: count).map({ each in
                return Float(each)
            })
            break
        case .step15:
            table = lsfr15.next(step: count).map({ each in
                return Float(each)
            })
            break
        }
        
           
        osc.setWaveTable(waveform: Table(table))
       
    }
    
    override func onLengthCounterTick() {
        if lengthEnable && _soundLength > 0 {
            _soundLength -= 1
            if _soundLength == 0 {
                print("\(self) stop")
                osc.stop()
            }
        }
    }
    
    override func onVolumEnvlopTick() {
//        osc.setWaveTable(waveform: waveform(stepWidth: regNR43.counterStep))
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
    

}
