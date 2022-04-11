//
//  RegNR32.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit
import Foundation

enum WaveOutputLevel: Int {
    case mute = 0
    case unmodified = 1
    case shift1bit = 2
    case shift2bit2 = 3
}

class RegNR32: BaseRegister {
    
    var outputLevel: WaveOutputLevel = .mute
    
    override func setVal(val: Int) {
        outputLevel = WaveOutputLevel(rawValue: (val & 0b01100000) >> 5)!
        super.setVal(val: (val & 0b01100000))        
    }
    
    override func getVal() -> Int {
        return (super.getVal() & 0b01100000)
    }

}
