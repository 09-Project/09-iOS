//
//  ViewController.swift
//  09
//
//  Created by 김기영 on 2021/09/10.
//

import UIKit
import SnapKit
import Then

class SplashViewController: UIViewController {
    
    private let symbolImg = UIImage(named: "symbol_09")
    private let logoImg = UIImage(named: "logo_09")
    
    private lazy var symbolImgView = UIImageView().then {
        $0.image = symbolImg
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
    }
    
    private lazy var logoImgView = UIImageView().then {
        $0.image = logoImg
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
    }
    
    private lazy var label = UILabel().then {
        $0.text = "\"공동구매부터 무료나눔까지\""
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setUpView()
        setLabel()
    }
    
    private func setUpView() {
        
        view.addSubview(symbolImgView)
        view.addSubview(logoImgView)
        view.addSubview(label)
        
        self.symbolImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(240)
            $0.height.width.equalTo(87)
            $0.trailing.leading.equalTo(self.view)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.symbolImgView.snp.bottom).offset(50)
            $0.trailing.equalTo(self.view)
            $0.leading.equalTo(self.view)
        }
        
        self.logoImgView.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(20)
            $0.width.equalTo(45)
            $0.height.equalTo(33)
            $0.trailing.leading.equalTo(self.view)
        }
        
    }
    
    private func setLabel() {
        let attributedStr = NSMutableAttributedString(string: label.text!)
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.init(named: "mainColor"), range: (label.text! as NSString).range(of: "공동구매"))
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.init(named: "mainColor"), range: (label.text! as NSString).range(of: "무료나눔"))
        
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: (label.text! as NSString).range(of: "공동구매"))
        
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: (label.text! as NSString).range(of: "무료나눔"))
        
        label.attributedText = attributedStr
    }

}

