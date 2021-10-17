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
    
    private let symbolImg = UIImage(named: "symbolImg")
    private let logoImg = UIImage(named: "logoImg")
    
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
        $0.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        $0.backgroundColor = UIColor.white
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setUpView()
    }
    override func viewDidLayoutSubviews() {
        setLabel()
    }
    
    private func setUpView() {
        
        [symbolImgView, symbolImgView, label].forEach { self.view.addSubview($0)}
        
        self.symbolImgView.snp.makeConstraints {
            $0.top.lessThanOrEqualToSuperview().offset(283)
            $0.height.width.equalTo(80)
            $0.centerX.equalTo(self.view)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.symbolImgView.snp.bottom).offset(28)
            $0.centerX.equalTo(self.view)
        }
        
        self.logoImgView.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(8)
            $0.width.equalTo(40)
            $0.height.equalTo(27)
            $0.centerX.equalTo(self.view)
        }
        
    }
    
    private func setLabel() {
        let attributedStr = NSMutableAttributedString(string: label.text!)
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.init(named: "mainColor"), range: (label.text! as NSString).range(of: "공동구매"))
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.init(named: "mainColor"), range: (label.text! as NSString).range(of: "무료나눔"))
        
        attributedStr.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Bold", size: 16), range: (label.text! as NSString).range(of: "공동구매"))
        
        attributedStr.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Bold", size: 16), range: (label.text! as NSString).range(of: "무료나눔"))
        
        label.attributedText = attributedStr
    }
    
}
