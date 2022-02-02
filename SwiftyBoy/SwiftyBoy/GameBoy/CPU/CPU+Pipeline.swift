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
    

    func handleInterruptes() {
        
        if interruptMasterEnable {
            if interruptFlagRegister.vblank && interruptEnableRegister.vblank {
//                print("v-blank")
                interruptMasterEnable = false
                pushPCToStack()
                pc = 0x40
                interruptFlagRegister.vblank = false
            } else if interruptFlagRegister.lcdc && interruptEnableRegister.lcdc {
                interruptMasterEnable = false
                pushPCToStack()
                pc = 0x48
                interruptFlagRegister.lcdc = false
            } else if interruptFlagRegister.timerOverflow && interruptEnableRegister.timerOverflow {
//                print("overflow")
                interruptMasterEnable = false
                pushPCToStack()
                pc = 0x50
                interruptFlagRegister.timerOverflow = false
            } else if interruptFlagRegister.serial && interruptEnableRegister.serial {
                interruptMasterEnable = false
                pushPCToStack()
                pc = 0x58
                interruptFlagRegister.serial = false
            } else if interruptFlagRegister.highToLow && interruptEnableRegister.highToLow {
//                print("high to low")
                interruptMasterEnable = false
                pushPCToStack()
                pc = 0x60
                interruptFlagRegister.highToLow = false
            } else {
//                print("no interrupts")
            }
        }
    }
    
    func interruptRequested() -> Bool {
        return interruptFlagRegister.getVal() > 0
    }
    
    func fetchAndExecute() -> Int {
        
        if self.halted && interruptRequested() {
//            print("exit halt")
            halted = false
        }
        
        handleInterruptes()
        
        if halted {
            return 4
        }

        var opcode = mb.getMem(address: pc)
        if opcode == 0xCB {
            opcode = mb.getMem(address: pc + 1)
            let cycle = cbInstructions[opcode]!.instruction()
            return cycle
        } else {
            let cycle = baseInstructions[opcode]!.instruction()
            return cycle
        }
    }
    
}
