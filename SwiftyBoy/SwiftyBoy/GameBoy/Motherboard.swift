//
//  Motherboard.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

class Motherboard {
    
    public let cpu = CPU()
    let gpu = GPU()
    let ram = RAM()
    public var memory = Array<UInt8>(repeating: 0x00, count: 0xFFFF)
    
    var cart: Cartridge!
    var bootRom = BootRom()
    
    
    init() {
        cpu.mb = self
        let bytes = loadTestRom(name: "ld_r_r")
        cart = Cartridge(bytes: bytes)
    }
    
    func run() {
        var cycleTotal = 0
        while cycleTotal < 2000000 {
            let cycles = cpu.fetchAndExecute()
            gpu.tick(numOfCycles: cycles)
            cycleTotal += cycles
        }
    }
    
    public func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            // 16k ROM bank 0
            if address <= 0xFF {
                return bootRom.getMem(address: address)
            } else {
                return cart.getMem(address: address)
            }
        } else if address >= 0x4000 && address < 0x8000 {
            // 16k switchable ROM bank
            return cart.getMem(address: address)
        } else if address >= 0x8000 && address < 0xA000 {
            // 8kb video ram
            return Int(gpu.vram[address - 0x8000])
        } else if address >= 0xA000 && address < 0xC000 {
            // 8kb switchable RAM bank
            
        } else if address >= 0xC000 && address < 0xE000 {
            // 8kb internal ram 0
            return Int(ram.internalRam0[address - 0xC000])
        } else if address >= 0xE000 && address < 0xFE00 {
            // Echo of 8kB Internal RAM
            return self.getMem(address: address - 0x2000)
        } else if address >= 0xFE00 && address < 0xFEA0 {
            // OAM
            return Int(gpu.oam[address - 0xFE00])
        } else if address >= 0xFEA0 && address < 0xFF00 {
            // Empty but unusable for I/O
            return Int(ram.nonIoInternalRam0[address - 0xFEA0])
        } else if address >= 0xFF00 && address < 0xFF4C {
            // Empty but unusable for I/O
            if address == 0xFF04 {
                // timer DIV
            } else if address == 0xFF05 {
                // timer TIMA
            } else if address == 0xFF06 {
                // timer TMA
            } else if address == 0xFF07 {
                // timer TAC
            } else if address == 0xFF0F {
                // CPI interruptes flag
            } else if address >= 0xFF10 && address < 0xFF40 {
                // sound
            } else if address == 0xFF40 {
                // lcdc
                return gpu.lcdcRegister.getVal()
            } else if address == 0xFF41 {
                // STAT
                return gpu.statRegister.getVal()
            } else if address == 0xFF42 {
                // SCY
                return gpu.scy
            } else if address == 0xFF43 {
                // SCX
                return gpu.scx
            } else if address == 0xFF44 {
                // LY
                return gpu.ly
            } else if address == 0xFF45 {
                // LYC
                return gpu.lyc
            } else if address == 0xFF46 {
                // DMA
                return 0
            } else if address == 0xFF47 {
                // BGP
                return gpu.backgroundPalette.getVal()
            } else if address == 0xFF48 {
                // OBP0
                return gpu.obj0Palatte.getVal()
            } else if address == 0xFF49 {
                // OBP1
                return gpu.obj1Palatte.getVal()
            } else if address == 0xFF4A {
                // WY
                return gpu.wy
            } else if address == 0xFF4B {
                // WX
                return gpu.wx
            } else {
                // io ports
                return Int(ram.ioPortsRAM[address - 0xFF00])
            }
        } else if address >= 0xFF4C && address < 0xFF80 {
            // non io internal ram
            return Int(ram.nonIoInternalRam1[address - 0xFF4C])
        } else if address >= 0xFF80 && address < 0xFFFF {
            // internal ram 1
            return Int(ram.internalRam1[address - 0xFF80])
        } else if address == 0xFFFF {
            // IE
        } else {
            
            return Int(memory[Int(address)])
        }
        return 0
    }
    
    public func setMem(address: Int, val: Int) {
        let v = UInt8(val & 0xFF)
        if address >= 0x0000 && address < 0x4000 {
            // 16k ROM bank 0
            
        } else if address >= 0x4000 && address < 0x8000 {
            // 16k switchable ROM bank
            
        } else if address >= 0x8000 && address < 0xA000 {
            // 8kb video ram
            gpu.vram[address - 0x8000] = v
        } else if address >= 0xA000 && address < 0xC000 {
            // 8kb switchable RAM bank
            
        } else if address >= 0xC000 && address < 0xE000 {
            // 8kb internal ram 0
            ram.internalRam0[address - 0xC00] = v
        } else if address >= 0xE000 && address < 0xFE00 {
            // Echo of 8kB Internal RAM
            self.setMem(address: address - 0x2000, val: val)
        } else if address >= 0xFE00 && address < 0xFEA0 {
            // OAM
            gpu.oam[address - 0xFE00] = v
        } else if address >= 0xFEA0 && address < 0xFF00 {
            // Empty but unusable for I/O
            ram.nonIoInternalRam0[address - 0xFEA0] = v
        } else if address >= 0xFF00 && address < 0xFF4C {
            // Empty but unusable for I/O
            if address == 0xFF00 {
                // TODO io
                self.ram.ioPortsRAM[address - 0xFF00] = v
            } else if address == 0xFF01 {
                // todo
            } else if address == 0xFF04 {
                // timer DIV
            } else if address == 0xFF05 {
                // timer TIMA
            } else if address == 0xFF06 {
                // timer TMA
            } else if address == 0xFF07 {
                // timer TAC
            } else if address == 0xFF0F {
                // CPI interruptes flag
            } else if address >= 0xFF10 && address < 0xFF40 {
                // sound
            } else if address == 0xFF40 {
                // lcdc
                gpu.lcdcRegister.setVal(val: Int(v))
            } else if address == 0xFF41 {
                // STAT
                gpu.statRegister.setVal(val: Int(v))
            } else if address == 0xFF42 {
                // SCY
                gpu.scy = val
            } else if address == 0xFF43 {
                // SCX
                gpu.scx = val
            } else if address == 0xFF44 {
                // LY
                gpu.ly = val
            } else if address == 0xFF45 {
                // LYC
                gpu.lyc = val
            } else if address == 0xFF46 {
                // DMA
                
            } else if address == 0xFF47 {
                // BGP
                gpu.backgroundPalette.setVal(val: Int(v))
            } else if address == 0xFF48 {
                // OBP0
                gpu.obj0Palatte.setVal(val: Int(v))
            } else if address == 0xFF49 {
                // OBP1
                gpu.obj1Palatte.setVal(val: Int(v))
            } else if address == 0xFF4A {
                // WY
                gpu.wy = val
            } else if address == 0xFF4B {
                // WX
                gpu.wx = val
            } else {
                // io ports
                ram.ioPortsRAM[address - 0xFF00] = v
            }
        } else if address >= 0xFF4C && address < 0xFF80 {
            // non io internal ram
            ram.nonIoInternalRam1[address - 0xFF4C] = v
        } else if address >= 0xFF80 && address < 0xFFFF {
            // internal ram 1
            ram.internalRam1[address - 0xFF80] = v
        } else if address == 0xFFFF {
            // IE
            
        } else {
            
        }
        memory[address] = UInt8(val & 0xFF)
    }
    
    
    func loadTestRom(name: String) -> [UInt8] {

        if let fileURL = Bundle.main.url(forResource: name, withExtension: "gb") {
            
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


