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
    
    var mb: Motherboard!
    
    var vram = Array<Int>(repeating: 0x00, count: 8 * 1024)
    var oam = Array<Int>(repeating: 0x00, count: 0xA0)
    
    public var onFrameUpdate: (([[Int]]) -> Void)?
    public var onFrameUpdateV2: (([UInt32]) -> Void)?
    public var onViewPortUpdate: (([UInt32]) -> Void)?
    public var onPhaseChange: ((GPUState) -> Void)?
    
    private static let FULL_FRAME_CYCLE = 70224
//    private var LY = 0
    private var clock:Int = 0
    private var targetClock:Int = 0
    
    private var currentState: GPUState = .oamSearch
    private var nextState: GPUState = .oamSearch
    
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
    
    func tick(numOfCycles: Int) {
        
        if renderer == nil {
            renderer = Renderer(gpu: self)
        }
        
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
                    self.draw()
                    mb.cpu.interruptFlagRegister.vblank = true
                    onPhaseChange?(.vBlank)
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
        if ly >= 0 && ly < 144 {
//            renderer.drawLine(line: ly)
        }
        
    }
    
    func draw() {
//        let offset = 0x8000
//        var backgound = Array(repeating: 0, count: 1024)
//        var window = Array(repeating: 0, count: 1024)
//
//        var tiles = [Tile]()
//
//        if lcdcRegister.backgroundTileMapSelect == .map0 {
//            backgound = Array(vram[(0x9800 - offset)...(0x9BFF - offset)])
//        } else if lcdcRegister.backgroundTileMapSelect == .map1 {
//            backgound = Array(vram[0x9C00 - offset ... 0x9FFF - offset])
//        }
//
//        if lcdcRegister.windowTileMapSelect == .map0 {
//            window = Array(vram[(0x9800 - offset)...(0x9BFF - offset)])
//        } else if lcdcRegister.windowTileMapSelect == .map1 {
//            window = Array(vram[0x9C00 - offset ... 0x9FFF - offset])
//        }
//
//
//        let tileData = Array(vram[(0x8000 - offset)...(0x97FF - offset)])
//        //todo figure out why 0xFF + 1
//        let tileOffset = lcdcRegister.tileDataSelect == .tile0 ? 0xFF + 1 : 0
//
//        for i in 0...255 + 128 {
//            let start = i * 16
//            let end = start + 16
//            let sub = Array(tileData[start ..< end])
//            let t = Tile.from(with: sub)
//            tiles.append(t)
//        }
//
//        let sprites: [Sprite] = Array(0..<40).map { i in
//            return Sprite.from(byte0: oam[i * 4 + 0],
//                               byte1: oam[i * 4 + 1],
//                               byte2: oam[i * 4 + 2],
//                               byte3: oam[i * 4 + 3])
//        }
//
//
//        let backgroundWidth = 256
//        let backgroundHeight = 256
//        var backgroundData = Array<UInt32>(repeating: 0x000000FF, count: backgroundWidth * backgroundHeight)
//        for i in 0..<32 {
//            for j in 0..<32 {
//                let idx = i * 32 + j
//                var tileId = Int(backgound[idx])
//                if tileId <= 0x7F {
//                    tileId += tileOffset
//                }
//
//                for tileY in 0...7 {
//                    for tileX in 0...7 {
//                        let colorIdx = tiles[tileId].getPixel(i: tileY, j: tileX)
//                        let dataIdx = (i * 8 + tileY) * 256 + j * 8 + tileX
//                        let color = self.backgroundPalette.getColor(i: colorIdx)
//                        backgroundData[dataIdx] = Palette.getPaletteColor(colorCode: color)
//                    }
//                }
//            }
//        }
//
      
        
        
        let viewPortWidth = 160
        let viewPortHeight = 144
        
        var viewPortData = Array<UInt32>(repeating: 0x000000FF, count: viewPortWidth * viewPortHeight)
        
//        for i in 0 ..< 144 {
//            for j in 0 ..< 160 {
//
//                var iNew = i + scy
//                if iNew > 255 {
//                    iNew -= 255
//                }
//
//                var jNew = j + scx
//                if jNew > 255 {
//                    jNew -= 255
//                }
//
//                let dataIdx = iNew * 256 + jNew
//                viewPortData[i * 160 + j] = backgroundData[dataIdx]
//            }
//        }
        
        viewPortData = renderer.frameData.data
        // draw sprites
//        sprites.forEach { sprite in
//            if sprite.visibleOnScreen() {
//                let x = sprite.posX
//                let y = sprite.posY
//                let tile = tiles[sprite.patternNumber]
//
//                for tileY in 0...7 {
//                    for tileX in 0...7 {
//                        let tY = sprite.yFlip ? 7 - tileY : tileY
//                        let tX = sprite.xFlip ? 7 - tileX : tileX
//                        let palatteIndex = tile.getPixel(i: tY, j: tX)
//                        let dataIdx = (y - 16 + tileY) * viewPortWidth + (x - 8 + tileX)
//                        if palatteIndex != 0 {
//                            let color = self.obj0Palatte.getColor(i: palatteIndex)
//                            if dataIdx < viewPortData.count {
//                                viewPortData[dataIdx] = Palette.getPaletteColor(colorCode: color)
//                            }
//                        }
//
//
//                    }
//                }
//
//                if lcdcRegister.spriteSize == .size1 {
//                    let x = sprite.posX
//                    let y = sprite.posY + 8
//                    let tile = tiles[sprite.patternNumber + 1]
//                    for tileY in 0...7 {
//                        for tileX in 0...7 {
//                            let tY = sprite.yFlip ? 7 - tileY : tileY
//                            let tX = sprite.xFlip ? 7 - tileX : tileX
//                            let palatteIndex = tile.getPixel(i: tY, j: tX)
//                            let dataIdx = (y - 16 + tileY) * viewPortWidth + (x - 8 + tileX)
//                            if palatteIndex != 0 {
//                                let color = self.obj0Palatte.getColor(i: palatteIndex)
//                                if dataIdx < viewPortData.count {
//                                    viewPortData[dataIdx] = Palette.getPaletteColor(colorCode: color)
//                                }
//                            }
//                        }
//                    }
//                }
//
//            }
//        }
//
    
//        onFrameUpdateV2?(backgroundData)
        onViewPortUpdate?(viewPortData)
        
    }
    
    
}
