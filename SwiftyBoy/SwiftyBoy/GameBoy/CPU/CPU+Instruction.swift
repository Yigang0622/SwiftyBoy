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
            opcode = mb.getMem(address: pc + 1)
//            print("\(String(format:"%02X", pc)): \(String(format:"CB-%02X", opcode)) \(cbInstructions[opcode]!.name)")
            let cycle = cbInstructions[opcode]!.instruction()
            return cycle
        } else {
//            print("\(String(format:"%02X", pc)): \(String(format:"%02X", opcode)) \(baseInstructions[opcode]!.name)")
            let cycle = baseInstructions[opcode]!.instruction()
            return cycle
        }
    }
    
}
