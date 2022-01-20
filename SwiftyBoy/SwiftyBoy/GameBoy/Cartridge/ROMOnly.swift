//
//  ROMOnly.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/19.
//

import Foundation

class ROMOnly: MBCBase {

    private var rom: [UInt8]!

    override init(bytes: [UInt8], name: String, meta: CartridgeMeta) {
        super.init(bytes: bytes, name: name, meta: meta)
        self.rom = bytes
//        print(bytes.count)
    }
//    
    override func getMem(address: Int) -> Int {
        return Int(rom[address])
    }
    
    override func setMem(address: Int, val: Int) {
        print("set \(address.asHexString)")
//        if address >= 0x2000 && address < 0x4000 {
//            let v = val == 0 ? 1 : val
//            self.romBankSelect = v & 0b1
//            print("rom bank switched to \(self.romBankSelect)")
//        } else if address >= 0xA000 && address < 0xC000 {
//            self.ramBanks[self.ramBankSelect][address - 0xA000] = val
//        } else {
////            fatalError("ROMOnly setMem error \(address.asHexString)")
//            print("ROMOnly setMem error \(address.asHexString)")
//        }
    }
    
}
