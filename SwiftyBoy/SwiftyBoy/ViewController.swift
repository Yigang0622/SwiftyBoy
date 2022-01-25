//
//  ViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit
import Foundation

class ViewController: UIViewController {
        
    let mb = Motherboard()
    
    var fpsTimer: DispatchSourceTimer!
    var queue: DispatchQueue!
    var frameCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        let fpsLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 100, height: 50))
        fpsLabel.backgroundColor = .black
        fpsLabel.textColor = .red
        fpsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        self.view.addSubview(fpsLabel)
        
        queue = DispatchQueue(label: "fpsQueue")
        fpsTimer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        
        fpsTimer.setEventHandler {
            let fps = self.frameCount
            self.frameCount = 0
            DispatchQueue.main.async {
                fpsLabel.text = "\(fps)"
            }
            
        }
        
        self.fpsTimer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(10))
        self.fpsTimer.resume()
        
        let scale = 3
        let imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 256 * scale, height: 256 * scale))
        view.addSubview(imageView)
        
        mb.gpu.onFrameUpdateV2 = { pixels in
            self.frameCount += 1
            
            DispatchQueue.main.async {
                var pixels = pixels
                let w = 256
                let h = 256
                //           var pixels = Array<UInt32>(repeating: 0xAAAAAAff, count: 100 * 100)

                let rgbColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
                let bitsPerComponent = 8
                let bitsPerPixel = 32

                let providerRef = CGDataProvider(data: NSData(bytes: &pixels, length: pixels.count * 4))

                let cgim = CGImage(
                   width: w,
                   height: h,
                   bitsPerComponent: bitsPerComponent,
                   bitsPerPixel: bitsPerPixel,
                   bytesPerRow: w * 4,
                   space: rgbColorSpace,
                   bitmapInfo: bitmapInfo,
                   provider: providerRef!,
                   decode: nil,
                   shouldInterpolate: true,
                   intent: .defaultIntent
                   )
                
                if let cgImage = cgim {
                    imageView.image =  UIImage(cgImage: cgImage, scale: 2, orientation: .up)
                }
                
            }
            

        }
        
        DispatchQueue.global().async {
            self.mb.run()
            
        }
        
        
        let keyInputMask = KeyInputMask(frame: self.view.bounds)
        keyInputMask.becomeFirstResponder()
        
        keyInputMask.onKeyPress = { button in
            self.mb.joypad.pressButton(type: button)
        }
        
        keyInputMask.onKeyRelease = { button in
            self.mb.joypad.releaseButton(type: button)
        }
        
        self.view.addSubview(keyInputMask)
    }
    
    
    
    // 16 * 16
    
    func drawRectangle(pixels: [[Int]], palette: PaletteRegister) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 256, height: 256))


        let img = renderer.image { ctx in
            for i in 0..<256 {
                for j in 0..<256 {
                    let rectangle = CGRect(x: j, y: i, width: 1, height: 1)
                    var color = pixels[i][j]
                    color = palette.getColor(i: color)
                    if color == 0 {
                        ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
                    } else if color == 1 {
                        ctx.cgContext.setStrokeColor(UIColor.lightGray.cgColor)
                    } else if color == 2 {
                        ctx.cgContext.setStrokeColor(UIColor.darkGray.cgColor)
                    } else if color == 3 {
                        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                    }

                    ctx.cgContext.addRect(rectangle)
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
            }
            
            
        }
        
       return img
    }
    


}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

}


