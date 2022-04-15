//
//  RegInitializeParam.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

class RegInitializeParam: BaseRegister {
    
    var initialize: Bool {
        get {
            return super.getBit(n: 7)
        }
        set {
            newValue ? setBit(n: 7) : clearBit(n: 7)
        }
    }
    
    var frequencyHiData: Int {
        get {
            return Int(_val) & 0b111
        }
        set {
            setVal(val: (super.getVal() & 0b11111000) | newValue & 0b00000111)
        }
    }
    
    var lengthEnable: Bool {
        get {
            return getBit(n: 6)
        }
        set {
            newValue ? setBit(n: 6) : clearBit(n: 6)
        }
    }
    
    override func getVal() -> Int {
        return super.getVal() & 0b01000000
    }
    
    
}
