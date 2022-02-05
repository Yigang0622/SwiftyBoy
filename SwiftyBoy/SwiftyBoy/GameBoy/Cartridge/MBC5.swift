//
//  MBC5.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/5.
//

import Foundation

class MBC5: MBCBase {
    
    override func setMem(address: Int, val: Int) {
        if address >= 0x0000 && address < 0x2000 {
            self.ramBankEnabled = val == 0b00001010
        } else if address >= 0x2000 && address < 0x3000 {
            self.romBankSelect = (self.romBankSelect & 0b100000000) | val
        } else if address >= 0x3000 && address < 0x4000 {
            self.romBankSelect = ((val & 0x1) << 8) | (self.romBankSelect & 0xFF)
        } else if address >= 0x4000 && address < 0x6000 {
            self.ramBankSelect = val & 0xF
        } else if address >= 0xA000 && address < 0xC000 {
            if self.ramBankEnabled {
                self.ramBanks[self.ramBankSelect % self.externalRamCount][address - 0xA000] = val
            }
        }
    }
    
     
}
