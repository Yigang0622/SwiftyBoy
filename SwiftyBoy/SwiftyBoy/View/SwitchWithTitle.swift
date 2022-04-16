//
//  SwitchWithTitle.swift
//  SwiftyBoy
//
//  Created by Yigang Zhou on 2022/4/16.
//

import UIKit
import SnapKit

class SwitchWithTitle: UIView {
    
    var title: String {
        get {
            return label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
    
    var onSwitchToggle:((_ isOn: Bool) -> Void)?
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(40)
        }
        
        self.isUserInteractionEnabled = true
        
        let s = UISwitch()
        s.setOn(true, animated: true)
        s.addTarget(self, action: #selector(self.toggle(sender:)), for: .valueChanged)
        addSubview(s)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(s.snp.left)
            make.centerY.equalToSuperview()
        }
        
        s.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    @objc func toggle(sender: UISwitch) {
        self.onSwitchToggle?(sender.isOn)
    }
    
}
