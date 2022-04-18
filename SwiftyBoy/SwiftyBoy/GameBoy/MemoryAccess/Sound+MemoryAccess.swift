//
//  Sound+MemoryAccess.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/17.
//

import Foundation

extension SoundController: MemoryAccessable {
    
    func getMem(address: Int) -> Int {
        if address == 0xFF10 {
            return getReg(reg: .nr10)
        } else if address == 0xFF11 {
            return getReg(reg: .nr11)
        } else if address == 0xFF12 {
            return getReg(reg: .nr12)
        } else if address == 0xFF13 {
            return getReg(reg: .nr13)
        } else if address == 0xFF14 {
            return getReg(reg: .nr14)
        } else if address == 0xFF16 {
            return getReg(reg: .nr21)
        } else if address == 0xFF17 {
            return getReg(reg: .nr22)
        } else if address == 0xFF18 {
            return getReg(reg: .nr23)
        } else if address == 0xFF19 {
            return getReg(reg: .nr24)
        }else if address == 0xFF1A {
            return getReg(reg: .nr30)
        } else if address == 0xFF1B {
            return getReg(reg: .nr31)
        } else if address == 0xFF1C {
            return getReg(reg: .nr32)
        } else if address == 0xFF1D {
            return getReg(reg: .nr33)
        } else if address == 0xFF1E {
            return getReg(reg: .nr34)
        } else if address == 0xFF20 {
            return getReg(reg: .nr41)
        } else if address == 0xFF21 {
            return getReg(reg: .nr42)
        } else if address == 0xFF22 {
            return getReg(reg: .nr43)
        } else if address == 0xFF23 {
            return getReg(reg: .nr44)
        } else if address == 0xFF26 {
            return getReg(reg: .nr52)
        } else if address >= 0xFF30 && address <= 0xFF3F {
            // wave table
            return getWaveReg(index: (address - 0xFF30))
        }
        return 0
    }
    
    func setMem(address: Int, val: Int) {
        // sound
        if address == 0xFF10 {
            setReg(reg: .nr10, val: val)
        } else if address == 0xFF11 {
            setReg(reg: .nr11, val: val)
        } else if address == 0xFF12 {
            setReg(reg: .nr12, val: val)
        } else if address == 0xFF13 {
            setReg(reg: .nr13, val: val)
        } else if address == 0xFF14 {
            setReg(reg: .nr14, val: val)
        } else if address == 0xFF16 {
            setReg(reg: .nr21, val: val)
        } else if address == 0xFF17 {
            setReg(reg: .nr22, val: val)
        } else if address == 0xFF18 {
            setReg(reg: .nr23, val: val)
        } else if address == 0xFF19 {
            setReg(reg: .nr24, val: val)
        } else if address == 0xFF1A {
            setReg(reg: .nr30, val: val)
        } else if address == 0xFF1B {
            setReg(reg: .nr31, val: val)
        } else if address == 0xFF1C {
            setReg(reg: .nr32, val: val)
        } else if address == 0xFF1D {
            setReg(reg: .nr33, val: val)
        } else if address == 0xFF1E {
            setReg(reg: .nr34, val: val)
        } else if address == 0xFF20 {
            setReg(reg: .nr41, val: val)
        } else if address == 0xFF21 {
            setReg(reg: .nr42, val: val)
        } else if address == 0xFF22 {
            setReg(reg: .nr43, val: val)
        } else if address == 0xFF23 {
            setReg(reg: .nr44, val: val)
        } else if address == 0xFF26 {
            setReg(reg: .nr52, val: val)
        } else if address >= 0xFF30 && address <= 0xFF3F {
            // wave table
            setWaveReg(index:  (address - 0xFF30), val: val)
        } else {
            print("sound mem set \(address) not implemented")
        }
    }
    
    func canAccess(address: Int) -> Bool {
        return (address >= 0xFF10 && address < 0xFF40)
    }
    
}
