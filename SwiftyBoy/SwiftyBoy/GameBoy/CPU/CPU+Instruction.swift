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
                interruptMasterEnable = false
                pushPCToStack()
                pc = 0x60
                interruptFlagRegister.highToLow = false
            } else {
                print("no interrupts")
            }
        }
    }
    
    func printLogs() {
        for each in logs {
            print(each)
        }
    }
    
    func fetchAndExecute() -> Int {
        
//        if mb.serialOutput == "06-ld r,r\n\n" {
//            start = true
//        } else if mb.serialOutput == "06-ld r,r\n\n0" {
//            printOpD()
//        }
        
        

        handleInterruptes()

        var opcode = mb.getMem(address: pc)
        if opcode == 0xCB {
            opcode = mb.getMem(address: pc + 1)
//            let log = "\(String(format:"%02X", pc)): \(String(format:"CB-%02X", opcode)) \(cbInstructions[opcode]!.name)"
//
//            logs.append(log)
//

            
            let cycle = cbInstructions[opcode]!.instruction()
            return cycle
        } else {
//            let log = "\(String(format:"%02X", pc)): \(String(format:"%02X", opcode)) \(baseInstructions[opcode]!.name)"
//            logs.append(log)
//            
            let cycle = baseInstructions[opcode]!.instruction()
            return cycle
        }
    }
    
    func printOpD() {
        var t = [(String, Int)]()
        opD.forEach { key, val in
            t.append((key, val))
        }
        t = t.sorted { a, b in
            return a.1 > b.1
        }
        for each in t {
            print("\(each.0)    \(each.1)")
        }
    }
    
    
}
