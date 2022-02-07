//
//  Motherboard.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import Foundation

class Motherboard {
    
    var cpu = CPU()
    let cpuTimer = CPUTimer()
    let gpu = GPU()
    let ram = RAM()
    let joypad = Joypad(interruptManager: InterruptManager())
    
    var cart: Cartridge!
    var bootRom = BootRom()
    var bootRomEnable = true
    
    private var running = false
    var timer: DispatchSourceTimer!
    var queue: DispatchQueue = DispatchQueue(label: "mbtimer")
    let semaphore = DispatchSemaphore(value: 1)
    private var fpsRestriction = true
    
    
    init() {
        cpu.mb = self
        gpu.mb = self
        cpuTimer.mb = self
        joypad.mb = self
                
        gpu.onPhaseChange = { [self] phase in
            if phase == .vBlank && fpsRestriction && running {
                self.semaphore.wait()
            }
        }
    }
    
    func reset() {
        running = false
        if timer != nil {
            timer.cancel()
        }
        if cart != nil {
            (cart as? MBCBase)?.cartriageWillEject()
        }
        semaphore.signal()
        running = false
        bootRomEnable = true
        cpu.reset()
        gpu.reset()
    }
    
    func run() {
        if cart == nil {
            print("cart is nil")
            return
        }
        setupTimer()
        running = true
        startTick()
    }
    
    private func setupTimer() {
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer.setEventHandler {
            self.semaphore.signal()
        }
        // 1 / 60s = 17ms
        timer.schedule(deadline: .now(), repeating: .milliseconds(17), leeway: .nanoseconds(1))
        timer.resume()
    }
    
    func setFpsRestriction(enable: Bool) {
        if !running {
            return
        }
        
        if enable {
            if !fpsRestriction {
                setupTimer()
                fpsRestriction = true
            }
        } else {
            if fpsRestriction {
                fpsRestriction = false
                // prevent thread wait
                self.semaphore.signal()
                timer.cancel()
            }
        }
    }
    
    private func startTick() {
        while running {
            let cycles = cpu.fetchAndExecute()
            gpu.tick(numOfCycles: cycles)
            cpuTimer.tick(cycles: cycles)
        }
        print("Motherboard Stopped")
    }
    
    public func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            // 16k ROM bank 0
            if address <= 0xFF && bootRomEnable {
                return bootRom.getMem(address: address)
            } else {
                return cart.getMem(address: address)
            }
        } else if address >= 0x4000 && address < 0x8000 {
            // 16k switchable ROM bank
            return cart.getMem(address: address)
        } else if address >= 0x8000 && address < 0xA000 {
            // 8kb video ram
            return gpu.vram[address - 0x8000]
        } else if address >= 0xA000 && address < 0xC000 {
            // 8kb switchable RAM bank
            return cart.getMem(address: address)
        } else if address >= 0xC000 && address < 0xE000 {
            // 8kb internal ram 0
            return ram.internalRam0[address - 0xC000]
        } else if address >= 0xE000 && address < 0xFE00 {
            // Echo of 8kB Internal RAM
            return self.getMem(address: address - 0x2000)
        } else if address >= 0xFE00 && address < 0xFEA0 {
            // OAM
            return gpu.oam[address - 0xFE00]
        } else if address >= 0xFEA0 && address < 0xFF00 {
            // Empty but unusable for I/O
            return ram.nonIoInternalRam0[address - 0xFEA0]
        } else if address >= 0xFF00 && address < 0xFF4C {
            // I/O ports
            if address == 0xFF00 {
                return joypad.getMem(address: address)
            }else if address == 0xFF04 {
                // timer DIV
                return cpuTimer.div
            } else if address == 0xFF05 {
                // timer TIMA
                return cpuTimer.tima
            } else if address == 0xFF06 {
                // timer TMA
                return cpuTimer.tma
            } else if address == 0xFF07 {
                // timer TAC
                return cpuTimer.tac
            } else if address == 0xFF0F {
                // CPU interruptes flag
                return cpu.interruptFlagRegister.getVal()
            } else if address >= 0xFF10 && address < 0xFF40 {
                // sound
                return 0
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
                return self.ram.ioPortsRAM[address - 0xFF00]
            }
        } else if address >= 0xFF4C && address < 0xFF80 {
            // non io internal ram
            return ram.nonIoInternalRam1[address - 0xFF4C]
        } else if address >= 0xFF80 && address < 0xFFFF {
            // internal ram 1
            return ram.internalRam1[address - 0xFF80]
        } else if address == 0xFFFF {
            // IE
            return cpu.interruptEnableRegister.getVal()
        }
        fatalError("[Motherboard] get mem address \(address) error")
    }
    
    
    var serialOutput: String = ""
