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
    var instruction: () -> Int
    var byteLength: Int
}

extension CPU {
    
    func fetchAndExecute() -> Int {
        var opcode = mb.getMem(address: pc)
        if opcode == 0xCB {
            pc += 1
            opcode = mb.getMem(address: pc)
            print("exec op \(String(format:"%02X", opcode))")
            let cycle = baseInstructions[opcode]!.instruction()
            return cycle
        } else {
            print("exec cb op \(String(format:"%02X", opcode))")
            let cycle = cbInstructions[opcode]!.instruction()
            return cycle
        }
    }
    
}
