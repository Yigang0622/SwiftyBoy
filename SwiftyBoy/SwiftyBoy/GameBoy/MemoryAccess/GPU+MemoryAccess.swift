//
//  GPU+MemoryAccess.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/17.
//

import Foundation

extension GPU: MemoryAccessable {
    
    /**
     8kb video ram 0x8000 - 0xA000
     oam 0xFE00 - 0xFEA0
     LDCD 0xFF40
     STAT 0xFF41
     SCY 0xFF42
     SCX 0xFF43
     LY 0xFF44
     LYC 0xFF45
     BGP 0xFF47
     OBP0 0xFF48
     OBP1 0xFF49
     WY 0xFF4A
     WX 0xFF4B
     */
    func canAccess(address: Int) -> Bool {
        
        return (address >= 0x8000 && address < 0xA000) ||
        (address >= 0xFE00 && address < 0xFEA0) ||
        (address == 0xFF40) ||
        (address == 0xFF41) ||
        (address == 0xFF42) ||
        (address == 0xFF43) ||
        (address == 0xFF44) ||
        (address == 0xFF45) ||
        (address == 0xFF47) ||
        (address == 0xFF48) ||
        (address == 0xFF49) ||
        (address == 0xFF4A) ||
        (address == 0xFF4B)
                
    }
    
    func setMem(address: Int, val: Int) {
        if address >= 0x8000 && address < 0xA000 {
            // 8kb video ram
            vram[address - 0x8000] = (val & 0xFF)
        } else if address >= 0xFE00 && address < 0xFEA0 {
            // OAM
            oam[address - 0xFE00] = (val & 0xFF)
        }  else if address == 0xFF40 {
            // lcdc
            lcdcRegister.setVal(val: (val & 0xFF))
        } else if address == 0xFF41 {
            // STAT
            statRegister.setVal(val: (val & 0xFF))
        } else if address == 0xFF42 {
            // SCY
            scy = val
        } else if address == 0xFF43 {
            // SCX
            scx = val
        } else if address == 0xFF44 {
            // LY
            ly = val
        } else if address == 0xFF45 {
            // LYC
            lyc = val
        } else if address == 0xFF47 {
            // BGP
            backgroundPalette.setVal(val: (val & 0xFF))
        } else if address == 0xFF48 {
            // OBP0
            obj0Palatte.setVal(val: (val & 0xFF))
        } else if address == 0xFF49 {
            // OBP1
            obj1Palatte.setVal(val: (val & 0xFF))
        } else if address == 0xFF4A {
            // WY
            wy = val
        } else if address == 0xFF4B {
            // WX
            wx = val
        }
    }
    
    func getMem(address: Int) -> Int {
        if address >= 0x8000 && address < 0xA000 {
            // 8kb video ram
            return vram[address - 0x8000]
        } else if address >= 0xFE00 && address < 0xFEA0 {
            // OAM
            return oam[address - 0xFE00]
        }  else if address == 0xFF40 {
            // lcdc
            return lcdcRegister.getVal()
        } else if address == 0xFF41 {
            // STAT
            return statRegister.getVal()
        } else if address == 0xFF42 {
            // SCY
            return scy
        } else if address == 0xFF43 {
            // SCX
            return scx
        } else if address == 0xFF44 {
            // LY
            return ly
        } else if address == 0xFF45 {
            // LYC
            return lyc
        }  else if address == 0xFF47 {
            // BGP
            return backgroundPalette.getVal()
        } else if address == 0xFF48 {
            // OBP0
            return obj0Palatte.getVal()
        } else if address == 0xFF49 {
            // OBP1
            return obj1Palatte.getVal()
        } else if address == 0xFF4A {
            // WY
            return wy
        } else if address == 0xFF4B {
            // WX
            return wx
        }
        print("")
        return 0
    }
    
    
}
