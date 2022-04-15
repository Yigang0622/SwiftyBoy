//
//  RegNR43.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/14.
//

import UIKit

enum CounterStep: Int {
    case step15 = 0
    case step7 = 1
}

class RegNR43: BaseRegister {

    var shiftClockFrequency: Int {
        get {
            return Int(_val) & 0b1111_0000 >> 4
        }
        set {
            setVal(val: (newValue & 0b1111_0000) & Int(_val) & 0b0000_1111 )
        }
    }
    
    var counterStep: CounterStep {
        get {
            return CounterStep(rawValue: getBit(n: 3).integerValue)!
        }
        set {
            newValue.rawValue == 1 ? setBit(n: 3) : clearBit(n: 3)
        }
        
    }
    var dividingRatio: Int {
        get {
            return Int(_val) & 0b0000_0111
        }
        set {
            setVal(val: (newValue & 0b0000_0111) & Int(_val) & 0b1111_1000)
        }
    }
    
}
