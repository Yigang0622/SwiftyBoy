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
//        print("-> get 16 bit mem result \((fs << 8 + ls).asHexString)")
        return fs << 8 + ls
    }
    
    func get8BitImmediate() -> Int {
//        print("-> get 8 bit mem result \(mb.getMem(address: pc + 1).asHexString)")
        return mb.getMem(address: pc + 1)
    }
    
    func get16BitImmediate() -> Int {
        return get16BitMem(address: pc + 1)
    }
    
    func get8BitSignedImmediateValue() -> Int {
        let v: Int = Int(mb.getMem(address: pc + 1))
        return (v ^ 0x80) - 0x80
    }
    
    func getHalfCarryForAdd(operands: Int...) -> Bool {
        var result = 0
        for each in operands{
            result += each & 0xF
        }
        return result > 0xF
    }
    
    func getFullCarryForAdd(operands: Int...) -> Bool {
        var result = 0
        for each in operands{
            result += each
        }
        return result > 0xFF
    }
    
    func getHalfCarryForSub(operands: Int...) -> Bool {
        var temp = operands
        var result = temp[0] & 0xF
        temp.remove(at: 0)
        for each in temp {
            result -= each & 0xF
        }
        return result < 0
    }
    
    func getFullCarryForSub(operands: Int...) -> Bool {
        var temp = operands
        var result = temp[0]
        temp.remove(at: 0)
        temp.forEach { each in
            result -= each
        }
        return result < 0
    }
    
    func getZeroFlag(val: Int) -> Bool {
        return (val & 0xFF) == 0x0
    }
    
    func pushPCToStack() {
        print("push \(pc >> 8) \(pc & 0xFF)")
        mb.setMem(address: sp - 1, val: pc >> 8) // High
        mb.setMem(address: sp - 2, val: pc & 0xFF) // Low
        sp -= 2
    }
    
    func popPCFromStack() {
        pc = popFromStack(numOfByte: 2)
        print("PC set to \(String(format:"%02X", pc))")
    }
    
    func popFromStack(numOfByte: Int) -> Int{
        if numOfByte == 1 {
            let n = mb.getMem(address: sp)
            sp += 1
            return n
        } else if numOfByte == 2 {
            let l = mb.getMem(address: sp)
            let h = mb.getMem(address: sp + 1)
            sp += 2
            return h << 8 | l
        } else {
            print("popFromStack error")
            return 0
        }
    }
    
    func swap(val: Int) -> Int {
        if val == 0 {
            return 0
        }
        return ((val & 0xF0) >> 4) | ((val & 0x0F) << 4) & 0xFF
    }
    
    func setBit(n: Int, val: Int) -> Int {
        return val | (1 << n)
    }
    
    func resetBit(n :Int, val: Int) -> Int {
        return val & ~(1 << n)
    }
    
}


extension Bool {
    var integerValue: Int {
        get {
            return self == true ? 1 : 0
        }
    }
}

extension Int {
    
    var asHexString: String {
        get {
            return String(format:"%02X", self)
        }
    }
    
}
