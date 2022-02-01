//
//  MBC3.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/1/23.
//

import Foundation

class MBC3: MBCBase {
    
    override func setMem(address: Int, val: Int) {
        if address >= 0 && address < 0x2000 {
            if val & 0b00001111 == 0b1010 {
                self.ramBankEnabled = true
            } else if val == 0 {
                self.ramBankEnabled = false
            } else {
                self.ramBankEnabled = false
                print("Warning, unexpected address set for mbc3 \(address.asHexString): \(val.asHexString)")
            }
        } else if address >= 0x2000 && address < 0x4000 {
            var v = val & 0b01111111
            if v == 0 {
                v = 1
            }
            self.romBankSelect = v
        } else if address >= 0x4000 && address < 0x6000 {
            self.ramBankSelect = val
        } else if address >= 0x6000 && address <= 0x8000 {
            print("This MBC3 game requires RTC, however it's not been implemented ")
        } else if address >= 0xA000 && address < 0xC000 {
            if self.ramBankEnabled {
                if self.ramBankSelect <= 0x03 {
                    self.ramBanks[self.ramBankSelect][address - 0xA000] = val
                } else if self.ramBankSelect > 0x08 && self.ramBankSelect <= 0x0c {
                    print("This MBC3 game requires RTC, however it's not been implemented ")
                }
            }
        } else {
            fatalError("MBC3 setMem error \(address.asHexString)")
        }
    }
    
    
}
