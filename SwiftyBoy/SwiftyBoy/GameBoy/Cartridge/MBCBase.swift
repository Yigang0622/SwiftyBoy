//
//  MBCBase.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/19.
//

import Foundation

class MBCBase: Cartridge {
    
    static var externalRamCountLookup: [UInt8: Int] = [
        0x00: 1,
        0x01: 1,
        0x02: 1,
        0x03: 4,
        0x04: 16,
        0x05: 8
    ]
    
    var romBanks = [[UInt8]]()
    var ramBanks: Array<Array<Int>>!;
    
    var bankSelectRegister1 = 1
    var bankSelectRegister2 = 0
    var memoryModel = 0
    
    var ramBankSelect = 0
    var romBankSelect = 1
    var ramBankEnabled = false
    
    var externalRamCount = 0
    var externalRomcount = 0
    
    override init(bytes: [UInt8], name: String, meta: CartridgeMeta) {
        super.init(bytes: bytes, name: name, meta: meta)
        // 16kb
        let bankSize = 16 * 1024
        romBanks = bytes.chunked(into: bankSize)
        print("[rom banks] \(romBanks.count) ")
        self.externalRomcount = romBanks.count
        self.externalRamCount = MBCBase.externalRamCountLookup[romBanks[0][0x0149]]!
        initRamBanks()
        
    }
    
    override func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            return Int(romBanks[0][address])
        } else if address >= 0x4000 && address < 0x8000 {
            return Int(romBanks[romBankSelect % romBanks.count][address-0x4000])
        } else if address >= 0xA000 && address < 0xC000 {
            if !ramBankEnabled {
                return 0xFF
            }
            // RTC
            return self.ramBanks[self.ramBankSelect % self.externalRamCount][address - 0xA0000]
        } else {
            fatalError("MBCBase get mem \(address.asHexString)")
        }
    }
    
    override func setMem(address: Int, val: Int) {
        fatalError("Can't set rom in MBC Base")
    }

    func initRamBanks() {
        print("init ram bank, count \(externalRamCount)")
        self.ramBanks =  Array(repeating: Array(repeating: 0, count: 8*1024), count: externalRamCount)
    }
    
    
}
