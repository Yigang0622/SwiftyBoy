//
//  Renderer+DevMode.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/17.
//

import UIKit

extension Renderer {
    
    func getBackgroundLayer() -> FrameData {
        
        let offset = Renderer.vramOffset
        var backgound = Array(repeating: 0, count: 32 * 32)
        //        var window = Array(repeating: 0, count: 1024)
        
        if gpu.lcdcRegister.backgroundTileMapSelect == .map0 {
            backgound = Array(gpu.vram[(0x9800 - offset)...(0x9BFF - offset)])
        } else if gpu.lcdcRegister.backgroundTileMapSelect == .map1 {
            backgound = Array(gpu.vram[0x9C00 - offset ... 0x9FFF - offset])
        }
         let backgroundWidth = 256
         let backgroundHeight = 256
         var backgroundData = Array<UInt32>(repeating: 0x000000FF, count: backgroundWidth * backgroundHeight)
         for i in 0..<32 {
             for j in 0..<32 {
                 let idx = i * 32 + j
                 var tileId = Int(backgound[idx])
                 if gpu.lcdcRegister.tileDataSelect == .tile0 {
                     tileId = (tileId ^ 0x80) + 128
                 }
                 for tileY in 0...7 {
                     for tileX in 0...7 {
                         let colorIdx = tileCache[tileId].getPixel(i: tileY, j: tileX)
                         let dataIdx = (i * 8 + tileY) * 256 + j * 8 + tileX
                         let color = gpu.backgroundPalette.getColor(i: colorIdx)
                         backgroundData[dataIdx] = Palette.getPaletteColor(colorCode: color)
                     }
                 }
             }
         }
        
        return FrameData(frameWidth: backgroundWidth, frameHeight: backgroundHeight, data: backgroundData)
        
    }
    
    func getWindowLayer() -> FrameData {
        
        let offset = Renderer.vramOffset
        var window = Array(repeating: 0, count: 32 * 32)
 
        switch gpu.lcdcRegister.windowTileMapSelect {
        case .map0:
            window = Array(gpu.vram[(0x9800 - offset)...(0x9BFF - offset)])
            break
        case .map1:
            window = Array(gpu.vram[0x9C00 - offset ... 0x9FFF - offset])
            break
        }
        
         let w = 256
         let h = 256
         var data = Array<UInt32>(repeating: 0x000000FF, count: w * h)
         for i in 0..<32 {
             for j in 0..<32 {
                 let idx = i * 32 + j
                 var tileId = Int(window[idx])
                 if gpu.lcdcRegister.tileDataSelect == .tile0 {
                     tileId = (tileId ^ 0x80) + 128
                 }
                 for tileY in 0...7 {
                     for tileX in 0...7 {
                         let colorIdx = tileCache[tileId].getPixel(i: tileY, j: tileX)
                         let dataIdx = (i * 8 + tileY) * 256 + j * 8 + tileX
                         let color = gpu.backgroundPalette.getColor(i: colorIdx)
                         data[dataIdx] = Palette.getPaletteColor(colorCode: color)
                     }
                 }
             }
         }
        
        return FrameData(frameWidth: w, frameHeight: h, data: data)
    }
    
    func getSpriteLayer() -> FrameData {
        
        let w = 256
        let h = 256
        var data = Array<UInt32>(repeating: 0x000000FF, count: w * h)
        
        func drawSpriteTile(x: Int, y: Int, tileId: Int, xFlip: Bool, yFlip: Bool, palette: Int, priority: Bool) {
            let tile = tileCache[tileId]
            for tileY in 0...7 {
                for tileX in 0...7 {
                    let tY = yFlip ? 7 - tileY : tileY
                    let tX = xFlip ? 7 - tileX : tileX
                    let frameX = x + tX
                    let frameY = y + tY
                    
                    let palatteIndex = tile.getPixel(i: tileY, j: tileX)
                    let color = palette == 0 ? gpu.obj0Palatte.getColor(i: palatteIndex) : gpu.obj1Palatte.getColor(i: palatteIndex)
                    let frameBufferIdx = frameY * w + frameX
                    
                    if frameBufferIdx >= 0 && frameBufferIdx < data.count {
                        data[frameBufferIdx] = Palette.getPaletteColor(colorCode: color)
                    }
                   
                }
            }
        }
        
        spriteCache.forEach { sprite in
            let x = sprite.posX - 8
            let y = sprite.posY - 16
                        
            if gpu.lcdcRegister.spriteSize == .size8x16 {
                // 8 x 16
                if sprite.yFlip {
                    drawSpriteTile(x: x, y: y, tileId: sprite.patternNumber + 1, xFlip: sprite.xFlip, yFlip: sprite.yFlip, palette: sprite.palette, priority: sprite.priority)
                    drawSpriteTile(x: x, y: y + 8, tileId: sprite.patternNumber, xFlip: sprite.xFlip, yFlip: sprite.yFlip, palette: sprite.palette, priority: sprite.priority)
                } else {
                    drawSpriteTile(x: x, y: y, tileId: sprite.patternNumber, xFlip: sprite.xFlip, yFlip: sprite.yFlip, palette: sprite.palette, priority: sprite.priority)
                    drawSpriteTile(x: x, y: y + 8, tileId: sprite.patternNumber + 1, xFlip: sprite.xFlip, yFlip: sprite.yFlip, palette: sprite.palette, priority: sprite.priority)
                }
                
            } else if gpu.lcdcRegister.spriteSize == .size8x8 {
                drawSpriteTile(x: x, y: y, tileId: sprite.patternNumber, xFlip: sprite.xFlip, yFlip: sprite.yFlip, palette: sprite.palette, priority: sprite.priority)
            }
            
        }
        
        return FrameData(frameWidth: w, frameHeight: h, data: data)
    }
    
    
}
