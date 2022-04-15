//
//  RegNR10Sweep.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

enum SweepDirection: Int {
    case addition = 0
    case subsctraction = 1
    
}

class RegSweepParam: BaseRegister {
    
    var sweepPeriod: Int = 0
    var sweepDirection: SweepDirection = .addition
    var sweepShift: Int = 0
    
    override func getVal() -> Int {
        return super.getVal() & 0b01111111
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        sweepPeriod = (val & 0b0111_0000) >> 4
        sweepDirection = SweepDirection(rawValue: (val & 0b1000) >> 3)!
        sweepShift = val & 0b0111
        
    }

}
