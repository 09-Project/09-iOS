//
//  customView.swift
//  09
//
//  Created by 김기영 on 2021/10/15.
//

import UIKit

class customView: UIView {
    
    lazy var Label = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
        $0.textColor = .black
    }
    
    lazy var lineView1 = UIView().then {
        $0.backgroundColor = .init(named: "placeholderColor")
    }
    
    lazy var View = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var lineView2 = UIView().then {
        $0.backgroundColor = .init(named: "placeholderColor")
    }
    
    lazy var Txt = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .none
        $0.font = .init(name: Font.fontRegular.rawValue, size: 13)
        $0.textColor = .init(named: "placeholderColor")
        $0.textAlignment = .left
    }
    
    lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "원"
        $0.font = .init(name: Font.fontRegular.rawValue, size: 13)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        [Label, lineView1, View, lineView2, Txt, label].forEach { self.addSubview($0)}
        
        Label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(34)
        }
        
        lineView1.snp.makeConstraints {
            $0.bottom.equalTo(self.View.snp.top).offset(0)
            $0.height.equalTo(0.5)
            $0.width.equalTo(View.snp.width)
        }
        
        View.snp.makeConstraints {
            $0.top.equalTo(self.Label.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(0)
            $0.height.lessThanOrEqualTo(48)
        }
        
        lineView2.snp.makeConstraints {
            $0.bottom.equalTo(self.View.snp.bottom).offset(0)
            $0.height.equalTo(0.5)
            $0.width.equalTo(View.snp.width)
        }
        
        Txt.snp.makeConstraints {
            $0.top.equalTo(self.View.snp.top).offset(14)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-34)
            $0.leading.lessThanOrEqualToSuperview().offset(34)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(self.View.snp.top).offset(14)
            $0.leading.equalTo(self.Txt.snp.trailing).offset(-6)
        }
    }
    
    
    
}
