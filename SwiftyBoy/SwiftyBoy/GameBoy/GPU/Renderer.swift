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
    
    private func updateTileCache() {
//        let tileData = Array(gpu.vram[(0x8000 - Renderer.vramOffset)...(0x97FF - Renderer.vramOffset)])
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
        
        var vramOffset = 0
        if gpu.lcdcRegister.backgroundTileMapSelect == .map0 {
            vramOffset = 0x9800 - Renderer.vramOffset
        } else if gpu.lcdcRegister.backgroundTileMapSelect == .map1 {
            vramOffset = 0x9C00 - Renderer.vramOffset
        }
        let tileOffset = gpu.lcdcRegister.tileDataSelect == .tile0 ? 0xFF + 1 : 0
        
        for i in 0 ..< Renderer.frameWidth {
            var y = line + gpu.scy
            var x = i + gpu.scx
            if y > 255 { y -= 255 }
            if x > 255 { x -= 255 }
            let backgroundY:Int = y / 8
            let backgroundX:Int = x / 8
            let backgroundIdx = backgroundY * 32 + backgroundX
            
            var tileId =  gpu.vram[vramOffset + backgroundIdx]
            if tileId <= 0x7F {
                tileId += tileOffset
            }
            
            let tileX = x % 8
            let tileY = y % 8
            let tileData = tileCache[tileId].getPixel(i: tileY, j: tileX)
            let colorCode = self.gpu.backgroundPalette.getColor(i: tileData)
            
            let frameBufferIdx = line * Renderer.frameWidth + i
            _frameBuffer[frameBufferIdx] = Palette.getPaletteColor(colorCode: colorCode)
        }
    }
    
}
