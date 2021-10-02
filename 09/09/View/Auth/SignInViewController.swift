//
//  SignUpViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/02.
//

import UIKit

class SignInViewController: UIViewController {
    
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
    
    private lazy var loginLabel = UILabel().then {
        $0.text = "LOG IN"
        $0.textColor = .black
        $0.backgroundColor = .white
    }
    
    private lazy var idTxt = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = UIColor.init(named: "mainColor")
        $0.attributedPlaceholder = NSAttributedString(string: "PASSWORD!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var pwTxt = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = UIColor.init(named: "mainColor")
        $0.attributedPlaceholder = NSAttributedString(string: "PASSWORD!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var checkBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.setTitleColor(.init(named: "mainColor"), for: .normal)
    }
    
    private lazy var idCheckLabel = UILabel().then {
        $0.text = "아이디 저장"
        $0.textColor = .black
        $0.backgroundColor = .white
    }
    private lazy var loginBtn = UIButton().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("LOGIN", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "계정이 없으신가요?"
        $0.textColor = .black
    }
    private lazy var moveSignupBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("회원가입하기", for: .normal)
        $0.setTitleColor(.init(named: "mainColor"), for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupView()
        setBtn()
    }
    
    private func setupView() {
        view.addSubview(symbolImgView)
        view.addSubview(logoImgView)
        view.addSubview(idTxt)
        view.addSubview(pwTxt)
        view.addSubview(checkBtn)
        view.addSubview(idCheckLabel)
        view.addSubview(loginBtn)
        view.addSubview(label)
        view.addSubview(moveSignupBtn)
        
        self.symbolImgView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(170)
            $0.top.equalToSuperview().offset(60)
            $0.trailing.equalTo(self.logoImgView.snp.leading).offset(-10)
            $0.height.width.equalTo(31)
        }
        self.logoImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.height.equalTo(33)
            $0.width.equalTo(45)
        }
    }
    private func setBtn() {
            let aa = NSMutableAttributedString(string: moveSignupBtn.currentTitle!)
            let underLine = NSUnderlineStyle.thick.rawValue
            aa.addAttribute(NSMutableAttributedString.Key.underlineStyle, value: underLine, range: NSRange(location: 0, length: moveSignupBtn.currentTitle!.count))
            moveSignupBtn.setAttributedTitle(aa, for: .normal)
    }
}
