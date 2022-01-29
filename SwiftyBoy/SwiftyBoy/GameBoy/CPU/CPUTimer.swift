//
//  CPUTimer.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/19.
//

import Foundation

class CPUTimer {
    
    var mb:Motherboard!
    var div = 0
    var tima = 0
    var tma = 0
    var tac = 0
    
    
    var divCounter = 0
    var timaCounter = 0
    
    func tick(cycles: Int) {
        self.divCounter += cycles
        self.div += self.divCounter >> 8
        self.divCounter &= 0xFF
        self.div &= 0xFF
        
        if self.tac & 0b100 == 0 {
            return
        }
        
        self.timaCounter += cycles
        let divider = [1024, 16, 64, 256][self.tac & 0b11]
        
        if self.timaCounter >= divider {
            self.timaCounter -= divider
            self.tima += 1
            
            if self.tima > 0xFF {
                self.tima = self.tma
                self.tima &= 0xFF
                mb.cpu.interruptFlagRegister.timerOverflow = true
            }
            
        }
    }
    
    func reset() {
        self.div = 0
        self.divCounter = 0
        self.div = 0
        print("timer reset")
    }
    
}
