//
//  MBC1.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/19.
//

import Foundation



class MBC1: MBCBase {
        
    override func setMem(address: Int, val: Int) {
        if address >= 0x0000 && address < 0x2000 {
            self.ramBankEnabled = (val & 0b0000_1111) == 0b1010
        } else if address >= 0x2000 && address < 0x4000 {
            var v = val & 0b0001_1111
            // The register cannot contain zero (0b00000) and will be initialized as 0b00001
            // Attempting to write 0b00000 will write 0b00001 instead.
            v = (v == 0 ? 1 : v)
            self.bankSelectRegister1 = v
        } else if address >= 0x4000 && address < 0x6000 {
            self.bankSelectRegister2 = val & 0b11
        } else if address >= 0x6000 && address < 0x8000 {
            self.memoryModel = val & 0b1
        } else if address >= 0xA000 && address < 0xC000 {
            if ramBanks == nil {
                fatalError("ram bank not init")
            }
            if ramBankEnabled {
                self.ramBankSelect = self.memoryModel == 1 ? self.bankSelectRegister2 : 0
                self.ramBanks[self.ramBankSelect % externalRamCount][address - 0xA000] = val
            }
            
        } else {
            fatalError("MBC1 cart set memerry error \(address.asHexString)")
        }
    }
    
    override func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            if self.memoryModel == 1 {
                self.romBankSelect = (self.bankSelectRegister2 << 5) % self.externalRamCount
            } else {
                self.romBankSelect = 0
            }
            return Int(self.romBanks[self.romBankSelect][address])
        } else if address >= 0x4000 && address < 0x8000 {
            self.romBankSelect = (self.bankSelectRegister2 << 5) % self.externalRamCount | self.bankSelectRegister1
            return Int(self.romBanks[self.romBankSelect % self.romBanks.count][address - 0x4000])
        } else if address >= 0xA000 && address < 0xC000 {
            if !ramBankEnabled {
                print("ramBank disabled, cant read")
                return 0xFF
            }
            if self.memoryModel == 1 {
                self.ramBankSelect = self.bankSelectRegister2
            } else {
                self.ramBankSelect = 0
            }
            return self.ramBanks[self.ramBankSelect % self.externalRamCount][address - 0xA000]
        }
        fatalError("MBC1 cart get memerry error \(address.asHexString)")
    }
    
    
}
