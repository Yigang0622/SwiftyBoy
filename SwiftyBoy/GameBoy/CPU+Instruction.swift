//
//  CPU+Instruction.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

struct CPUInstruction {
    var name: String
    var opcode: UInt8
    var inscruction: () -> Int
}

extension CPU {
    
    func execute(opcode: UInt) -> Int {
        if baseInstructions[Int(opcode)] != nil{
            print("exec op \(String(format:"%02X", opcode))")
            let cycle = baseInstructions[Int(opcode)]!.inscruction()
            return cycle
        } else {
            print("invailed opcode")
            return 0
        }
    }
    
    func LD_B_N() -> Int {
        let v = motherboard.getMem(address: self.pc + 1)
        b = v
        self.pc += 2
        return 8
    }
    
    func LD_C_N() -> Int {
        let v = motherboard.getMem(address: self.pc + 1)
        c = v
        self.pc += 2
        return 8
    }
    
    func LD_D_N() -> Int {
        let v = motherboard.getMem(address: self.pc + 1)
        d = v
        self.pc += 2
        return 8
    }
    
    func LD_E_N() -> Int {
        let v = motherboard.getMem(address: self.pc + 1)
        e = v
        self.pc += 2
        return 8
    }
    
    func LD_H_N() -> Int {
        let v = motherboard.getMem(address: self.pc + 1)
        h = v
        self.pc += 2
        return 8
    }
    
    func LD_L_N() -> Int {
        let v = motherboard.getMem(address: self.pc + 1)
        l = v
        self.pc += 2
        return 8
    }
    
    func LD_A_A() -> Int {
        a = a
        self.pc += 1
        return 4
    }
    
    func LD_A_B() -> Int {
        a = b
        self.pc += 1
        return 4
    }
    
    func LD_A_C() -> Int {
        a = c
        self.pc += 1
        return 4
    }
    
    func LD_A_D() -> Int {
        a = d
        self.pc += 1
        return 4
    }
    
    func LD_A_E() -> Int {
        a = e
        self.pc += 1
        return 4
    }
    
    func LD_A_H() -> Int {
        a = h
        self.pc += 1
        return 4
    }
    
    func LD_A_L() -> Int {
        a = l
        self.pc += 1
        return 4
    }
    
    
}
