//
//  MBC2.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/2.
//

import Foundation

class MBC2: MBCBase {
    
    override func setMem(address: Int, val: Int) {
        if address >= 0x0000 && address < 0x4000 {
            var v = val & 0b00001111
            if address & 0x100 == 0 {
                self.ramBankEnabled = v == 0b00001010
            } else {
                if v == 0 {
                    v = 1
                }
                self.romBankSelect = val
            }
        } else if address >= 0xA000 && address < 0xC000 {
            if self.ramBankEnabled {
                self.ramBanks[0][address % 512] = val | 0b11110000
            }
        }
    }
    
    override func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            return Int(self.romBanks[0][address])
        } else if address >= 0x4000 && address < 0x8000 {
            return Int(self.romBanks[self.romBankSelect % romBanks.count][address - 0x4000])
        } else if address >= 0xA000 && address < 0xC000 {
            if ramBankEnabled {
                return self.ramBanks[0][address % 512] | 0b11110000
            } else {
                return 0xFF
            }
        }
        return 0xFF
    }
        
    
}
