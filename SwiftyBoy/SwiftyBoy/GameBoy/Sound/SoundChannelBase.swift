//
//  SoundChannelBase.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import Foundation
import AudioKit

class SoundChannelBase {
    
    var osc: DynamicOscillator!
 
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
    
}
