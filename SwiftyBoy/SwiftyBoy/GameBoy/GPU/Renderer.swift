//
//  Renderer.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/1/29.
//

import Foundation

struct FrameData {
    
    var frameWidth = 0
    var frameHeight = 0
    var data = Array<UInt32>()
    
}

class Renderer {
    
    private var gpu: GPU!
    private var tileCache = Array<Tile>(repeating: Tile(), count: 384)
    private var spriteCache = Array<Sprite>(repeating: Sprite(), count: 40)
    
    
    private static let frameWidth = 160
    private static let frameHeight = 144
    private static let vramOffset = 0x8000
    
    private var _frameBuffer = Array<UInt32>(repeating: 0x000000FF, count: frameWidth * frameHeight)
    
    var frameData: FrameData {
        get {
            return FrameData(frameWidth: Renderer.frameWidth, frameHeight: Renderer.frameHeight, data: _frameBuffer)
        }
    }
    
    init(gpu: GPU) {
        self.gpu = gpu
    }
    
    private func updateSpriteCache() {
        Array(0..<40).forEach { i in
            spriteCache[i] = Sprite.from(byte0: gpu.oam[i * 4 + 0],
                                         byte1: gpu.oam[i * 4 + 1],
                                         byte2: gpu.oam[i * 4 + 2],
                                         byte3: gpu.oam[i * 4 + 3])
        }
    }

    private func updateTileCache() {
        let vramOffset = 0x8000 - Renderer.vramOffset
        for i in 0 ..< 384 {
            let start = vramOffset + i * 16
            let end = start + 16
            let sub = Array(gpu.vram[start ..< end])
            let t = Tile.from(with: sub)
            tileCache[i] = t
        }
    }
    
    public func clearFrameBuffer() {
        _frameBuffer = _frameBuffer.map{ _ in 0x000000FF }
    }
    
    public func drawLine(line: Int) {
        if line == 0 {
            updateTileCache()
        }
        
        var backgroundVramOffset = 0
        if gpu.lcdcRegister.backgroundTileMapSelect == .map0 {
            backgroundVramOffset = 0x9800 - Renderer.vramOffset
        } else if gpu.lcdcRegister.backgroundTileMapSelect == .map1 {
            backgroundVramOffset = 0x9C00 - Renderer.vramOffset
        }
        
        var windowVramOffset = 0
        if gpu.lcdcRegister.windowTileMapSelect == .map0 {
            windowVramOffset = 0x9800 - Renderer.vramOffset
        } else if gpu.lcdcRegister.windowTileMapSelect == .map1 {
            windowVramOffset = 0x9C00 - Renderer.vramOffset
        }
                
        let tileOffset = gpu.lcdcRegister.tileDataSelect == .tile0 ? 0xFF : 0
        
        for i in 0 ..< Renderer.frameWidth {
            var y = line + gpu.scy
            var x = i + gpu.scx
            if y > 255 { y -= 255 }
            if x > 255 { x -= 255 }
            let backgroundY:Int = y / 8
            let backgroundX:Int = x / 8
            let backgroundIdx = backgroundY * 32 + backgroundX
            
            var tileId =  gpu.vram[backgroundVramOffset + backgroundIdx]
            if gpu.lcdcRegister.tileDataSelect == .tile0 {
                // converted to signed and plus 256
//                tileId ^= 0x80 + 0x80
                tileId = (tileId ^ 0x80) + 128
            }
            
            let tileX = x % 8
            let tileY = y % 8
            let tileData = tileCache[tileId].getPixel(i: tileY, j: tileX)
            let colorCode = self.gpu.backgroundPalette.getColor(i: tileData)
            
            let frameBufferIdx = line * Renderer.frameWidth + i
            _frameBuffer[frameBufferIdx] = Palette.getPaletteColor(colorCode: colorCode)
                        
            // should draw window
            if gpu.lcdcRegister.windowEnable && line >= gpu.wy && i >= gpu.wx {
                let y = line - gpu.wy
                let x = i - gpu.wx
                let windowY = y / 8
                let windowX = x / 8
                let windowIdx = windowY * 32 + windowX
                var tileId =  gpu.vram[windowVramOffset + windowIdx]
                if gpu.lcdcRegister.tileDataSelect == .tile0 {
                    tileId = (tileId ^ 0x80) + 128
                }
                let tileX = x % 8
                let tileY = y % 8
                let tileData = tileCache[tileId].getPixel(i: tileY, j: tileX)
                let colorCode = self.gpu.backgroundPalette.getColor(i: tileData)
                
                let frameBufferIdx = line * Renderer.frameWidth + i
                _frameBuffer[frameBufferIdx] = Palette.getPaletteColor(colorCode: colorCode)
//                _frameBuffer[frameBufferIdx] = 0x993300FF
               
            }
        }
        
        // draw sprite
        if line == 143 {
            updateSpriteCache()
            drawSprites()
        }
        
    }
    
    
    private func drawSprites() {
        spriteCache.forEach { sprite in
            if sprite.visibleOnScreen() {
                let x = sprite.posX
                let y = sprite.posY
                let tile = tileCache[sprite.patternNumber]

                for tileY in 0...7 {
                    for tileX in 0...7 {
                        let tY = sprite.yFlip ? 7 - tileY : tileY
                        let tX = sprite.xFlip ? 7 - tileX : tileX
                        let palatteIndex = tile.getPixel(i: tY, j: tX)
                        let dataIdx = (y - 16 + tileY) * Renderer.frameWidth + (x - 8 + tileX)
                        if palatteIndex != 0 {
                            let color = gpu.obj0Palatte.getColor(i: palatteIndex)
                            if dataIdx >= 0 && dataIdx < _frameBuffer.count {
                                _frameBuffer[dataIdx] = Palette.getPaletteColor(colorCode: color)
                            }
                        }
                    }
                }

                if gpu.lcdcRegister.spriteSize == .size1 {
                    let x = sprite.posX
                    let y = sprite.posY + 8
                    let tile = tileCache[sprite.patternNumber + 1]
                    for tileY in 0...7 {
                        for tileX in 0...7 {
                            let tY = sprite.yFlip ? 7 - tileY : tileY
                            let tX = sprite.xFlip ? 7 - tileX : tileX
                            let palatteIndex = tile.getPixel(i: tY, j: tX)
                            let dataIdx = (y - 16 + tileY) * Renderer.frameWidth + (x - 8 + tileX)
                            if palatteIndex != 0 {
                                let color = gpu.obj0Palatte.getColor(i: palatteIndex)
                                if dataIdx >= 0 && dataIdx < _frameBuffer.count {
                                    _frameBuffer[dataIdx] = Palette.getPaletteColor(colorCode: color)
                                }
                            }
                        }
                    }
                }

            }
        }
    }
    
}
