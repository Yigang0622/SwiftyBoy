//
//  ViewController.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2021/11/25.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let mb = Motherboard()
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 256, height: 256))
        view.addSubview(imageView)
        
        var drawing = false
        mb.gpu.onFrameUpdate = { pixels in
            if !drawing {
                DispatchQueue.main.async {
                    if !drawing {
                        drawing = true
                        imageView.image = self.drawRectangle(pixels: pixels, palette: mb.gpu.backgroundPalette)
                        drawing = false
                    } else {
                        print("drawing ignore")
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            mb.run()
        }
        
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


