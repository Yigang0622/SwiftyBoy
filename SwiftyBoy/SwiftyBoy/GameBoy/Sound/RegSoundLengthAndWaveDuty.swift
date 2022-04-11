//
//  RegSoundLengthAndDutyCycle.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

class RegSoundLengthAndWaveDuty: BaseRegister {

    var waveDuty: WaveDuty = .duty12_5
    var soundLength: Int = 0
    
    override func getVal() -> Int {
        return super.getVal() & 010000000
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        waveDuty = WaveDuty(rawValue: val >> 6)!
        soundLength = val & 0b11111
    }

}
