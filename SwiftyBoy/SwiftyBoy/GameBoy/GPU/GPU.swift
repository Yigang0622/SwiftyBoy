//
//  GPU.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/12/7.
//

import Foundation

enum GPUState {
    case oamSearch
    case pixelTransfer
    case hBlank
    case vBlank
}

class GPU {
    
    weak var mb: Motherboard!
    
    private static let FULL_FRAME_CYCLE = 70224
//    private var LY = 0
    private var clock:Int = 0
    private var targetClock:Int = 0
    
    private var currentState: GPUState = .oamSearch
    private var nextState: GPUState = .oamSearch
    private var frameCount = 0
    
    var statRegister = STATRegister(val: 0)
    var lcdcRegister = LCDCRegister(val: 0)
    var scy = 0x00
    var scx = 0x00
    var ly = 0x00
    var lyc = 0x00
    var backgroundPalette = PaletteRegister(val: 0xFC)
    var obj1Palatte = PaletteRegister(val: 0xFF)
    var obj2Palatte = PaletteRegister(val: 0xFF)
    var wy = 0x00
    var wx = 0x00
    
    func tick(numOfCycles: Int) {
        clock += numOfCycles
        
        if targetClock > GPU.FULL_FRAME_CYCLE {
            clock %=  GPU.FULL_FRAME_CYCLE
            targetClock %= GPU.FULL_FRAME_CYCLE
        }
        
        // should change state
        if clock > targetClock {
            print("[GPU] clock \(clock) target \(targetClock)")
            
            currentState = nextState
            if currentState == .oamSearch {
                // 20 clocks
                targetClock += 20 * 4
                nextState = .pixelTransfer
                print("[GPU] OAM SEARCH until \(targetClock)")
            } else if currentState == .pixelTransfer {
                targetClock += 43 * 4
                nextState = .hBlank
                print("[GPU] PIXEL TRANSFER until \(targetClock)")
            } else if currentState == .hBlank {
                targetClock += 51 * 4
                // draw line
                ly += 1
                print("[GPU] HBLANK line \(ly) until \(targetClock)")
                
                // full frame drawn
                if ly > 143 {
                    frameCount += 1
                    print("[GPU] drawn new frame \(frameCount) at clock \(clock)")
                    ly = 0
                    nextState = .vBlank
                } else {
                    nextState = .oamSearch
                }
                
            } else if currentState == .vBlank {
                targetClock += 10 * (20 + 43 + 51) * 4
                nextState = .oamSearch
                print("[GPU] VBLANK until \(targetClock)")
            }
        }
    }
    
}
