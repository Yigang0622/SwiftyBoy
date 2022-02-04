//
//  GameboyLCDView.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/4.
//

import Foundation
import UIKit


class GameBoyLCDView: UIView {
    
    var fpsLabel: UILabel!
    var mainImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        
        mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.backgroundColor = .black
        mainImageView.contentMode = .scaleAspectFit
        self.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        fpsLabel = UILabel()
        fpsLabel.alpha = 0.8
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        fpsLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        fpsLabel.textColor = .systemRed
        self.addSubview(fpsLabel)
        
        
        NSLayoutConstraint.activate([
            fpsLabel.topAnchor.constraint(equalTo: self.topAnchor),
            fpsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            fpsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            fpsLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func setFpsText(fps: Int) {
        self.fpsLabel.text = "\(fps)"
    }
    
    func setFrame(frame: UIImage) {
        self.mainImageView.image = frame
    }
    
}
