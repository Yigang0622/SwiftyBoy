//
//  GPU.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/7.
//

import Foundation

enum GPUPhase {
    case oamSearch
    case pixelTransfer
    case hBlank
    case vBlank
}

class GPU {
        
    var mb: Motherboard!
    
    var vram = ContiguousArray<Int>(repeating: 0x00, count: 8 * 1024)
    var oam = ContiguousArray<Int>(repeating: 0x00, count: 0xA0)
    
    public var onFrameDrawn: ((FrameData) -> Void)?
    public var onPhaseChange: ((GPUPhase) -> Void)?
        
    private static let FULL_FRAME_CYCLE = 70224
//    private var LY = 0
    private var clock:Int = 0
    private var targetClock:Int = 0
    
    private var currentPhase: GPUPhase = .oamSearch
    private var nextPhase: GPUPhase = .oamSearch
    
    var statRegister = STATRegister(val: 0)
    var lcdcRegister = LCDCRegister(val: 0)
    var scy = 0x00
    var scx = 0x00
    var ly = 0x00
    var lyc = 0x00
    var backgroundPalette = PaletteRegister(val: 0xFC)
    var obj0Palatte = PaletteRegister(val: 0xFF)
    var obj1Palatte = PaletteRegister(val: 0xFF)
    var wy = 0x00
    var wx = 0x00
    var lyMax = 153
    
    var renderer:Renderer!
    
    func reset() {
        clock = 0
        targetClock = 0
        currentPhase = .oamSearch
        nextPhase = .oamSearch
        statRegister = STATRegister(val: 0)
        lcdcRegister = LCDCRegister(val: 0)
        scy = 0x00
        scx = 0x00
        ly = 0x00
        lyc = 0x00
        backgroundPalette = PaletteRegister(val: 0xFC)
        obj0Palatte = PaletteRegister(val: 0xFF)
        obj1Palatte = PaletteRegister(val: 0xFF)
        wy = 0x00
        wx = 0x00
    }
    
    init() {
        renderer = Renderer(gpu: self)
    }
    
    func tick(numOfCycles: Int) {
                
        clock += numOfCycles
                
        if targetClock > GPU.FULL_FRAME_CYCLE {
            clock %=  GPU.FULL_FRAME_CYCLE
            targetClock %= GPU.FULL_FRAME_CYCLE
        }
        
        // should change state
        if clock > targetClock {
            
            if ly == lyMax {
                nextPhase = .oamSearch
                resetLY()
            }
            
            currentPhase = nextPhase
            if currentPhase == .oamSearch {
                // 20 clocks
                targetClock += 20 * 4
                nextPhase = .pixelTransfer
                statRegister.modeFlag = .mode10
                if statRegister.mode10InterruptEnable {
                    mb.cpu.interruptFlagRegister.lcdc = true
                }
                increaseLY()
            } else if currentPhase == .pixelTransfer {
                targetClock += 43 * 4
                statRegister.modeFlag = .mode11
                nextPhase = .hBlank                
            } else if currentPhase == .hBlank {
                targetClock += 51 * 4
                statRegister.modeFlag = .mode00
                if statRegister.mode00InterruptEnable {
                    mb.cpu.interruptFlagRegister.lcdc = true
                }
                if ly >= 0 && ly < 144 {
                    renderer.drawLine(line: ly)
                }
                // full frame drawn
                if ly < 144 {
                    nextPhase = .oamSearch
                } else {
                    nextPhase = .vBlank
                }
            } else if currentPhase == .vBlank {
                targetClock += (20 + 43 + 51) * 4
                statRegister.modeFlag = .mode01
                if statRegister.mode01InterruptEnable {
                    mb.cpu.interruptFlagRegister.lcdc = true
                }
                nextPhase = .vBlank
                if ly == 144 {
                    mb.cpu.interruptFlagRegister.vblank = true
                    onPhaseChange?(.vBlank)
                    onFrameDrawn?(renderer.frameData)
                }
                increaseLY()
            }
        }
    }
    
    func resetLY() {
        ly = -1
    }
    
    func increaseLY() {
        ly += 1
        statRegister.lyMatchFlag = (ly == lyc)
        if statRegister.lyMatchFlag && statRegister.lyMatchInterruptEnable {
            mb.cpu.interruptFlagRegister.lcdc = true
        }
    }
    
}
