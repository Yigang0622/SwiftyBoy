//
//  SoundChannelBase.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import Foundation
import AudioKit

class SoundChannelBase: SoundChannelDelegate {
    
    var osc: DynamicOscillator!
    var oscBaseAmplitude: Float = 0.5
 
    var stopped: Bool {
        get {
            osc.isStopped
        }
    }
    
    init() {
        osc = DynamicOscillator()
        osc.amplitude = 0.5
        osc.frequency = 0
    }
    
    func stop() {
        osc.stop()
    }
    
    func setOscFrequency(x: Int) {
        let f = 131072 / (2048 - x)
        print("\(self) freq \(f)")
        osc.frequency = Float(f)
        
    }
    
    func onTriggerEvent() {
        
    }
    
    func onVolumEnvlopTick() {
        
    }
    
    func onSweepTick() {
        
    }
    
    func onLengthCounterTick() {
        
    }
    
    func reset() {
        osc.amplitude = oscBaseAmplitude
        osc.stop()        
    }
    
}
