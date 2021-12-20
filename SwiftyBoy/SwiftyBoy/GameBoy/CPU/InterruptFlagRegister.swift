//
//  InterruptFlagRegister.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/19.
//

import Foundation

class InterruptFlagRegister: BaseRegister {
    
    var vblank = false
    var lcdc = false
    var timerOverflow = false
    var serial = false
    var highToLow = false
    
    
    override init(val: Int) {
        super.init(val: val)
        setVal(val: val)
    }
    
    override func setVal(val: Int) {
        super.setVal(val: val)
        vblank = getBit(n: 0)
        lcdc = getBit(n: 1)
        timerOverflow = getBit(n: 2)
        serial = getBit(n: 3)
        highToLow = getBit(n: 4)
    }

}
