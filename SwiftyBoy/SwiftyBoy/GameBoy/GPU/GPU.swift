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
    
    var backgroundPixels = Array(repeating: Array(repeating: 0, count: 256), count: 256)
    
    weak var mb: Motherboard!
    
    var vram = Array<Int>(repeating: 0x00, count: 8 * 1024)
    var oam = Array<Int>(repeating: 0x00, count: 0xA0)
    
    public var onFrameUpdate: (([[Int]]) -> Void)?
    public var onFrameUpdateV2: (([UInt32]) -> Void)?
    
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
    var obj0Palatte = PaletteRegister(val: 0xFF)
    var obj1Palatte = PaletteRegister(val: 0xFF)
    var wy = 0x00
    var wx = 0x00
    var lyMax = 153
    
    func tick(numOfCycles: Int) {
        clock += numOfCycles
                
        if targetClock > GPU.FULL_FRAME_CYCLE {
            clock %=  GPU.FULL_FRAME_CYCLE
            targetClock %= GPU.FULL_FRAME_CYCLE
        }
        
        // should change state
        if clock > targetClock {
//            print("[GPU] clock \(clock) target \(targetClock)")
            
            if ly == lyMax {
                nextState = .oamSearch
                resetLY()
            }
            
            if nextState == .vBlank {
                mb.cpu.interruptFlagRegister.vblank = true
            }
            
            currentState = nextState
            if currentState == .oamSearch {
                // 20 clocks
                targetClock += 20 * 4
                nextState = .pixelTransfer
                increaseLY()
            } else if currentState == .pixelTransfer {
                targetClock += 43 * 4
                nextState = .hBlank
                
            } else if currentState == .hBlank {
                targetClock += 51 * 4
                // TODO draw line
                
                // full frame drawn
                if ly <= 143 {
//                    print("[GPU] drawn new frame ")
                    nextState = .oamSearch
                } else {
                    nextState = .vBlank
                }
                
            } else if currentState == .vBlank {
                targetClock += (20 + 43 + 51) * 4
                nextState = .vBlank
                if ly == 144 {
                    frameCount += 1
//                    print("[GPU] frame done \(frameCount)")
                    self.draw()
                    mb.cpu.interruptFlagRegister.vblank = true
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
        if ly == lyc {
            mb.cpu.interruptFlagRegister.lcdc = true
        }
    }
    
    func draw() {
        let offset = 0x8000
        var backgound = [Int]()
        var tileData = [Int]()
        var tiles = [Tile]()
        if lcdcRegister.backgroundTileMapSelect == .map0 {
            backgound = Array(vram[(0x9800 - offset)...(0x9BFF - offset)])
        } else if lcdcRegister.backgroundTileMapSelect == .map1 {
            backgound = Array(vram[0x9C00 - offset ... 0x9FFF - offset])
        }
        
        
        if lcdcRegister.tileDataSelect == .tile0 {
            tileData = Array(vram[(0x8800 - offset)...(0x97FF - offset)])
        } else if lcdcRegister.tileDataSelect == .tile1 {
            tileData = Array(vram[(0x8000 - offset)...(0x8FFF - offset)])
        }
        
        for i in 0...255 {
            let start = i * 16
            let end = start + 16
            let sub = Array(tileData[start ..< end])
            let t = Tile(bytes: sub, mode: lcdcRegister.tileDataSelect == .tile1 ? 0 : 1 )
            tiles.append(t)
        }
        

//        var tileMaps = Array(repeating: Array(repeating: 0, count: 256), count: 256)
//
//        for i in 0..<16 {
//            for j in 0..<16 {
//                let tileId = i * 16 + j
//                for tileY in 0...7 {
//                    for tileX in 0...7 {
//                        tileMaps[i*16+tileY][j*16+tileX] = tiles[tileId].pixels[tileY][tileX]
//                    }
//                }
//
//            }
//        }
//
//        var backgroundPixels = Array(repeating: Array(repeating: 0, count: 256), count: 256)
//
//        for i in 0..<32 {
//            for j in 0..<32 {
//                let idx = i * 32 + j
//                let tileId = Int(backgound[idx])
////                print(tileId, terminator: "\t")
//                for tileY in 0...7 {
//                    for tileX in 0...7 {
//                        backgroundPixels[i*8+tileY][j*8+tileX] = tiles[tileId].pixels[tileY][tileX]
//                    }
//                }
//
//            }
//        }
//        onFrameUpdate?(backgroundPixels)
        
        let backgroundWidth = 256
        let backgroundHeight = 256
        var backgroundData = Array<UInt32>(repeating: 0x000000FF, count: backgroundWidth * backgroundHeight)
        for i in 0..<32 {
            for j in 0..<32 {
                let idx = i * 32 + j
                let tileId = Int(backgound[idx])
                for tileY in 0...7 {
                    for tileX in 0...7 {
                        let color = tiles[tileId].pixels[tileY][tileX]
                        let dataIdx = (i * 8 + tileY) * 256 + j * 8 + tileX

                        if color == 0 {
                            backgroundData[dataIdx] = 0xFFFFFFFF
                        } else if color == 1 {
                            backgroundData[dataIdx] = 0xAAAAAAFF
                        } else if color == 2 {
                            backgroundData[dataIdx] = 0x444444FF
                        } else if color == 3 {
                            backgroundData[dataIdx] = 0x000000FF
                        }
                    }
                }                
            }
        }
        onFrameUpdateV2?(backgroundData)
        
    }
    
}
