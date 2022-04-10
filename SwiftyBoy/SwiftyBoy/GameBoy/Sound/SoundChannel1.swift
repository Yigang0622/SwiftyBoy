//
//  SoundChannel1.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import Foundation

class SoundChannel1: ToneSoundChannel {
    
    var sweepPeriod = 0
    var sweepDirection = 0
    var sweepShift = 0
    
    private var sweepShiftLeft = 0
    private var sweepTickCounter = 0
    
    private var sweepEnabled: Bool {
        get {
            return sweepPeriod > 0
        }
    }
    
    // for copy
    private var lastFrequency:Float = 0
    
    /**
     When it generates a clock and the sweep's internal enabled flag is set and the sweep period is not zero, a new frequency is calculated and the overflow check is performed. If the new frequency is 2047 or less and the sweep shift is not zero, this new frequency is written back to the shadow frequency and square 1's frequency in NR13 and NR14, then frequency calculation and overflow check are run AGAIN immediately using this new value, but this second new frequency is not written back.
     */
    override func onSweepTick() {
        if sweepEnabled && sweepShiftLeft > 0 {
            sweepTickCounter += 1
            sweepShiftLeft -= 1
            if sweepTickCounter == sweepPeriod {
                sweepTickCounter = 0
                calculateAndUpdateSweepFrequency()
            }
        }
    }
    
    // todo weite back to register
    private func calculateAndUpdateSweepFrequency()  {
        var newFrequency: Float = 0
        // add
        if sweepDirection == 0 {
            newFrequency = lastFrequency + lastFrequency / pow(2, Float(sweepShift))
        } else if sweepDirection == 1 {
            // subtraction
            newFrequency = lastFrequency - lastFrequency / pow(2, Float(sweepShift))
        }
        if newFrequency > 2047 {
            osc.stop()
        } else {
            print("update sweep freq \(newFrequency)")
            osc.frequency = newFrequency
            lastFrequency = newFrequency
        }
    }
    
    override func onTriggerEvent() {
        
        // Square 1's frequency is copied to the shadow register.
        lastFrequency = frequency
        // The sweep timer is reloaded.
        sweepTickCounter = 0
        sweepShiftLeft = sweepShift
        // The internal enabled flag is set if either the sweep period or shift are non-zero, cleared otherwise.
        
        // If the sweep shift is non-zero, frequency calculation and the overflow check are performed immediately.
        if sweepShift > 0 {
            calculateAndUpdateSweepFrequency()
        }
        super.onTriggerEvent()
    }
    
}
