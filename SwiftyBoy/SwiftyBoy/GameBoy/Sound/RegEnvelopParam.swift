//
//  RegEnvelopParam.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

enum EnvelopMode: Int {
    case attenuate = 0
    case amplify = 1
}

class RegEnvelopParam: BaseRegister {
    
    var startVolume: Int = 0
    var volEnvelopeMode: EnvelopMode = .attenuate
    var volEnvelopePeriod: Int = 0
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        startVolume = (val & 0xF0) >> 4
        volEnvelopeMode = EnvelopMode(rawValue: (val & 0b0000_1000) >> 3)!
        volEnvelopePeriod = val & 0b00000111
    }
    
}
