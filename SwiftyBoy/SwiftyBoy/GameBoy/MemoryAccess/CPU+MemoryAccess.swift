//
//  CPU+MemoryAccess.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/18.
//

import Foundation

extension CPU: MemoryAccessable {
    
    /**
     0xFF0F IF
     0xFFFF IE
     */
    func canAccess(address: Int) -> Bool {
        return (address == 0xFF0F) || (address == 0xFFFF)
    }
    
    func getMem(address: Int) -> Int {
        if address == 0xFF0F {
            // CPU interruptes flag
            return interruptFlagRegister.getVal()
        } else if (address == 0xFFFF) {
            // IE
            return interruptEnableRegister.getVal()
        }
        print("\(self) get mem error \(address.asHexString)")
        return 0
    }
    
    func setMem(address: Int, val: Int) {
        if address == 0xFF0F {
            // CPU interruptes flag
            interruptFlagRegister.setVal(val: (val & 0xFF))
        } else if (address == 0xFFFF) {
            // IE
            interruptEnableRegister.setVal(val: (val & 0xFF))
        }
    }
    
}