//
    public func setMem(address: Int, val: Int) {
        
        if address >= 0x0000 && address < 0x4000 {
            // 16k ROM bank 0
            cart.setMem(address: address, val: (val & 0xFF))
        } else if address >= 0x4000 && address < 0x8000 {
            // 16k switchable ROM bank
            cart.setMem(address: address, val: (val & 0xFF))
        } else if address >= 0x8000 && address < 0xA000 {
            // 8kb video ram
            gpu.vram[address - 0x8000] = (val & 0xFF)
        } else if address >= 0xA000 && address < 0xC000 {
            // 8kb switchable RAM bank
            cart.setMem(address: address, val: (val & 0xFF))
        } else if address >= 0xC000 && address < 0xE000 {
            // 8kb internal ram 0
            ram.internalRam0[address - 0xC000] = (val & 0xFF)
        } else if address >= 0xE000 && address < 0xFE00 {
            // Echo of 8kB Internal RAM
            self.setMem(address: address - 0x2000, val: val)
        } else if address >= 0xFE00 && address < 0xFEA0 {
            // OAM
            gpu.oam[address - 0xFE00] = (val & 0xFF)
        } else if address >= 0xFEA0 && address < 0xFF00 {
            // Empty but unusable for I/O
            ram.nonIoInternalRam0[address - 0xFEA0] = (val & 0xFF)
        } else if address >= 0xFF00 && address < 0xFF4C {
            // Empty but unusable for I/O
            if address == 0xFF00 {
                // joypad
                joypad.setMem(address: address, val: (val & 0xFF))
            } else if address == 0xFF01 {
                // todo serial
                self.ram.ioPortsRAM[address - 0xFF00] = (val & 0xFF)
            } else if address == 0xFF02 {
                // serial
                if val == 0x81 {
                    let chr = getMem(address: 0xff01)
                    serialOutput += String(Character(UnicodeScalar(chr)!))
                    print(serialOutput)
//                    cpu.logs.append(serialOutput)
                }
                self.ram.ioPortsRAM[address - 0xFF00] = (val & 0xFF)
            } else if address == 0xFF04 {
                // timer DIV
                self.cpuTimer.reset()
            } else if address == 0xFF05 {
                // timer TIMA
                self.cpuTimer.tima = (val & 0xFF)
            } else if address == 0xFF06 {
                // timer TMA
                self.cpuTimer.tma = (val & 0xFF)
            } else if address == 0xFF07 {
                // timer TAC
                self.cpuTimer.tac = (val & 0xFF)
            } else if address == 0xFF0F {
                // CPU interruptes flag
                cpu.interruptFlagRegister.setVal(val: (val & 0xFF))
            } else if address >= 0xFF10 && address < 0xFF40 {
                // sound
            } else if address == 0xFF40 {
                // lcdc
                gpu.lcdcRegister.setVal(val: (val & 0xFF))
            } else if address == 0xFF41 {
                // STAT
                gpu.statRegister.setVal(val: (val & 0xFF))
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
                dma(src: (val & 0xFF))
            } else if address == 0xFF47 {
                // BGP
                gpu.backgroundPalette.setVal(val: (val & 0xFF))
            } else if address == 0xFF48 {
                // OBP0
                gpu.obj0Palatte.setVal(val: (val & 0xFF))
            } else if address == 0xFF49 {
                // OBP1
                gpu.obj1Palatte.setVal(val: (val & 0xFF))
            } else if address == 0xFF4A {
                // WY
                gpu.wy = val
            } else if address == 0xFF4B {
                // WX
                gpu.wx = val
            } else {
                // io ports
                ram.ioPortsRAM[address - 0xFF00] = (val & 0xFF)
            }
        } else if address >= 0xFF4C && address < 0xFF80 {
            if (address == 0xFF50 && val == 1 && self.bootRomEnable) {
                self.bootRomEnable = false
//                cpu.logs.removeAll()
                print("boot end")
            }
            // non io internal ram
            ram.nonIoInternalRam1[address - 0xFF4C] = (val & 0xFF)
        } else if address >= 0xFF80 && address < 0xFFFF {
            // internal ram 1
            ram.internalRam1[address - 0xFF80] = (val & 0xFF)
        } else if address == 0xFFFF {
            // IE
            cpu.interruptEnableRegister.setVal(val: (val & 0xFF))
        } else {
            fatalError("[Motherboard] set mem address \(address.asHexString) error")
        }
    }
    
    
    private func dma(src: Int) {
        let dst = 0xFE00
        let offset = src * 0x100
        for i in 0...0xA0 {
            self.setMem(address: dst + i, val: self.getMem(address: i + offset))
        }
    }
    
}


