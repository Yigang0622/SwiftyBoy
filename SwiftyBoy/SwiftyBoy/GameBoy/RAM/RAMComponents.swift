//
//  NonIOInternalRam1.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/18.
//

import UIKit


/**
 8kb internal ram 0 C000 - 0xE000
 and
 Echo of 8kB Internal RAM 0xE000 - 0xFE00
 */
class InternalRam0: RamBase {
    
    private var echoOffset = 0x2000
    
    init() {
        super.init(count: 8 * 1024, offset: 0xC000)
    }
    
    override func canAccess(address: Int) -> Bool {
        return (address >= 0xC000 && address < 0xE000) || (address >= 0xE000 && address < 0xFE00)
    }
    
    override func getMem(address: Int) -> Int {
        // Echo
        if address >= 0xE000 && address < 0xFE00 {
            return ram[address - echoOffset - offset]
        }
        return super.getMem(address: address)
        
    }
    
    override func setMem(address: Int, val: Int) {
        // Echo
        if address >= 0xE000 && address < 0xFE00 {
            ram[address - echoOffset - offset] = val
        } else {
            super.setMem(address: address, val: val)
        }
    }
}

/**
 Empty but unusable for I/O FEA0 - FF00
 */
class NonIoInternalRam0: RamBase {
    
    init() {
        super.init(count: 0x60, offset: 0xFEA0)
    }
    
}

/**
 I/O ports FF00 - FF4C
 */
class IoPortsRam: RamBase {
    
    init() {
        super.init(count: 0x4C, offset: 0xFF00)
    }
    
}

/**
 Empty but unusable for I/O FF4C - FF80
 */
class NonIoInternalRam1: RamBase {

    init() {
        super.init(count: 0x34, offset: 0xFF4C)
    }
    
}

class InternalRam1: RamBase {
    
    init() {
        super.init(count: 0x7F, offset:  0xFF80)
    }
    
}
