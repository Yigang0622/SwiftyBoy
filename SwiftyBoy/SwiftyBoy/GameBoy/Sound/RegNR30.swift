//
//  RegNR30.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

/**
 sound mode 3 (wave channel) NR30
 */
class RegNR30: BaseRegister {
    
    var soundEnable: Bool {
        set {
            newValue ? setBit(n: 7) : clearBit(n: 7)
        }
        get {
            return getBit(n: 7)
        }
    }
    
    override func getVal() -> Int {
        return super.getVal() & 0b10000000
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
    }

}
