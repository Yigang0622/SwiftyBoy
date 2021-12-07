//
//  Motherboard.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

class Motherboard {
    
    public let cpu = CPU()
    
    public var memory = Array<UInt8>(repeating: 0x00, count: 0xFFFF)
    
    var cart: Cartridge!
    var bootRom = BootRom()
    
    init() {
        cpu.mb = self
        let bytes = loadTestRom()
        cart = Cartridge(bytes: bytes)
    }
    
    public func getMem(address: Int) -> Int {
        
        if address >= 0x0000 && address < 0x4000 {
            if address <= 0xFF {
                return bootRom.getMem(address: address)
            } else {
                return cart.getMem(address: address)
            }
        } else if address >= 0x4000 && address < 0x8000 {
            return cart.getMem(address: address)
        } else {
            return Int(memory[Int(address)])
        }
        
    }
    
    public func setMem(address: Int, val: Int) {
        memory[address] = UInt8(val & 0xFF)
    }
    
    
    func loadTestRom() -> [UInt8] {

        if let fileURL = Bundle.main.url(forResource: "cpu_instrs", withExtension: "gb") {
            
            do {
                let raw = try Data(contentsOf: fileURL)
    
                return [UInt8](raw)
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    
}


