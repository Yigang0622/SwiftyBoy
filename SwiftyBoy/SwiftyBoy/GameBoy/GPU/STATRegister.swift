//
//  StatRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/8.
//

import Foundation

enum STATModeFlag: Int {
    case mode00 = 0
    case mode01 = 1
    case mode10 = 2
    case mode11 = 3
}

class STATRegister: BaseRegister {
    
    var modeFlag: STATModeFlag = .mode00
    var lyMatchFlag = false
    
    var lyMatchInterruptEnable = false
    var mode00InterruptEnable = false
    var mode01InterruptEnable = false
    var mode10InterruptEnable = false
    
    override func setVal(val: Int) {
        lyMatchInterruptEnable = (val >> 6) & 1 == 1
        mode10InterruptEnable = (val >> 5) & 1 == 1
        mode01InterruptEnable = (val >> 4) & 1 == 1
        mode00InterruptEnable = (val >> 3) & 1 == 1
    }
    
    override func getVal() -> Int {
        let bit2 = lyMatchFlag.integerValue << 2
        let bit3 = mode00InterruptEnable.integerValue << 3
        let bit4 = mode01InterruptEnable.integerValue << 4
        let bit5 = mode10InterruptEnable.integerValue << 5
        let bit6 = lyMatchInterruptEnable.integerValue << 6        
        return modeFlag.rawValue | bit2 | bit3 | bit4 | bit5 | bit6
    }
    
    
}
