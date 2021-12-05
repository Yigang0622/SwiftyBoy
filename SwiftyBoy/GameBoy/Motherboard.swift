//
//  Motherboard.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

class Motherboard {
    
    public let cpu = CPU()
    
    public var memory = Array<UInt8>(repeating: 0x00, count: 0xFFFF)
    
    init() {
        cpu.mb = self
    }
    
    public func getMem(address: Int) -> Int {
        return Int(memory[Int(address)])
    }
    
    public func setMem(address: Int, val: Int) {
        memory[address] = UInt8(val & 0xFF)
    }
    
    
}
