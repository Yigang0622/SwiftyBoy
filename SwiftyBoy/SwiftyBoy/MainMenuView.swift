//
//  MainMenuView.swift
//  SwiftyBoy
//
//  Created by Yigang on 2022/2/4.
//

import UIKit
import Darwin

class MainMenuView: UIView {
    
    var loadCartridgeButton: UIButton!
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    private func setupViews() {
        self.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.widthAnchor.constraint(equalToConstant: 350),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        titleLabel.textColor = .black
        titleLabel.text = ""
        titleLabel.font = UIFont.pixelatedFont(ofSize: 80)
        
        loadCartridgeButton = UIButton()
        loadCartridgeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadCartridgeButton)
        NSLayoutConstraint.activate([
            loadCartridgeButton.heightAnchor.constraint(equalToConstant: 50),
            loadCartridgeButton.widthAnchor.constraint(equalToConstant: 350),
            loadCartridgeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadCartridgeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        loadCartridgeButton.setTitle("LOAD CARTRIDGE", for: .normal)
        loadCartridgeButton.titleLabel?.font = UIFont.pixelatedFont(ofSize: 40)
        loadCartridgeButton.setTitleColor(.black, for: .normal)
    }
    
}

extension UIFont {
    
    static func pixelatedFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Pixelated", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
    
}
