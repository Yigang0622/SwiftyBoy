//
//  StatRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/8.
//

import Foundation

class STATRegister: BaseRegister {
    
    var mode:GPUState = .oamSearch
    var coincidenceFlag = false
    
    func setCoincidenceFlag(flag: Bool) {
        flag ? setBit(n: 2) : clearBit(n: 2)
        coincidenceFlag = flag
    }
    
    func setMode(mode: GPUState) {
        clearBit(n: 3)
        clearBit(n: 4)
        clearBit(n: 5)
        if mode == .hBlank {
            clearBit(n: 0)
            clearBit(n: 1)
            setBit(n: 3)
        } else if mode == .vBlank {
            setBit(n: 0)
            clearBit(n: 1)
            setBit(n: 4)
        } else if mode == .oamSearch {
            clearBit(n: 0)
            setBit(n: 1)
            setBit(n: 5)
        } else if mode == .pixelTransfer {
            setBit(n: 1)
            setBit(n: 1)
        }
    }
    
}
