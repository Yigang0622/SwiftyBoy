//
//  CPU+Util.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/27.
//

import Foundation

extension CPU {
    
    /// 读取address 和 address + 1的内容拼成16位，ls byte 在前
    /// 大端处理器
    func get16BitMem(address: Int) -> Int {
        let fs = mb.getMem(address: address + 1)
        let ls = mb.getMem(address: address)
        return fs << 8 + ls
    }
    
    func get8BitImmediate() -> Int {
        return mb.getMem(address: pc + 1)
    }
    
    func get16BitImmediate() -> Int {
        return get16BitMem(address: pc + 1)
    }
    
    func get8BitSignedImmediateValue() -> Int {
        let v: Int = Int(mb.getMem(address: pc + 1))
        return (v & 0x80) - 0x80
    }
    
    func getHalfCarryForAdd(oprand1: Int, oprand2: Int) -> Bool {
        return (oprand1 & 0xF) + (oprand2 & 0xF) > 0xF
    }
    
    func getFullCarryForAdd(oprand1: Int, oprand2: Int) -> Bool {
        return oprand1 + oprand2 > 0xFF
    }
    
    func getHalfCarryForSub(oprand1: Int, oprand2: Int) -> Bool {
        return (oprand1 & 0xF) - (oprand2 & 0xF) < 0x0
    }
    
    func getFullCarryForSub(oprand1: Int, oprand2: Int) -> Bool {
        return oprand1 - oprand2 < 0x0
    }
}

