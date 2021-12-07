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
    
    
    private var LY = 0
    private var clock = 0
    private var targetClock = 0
    
    private var currentState: GPUState = .oamSearch
    private var nextState: GPUState = .oamSearch
    
    func tick(numOfCycles: Int) {
        clock += numOfCycles
        
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
                LY += 1
                print("[GPU] HBLANK line \(LY) until \(targetClock)")
                // full frame drawn
                if LY > 143 {
                    LY = 0
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
