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
    let sound = SoundController()
    
    var cart: Cartridge!
    var bootRom: BootRom?
    var bootRomEnable = true
    
    private var running = false
    var timer: DispatchSourceTimer!
    var queue: DispatchQueue = DispatchQueue(label: "mbtimer")
    let semaphore = DispatchSemaphore(value: 1)
    private var fpsRestriction = true
    
    
    init() {
        cpu.mb = self
        gpu.mb = self
        joypad.mb = self
                
        cpuTimer.onTimerOverflow = { [self] in
            cpu.interruptFlagRegister.timerOverflow = true
        }
        
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
        sound.reset()
        cpu.reset()
        gpu.reset()
    }
    
    func run() {
        if cart == nil {
            print("cart is nil")
            return
        }
        if bootRom == nil {
            bootRomEnable = false
            cpu.pc = 0x100
            cpu.af = 0x01B0
            cpu.bc = 0x0013
            cpu.de = 0x00D8
            cpu.hl = 0x014D
            cpu.sp = 0xFFFE
            setMem(address: 0xFF05, val: 0x00)
            setMem(address: 0xFF06, val: 0x00)
            setMem(address: 0xFF07, val: 0x00)
            setMem(address: 0xFF10, val: 0x80)
            setMem(address: 0xFF11, val: 0xBF)
            setMem(address: 0xFF12, val: 0xF3)
            setMem(address: 0xFF14, val: 0xBF)
            setMem(address: 0xFF16, val: 0x3F)
            setMem(address: 0xFF17, val: 0x00)
            setMem(address: 0xFF19, val: 0xBF)
            setMem(address: 0xFF1A, val: 0x7F)
            setMem(address: 0xFF1B, val: 0xFF)
            setMem(address: 0xFF1C, val: 0x9F)
            setMem(address: 0xFF1E, val: 0xBF)
            setMem(address: 0xFF20, val: 0xFF)
            setMem(address: 0xFF21, val: 0x00)
            setMem(address: 0xFF22, val: 0x00)
            setMem(address: 0xFF23, val: 0xBF)
            setMem(address: 0xFF24, val: 0x77)
            setMem(address: 0xFF25, val: 0xF3)
            setMem(address: 0xFF26, val: 0xF1)
            setMem(address: 0xFF40, val: 0x91)
            setMem(address: 0xFF42, val: 0x00)
            setMem(address: 0xFF43, val: 0x00)
            setMem(address: 0xFF45, val: 0x00)
            setMem(address: 0xFF47, val: 0xFC)
            setMem(address: 0xFF48, val: 0xFF)
            setMem(address: 0xFF49, val: 0xFF)
            setMem(address: 0xFF4A, val: 0x00)
            setMem(address: 0xFF4B, val: 0x00)
            setMem(address: 0xFFFF, val: 0x00)            
        }
        setupTimer()
        sound.start()
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
            sound.tick(cycles: cycles)
        }
        print("Motherboard Stopped")
    }
    
    public func getMem(address: Int) -> Int {
        if address >= 0x0000 && address < 0x4000 {
            // 16k ROM bank 0
            if address <= 0xFF && bootRomEnable {
                return bootRom!.getMem(address: address)
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
                // sound
                if address == 0xFF10 {
                    return sound.getReg(reg: .nr10)
                } else if address == 0xFF11 {
                    return sound.getReg(reg: .nr11)
                } else if address == 0xFF12 {
                    return sound.getReg(reg: .nr12)
                } else if address == 0xFF13 {
                    return sound.getReg(reg: .nr13)
                } else if address == 0xFF14 {
                    return sound.getReg(reg: .nr14)
                } else if address == 0xFF16 {
                    return sound.getReg(reg: .nr21)
                } else if address == 0xFF17 {
                    return sound.getReg(reg: .nr22)
                } else if address == 0xFF18 {
                    return sound.getReg(reg: .nr23)
                } else if address == 0xFF19 {
                    return sound.getReg(reg: .nr24)
                }else if address == 0xFF1A {
                    return sound.getReg(reg: .nr30)
                } else if address == 0xFF1B {
                    return sound.getReg(reg: .nr31)
                } else if address == 0xFF1C {
                    return sound.getReg(reg: .nr32)
                } else if address == 0xFF1D {
                    return sound.getReg(reg: .nr33)
                } else if address == 0xFF1E {
                    return sound.getReg(reg: .nr34)
                } else if address == 0xFF20 {
                    return sound.getReg(reg: .nr41)
                } else if address == 0xFF21 {
                    return sound.getReg(reg: .nr42)
                } else if address == 0xFF22 {
                    return sound.getReg(reg: .nr43)
                } else if address == 0xFF23 {
                    return sound.getReg(reg: .nr44)
                } else if address == 0xFF26 {
                    return sound.getReg(reg: .nr52)
                } else if address >= 0xFF30 && address <= 0xFF3F {
                    // wave table
                    return sound.getWaveReg(index: (address - 0xFF30))
                }
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
                if address == 0xFF10 {
                    sound.setReg(reg: .nr10, val: val)
                } else if address == 0xFF11 {
                    sound.setReg(reg: .nr11, val: val)
                } else if address == 0xFF12 {
                    sound.setReg(reg: .nr12, val: val)
                } else if address == 0xFF13 {
                    sound.setReg(reg: .nr13, val: val)
                } else if address == 0xFF14 {
                    sound.setReg(reg: .nr14, val: val)
                } else if address == 0xFF16 {
                    sound.setReg(reg: .nr21, val: val)
                } else if address == 0xFF17 {
                    sound.setReg(reg: .nr22, val: val)
                } else if address == 0xFF18 {
                    sound.setReg(reg: .nr23, val: val)
                } else if address == 0xFF19 {
                    sound.setReg(reg: .nr24, val: val)
                } else if address == 0xFF1A {
                    sound.setReg(reg: .nr30, val: val)
                } else if address == 0xFF1B {
                    sound.setReg(reg: .nr31, val: val)
                } else if address == 0xFF1C {
                    sound.setReg(reg: .nr32, val: val)
                } else if address == 0xFF1D {
                    sound.setReg(reg: .nr33, val: val)
                } else if address == 0xFF1E {
                    sound.setReg(reg: .nr34, val: val)
                } else if address == 0xFF20 {
                    sound.setReg(reg: .nr41, val: val)
                } else if address == 0xFF21 {
                    sound.setReg(reg: .nr42, val: val)
                } else if address == 0xFF22 {
                    sound.setReg(reg: .nr43, val: val)
                } else if address == 0xFF23 {
                    sound.setReg(reg: .nr44, val: val)
                } else if address == 0xFF26 {
                    sound.setReg(reg: .nr52, val: val)
                } else if address >= 0xFF30 && address <= 0xFF3F {
                    // wave table
                    sound.setWaveReg(index:  (address - 0xFF30), val: val)
                }
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


