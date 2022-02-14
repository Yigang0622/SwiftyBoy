//
//  MBCBase.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/19.
//

import Foundation
import UIKit

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
    
    var rtcEnabled = false
    
    override init(bytes: [UInt8], name: String, meta: CartridgeMeta, fileName: String) {
        super.init(bytes: bytes, name: name, meta: meta, fileName: fileName)
        // 16kb
        let bankSize = 16 * 1024
        
        self.externalRomcount = romBanks.count
        romBanks = bytes.chunked(into: bankSize)
        print("[rom banks] \(romBanks.count) ")
                
        self.externalRamCount = MBCBase.externalRamCountLookup[romBanks[0][0x0149]] ?? 0
        initRamBanks()
                
        if meta.battery {
            loadSaveFileToRam()
            NotificationCenter.default.addObserver(self, selector: #selector(self.cartriageWillEject), name: UIApplication.willTerminateNotification, object: nil)
        }
        
    }
    
    private func loadSaveFileToRam() {
        do {
            let data = try Data(contentsOf: saveFilePath)
            let dataArray = [UInt8](data)
            let chunkedData = dataArray.chunked(into: 8 * 1024)
            if chunkedData.count == ramBanks.count {
                
                for (i, each) in chunkedData.enumerated() {
                    ramBanks[i] = each.compactMap{ Int($0) }
                }
                print("save file loaded")
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveRamToFile() {
        let bytes:[UInt8] = ramBanks.flatMap { $0 }.map { UInt8($0) }
        let data = Data(bytes: bytes, count: bytes.count)
        do {
            try data.write(to: saveFilePath)
            print(saveFilePath.absoluteURL)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    var saveFilePath: URL {
        get {
            return FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent(saveFileName)
        }
    }
    
    var saveFileName: String {
        get {
            return "\(fileName).sav"
        }
    }
    
    @objc func cartriageWillEject() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
        print("cartriageWillEject!")
        saveRamToFile()
    }
    
    func initRamBanks() {
        print("[ram banks] \(externalRamCount)")
        self.ramBanks =  Array(repeating: Array(repeating: 0, count: 8*1024), count: externalRamCount)
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
            if self.ramBankSelect >= 0x08 && self.ramBankSelect <= 0x0C {
                return 0xFF
            } else {
                return self.ramBanks[self.ramBankSelect % self.externalRamCount][address - 0xA000]
            }
            
        } else {
            fatalError("MBCBase get mem \(address.asHexString)")
        }
    }
    
    override func setMem(address: Int, val: Int) {
        fatalError("Can't set rom in MBC Base")
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


