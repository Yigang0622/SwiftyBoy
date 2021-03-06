//
//  RegNR34.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/11.
//

import UIKit

class RegNR34: BaseRegister {
    
    var initializationFlag: Bool {
        get {
            return getBit(n: 7)
        }
    }
    
    var lengthEnabled: Bool {
        get {
            return getBit(n: 6)
        }
        set {
            newValue ? setBit(n: 6) : clearBit(n: 6)
        }
    }
    
    var frequencyHiData: Int {
        get {
            return Int(_val) & 0b111
        }
        set {
            _val = (_val & 0b11111000) | (UInt8(newValue) & 0b00000111)
        }
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
    }
    
    override func getVal() -> Int {
        return super.getVal() & 0b01000000
    }
    

}
