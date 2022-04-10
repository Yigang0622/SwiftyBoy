//
//  SoundChannelDelegate.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/10.
//

import Foundation

protocol SoundChannelDelegate {

    func onTriggerEvent()
    
    func onLengthCounterTick()
    
    func onVolumEnvlopTick()
    
    func onSweepTick()
    
}
