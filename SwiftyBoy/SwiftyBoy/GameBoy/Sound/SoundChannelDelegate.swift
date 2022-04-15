//
//  SoundChannelDelegate.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import Foundation

protocol SoundChannelDelegate {

    func onTriggerEvent()
    
    // Frame sequencer
    func onLengthCounterTick()
    
    func onVolumEnvlopTick()
    
    func onSweepTick()
    
}
