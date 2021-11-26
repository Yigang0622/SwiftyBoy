//
//  Motherboard.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

class Motherboard {
    
    public let cpu = CPU()
    
    private var memory = Array<UInt8>(repeating: 0xFF, count: 64 * 1024)
    
    init() {
        cpu.motherboard = self
    }
    
    public func getMem(address: UInt) -> UInt {
        return UInt(memory[Int(address)])
    }
    
    public func setMem(address: UInt, val: UInt8) {
        memory[Int(address)] = val
    }
    
    
}
