//
//  CPUTimer+MemoryAccess.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/17.
//

import Foundation

extension CPUTimer: MemoryAccessable {
    
    /**
     DIV  0xFF04
     TIMA 0xFF05
     TMA 0xFF06
     TAC 0xFF07
     */
    func canAccess(address: Int) -> Bool {
        return (address >= 0xFF04 && address <= 0xFF07)
    }
    
    func getMem(address: Int) -> Int {
        if address == 0xFF04 {
            // timer DIV
            return div
        } else if address == 0xFF05 {
            // timer TIMA
            return tima
        } else if address == 0xFF06 {
            // timer TMA
            return tma
        } else if address == 0xFF07 {
            // timer TAC
            return tac
        }
        print("\(self) memory access error \(address.asHexString)")
        return 0
    }
    
    func setMem(address: Int, val: Int) {
        if address == 0xFF04 {
           // timer DIV
           self.reset()
       } else if address == 0xFF05 {
           // timer TIMA
           self.tima = (val & 0xFF)
       } else if address == 0xFF06 {
           // timer TMA
           self.tma = (val & 0xFF)
       } else if address == 0xFF07 {
           // timer TAC
           self.tac = (val & 0xFF)
       }
    }
    
}
