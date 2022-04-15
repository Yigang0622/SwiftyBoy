//
//  BaseRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/8.
//

import Foundation

class BaseRegister {
    
    internal var _val: UInt8 = 0
    
    func setVal(val: Int) {
        self._val = UInt8(val & 0xFF)
    }
    
    func getVal() -> Int {
        return Int(_val)
    }
    
    init(val: Int) {
        setVal(val: val)
    }
    
    func setBit(n: Int) {
        _val = (_val | (1 << n))
    }
    
    func clearBit(n: Int) {
        _val = (_val & ~(1 << n))
    }
    
    func getBit(n: Int) -> Bool {
        return (_val >> n) & 0b1 == 1
    }
    
}
