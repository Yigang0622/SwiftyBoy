//
//  SoundChannel1.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import Foundation

class SoundChannel1: ToneSoundChannel {
    
    var regNR10: RegNR10 = RegNR10(val: 0)
    
    private var sweepPeriod: Int {
        get {
            return regNR10.sweepPeriod
        }
        set {
            regNR10.sweepPeriod = newValue
        }
    }
    
    
    private var sweepDirection: SweepDirection {
        get {
            return regNR10.sweepDirection
        }
        set {
            regNR10.sweepDirection = newValue
        }
    }
    private var sweepShift: Int {
        get {
            return regNR10.sweepShift
        }
        set {
            regNR10.sweepShift = newValue
        }
    }
    
    private var _sweepTickCounter = 0
    
    private var sweepEnabled: Bool {
        get {
            return sweepPeriod > 0
        }
    }
    
    // for copy
    private var lastFrequencyData:Int = 0
    
    /**
     When it generates a clock and the sweep's internal enabled flag is set and the sweep period is not zero, a new frequency is calculated and the overflow check is performed. If the new frequency is 2047 or less and the sweep shift is not zero, this new frequency is written back to the shadow frequency and square 1's frequency in NR13 and NR14, then frequency calculation and overflow check are run AGAIN immediately using this new value, but this second new frequency is not written back.
     */
    override func onSweepTick() {
        if sweepEnabled {
            _sweepTickCounter += 1
            if _sweepTickCounter == sweepPeriod {
                _sweepTickCounter = 0
                calculateAndUpdateSweepFrequency()
            }
        }
    }
    
    // todo weite back to register
    private func calculateAndUpdateSweepFrequency()  {
        var newFrequencyData: Int = 0
        // add
        if sweepDirection == .addition {
            newFrequencyData = lastFrequencyData + Int(lastFrequencyData / Int(pow(Double(2), Double(sweepShift))))
        } else if sweepDirection == .subsctraction {
            // subtraction
            newFrequencyData = lastFrequencyData - Int(lastFrequencyData / Int(pow(Double(2), Double(sweepShift))))
        }
        if newFrequencyData > 2047 {
            osc.stop()
        } else {
            if !osc.isStopped {
                print("update sweep freq \(newFrequencyData)")
                setOscFrequency(x: newFrequencyData)
                lastFrequencyData = newFrequencyData
            }           
        }
    }
    
    override func onTriggerEvent() {
        
        // Square 1's frequency is copied to the shadow register.
        lastFrequencyData = frequencyData
        // The sweep timer is reloaded.
        _sweepTickCounter = 0
        // The internal enabled flag is set if either the sweep period or shift are non-zero, cleared otherwise.
        
        // If the sweep shift is non-zero, frequency calculation and the overflow check are performed immediately.
        if sweepShift > 0 {
            calculateAndUpdateSweepFrequency()
        }
        super.onTriggerEvent()
    }
    
}
