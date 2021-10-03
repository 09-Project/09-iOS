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
        $0.borderStyle = .none
        $0.textAlignment = .left
        $0.backgroundColor = .white
        $0.textColor = UIColor.init(named: "mainColor")
        $0.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var pwTxt = UITextField().then {
        $0.borderStyle = .none
        $0.textAlignment = .left
        $0.backgroundColor = .white
        $0.textColor = UIColor.init(named: "mainColor")
        $0.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
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
        $0.layer.cornerRadius = 10
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "계정이 없으신가요?"
        $0.textColor = .black
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    private lazy var moveSignupBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("회원가입하기", for: .normal)
        $0.setTitleColor(.init(named: "mainColor"), for: .normal)
        $0.titleLabel!.font = UIFont.preferredFont(forTextStyle: .caption1)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        idCheckLabel.sizeToFit()
        setObj()
    }
    
    private func setupView() {
        view.addSubview(symbolImgView)
        view.addSubview(logoImgView)
        view.addSubview(loginLabel)
        view.addSubview(idTxt)
        view.addSubview(pwTxt)
        view.addSubview(checkBtn)
        view.addSubview(idCheckLabel)
        view.addSubview(loginBtn)
        view.addSubview(label)
        view.addSubview(moveSignupBtn)
        
        self.symbolImgView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(170)
            $0.top.equalToSuperview().offset(70)
            $0.trailing.equalTo(self.logoImgView.snp.leading).offset(-10)
            $0.height.width.equalTo(31)
        }
        self.logoImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.height.equalTo(33)
            $0.width.equalTo(45)
        }
        
        self.loginLabel.snp.makeConstraints {
            $0.top.equalTo(self.logoImgView.snp.bottom).offset(90)
            $0.leading.equalToSuperview().offset(180)
            $0.width.equalTo(85)
            $0.height.equalTo(42)
        }
        self.idTxt.snp.makeConstraints {
            $0.top.equalTo(self.loginLabel.snp.bottom).offset(50)
            $0.width.equalTo(320)
            $0.height.equalTo(31)
            $0.leading.equalToSuperview().offset(45)
        }
        self.pwTxt.snp.makeConstraints {
            $0.top.equalTo(self.idTxt.snp.bottom).offset(70)
            $0.width.equalTo(320)
            $0.height.equalTo(31)
            $0.leading.equalToSuperview().offset(45)
        }
        self.checkBtn.snp.makeConstraints {
            $0.top.equalTo(self.pwTxt.snp.bottom).offset(21.5)
            $0.leading.equalToSuperview().offset(45)
            $0.height.width.equalTo(18)
        }
        self.idCheckLabel.snp.makeConstraints {
            $0.top.equalTo(self.pwTxt.snp.bottom).offset(20)
            $0.leading.equalTo(self.checkBtn.snp.trailing).offset(5)
            $0.width.equalTo(50)
            $0.height.equalTo(20)
        }
        self.loginBtn.snp.makeConstraints {
            $0.top.equalTo(self.pwTxt.snp.bottom).offset(200)
            $0.leading.equalToSuperview().offset(45)
            $0.width.equalTo(320)
            $0.height.equalTo(65)
        }
        self.label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(120)
            $0.top.equalTo(self.loginBtn.snp.bottom).offset(20)
        }
        self.moveSignupBtn.snp.makeConstraints {
            $0.leading.equalTo(self.label.snp.trailing).offset(5)
            $0.top.equalTo(self.loginBtn.snp.bottom).offset(12.5)
        }
    }
    private func setObj() {
        let aa = NSMutableAttributedString(string: moveSignupBtn.currentTitle!)
        let underLine = NSUnderlineStyle.thick.rawValue
        aa.addAttribute(NSMutableAttributedString.Key.underlineStyle, value: underLine, range: NSRange(location: 0, length: moveSignupBtn.currentTitle!.count))
        moveSignupBtn.setAttributedTitle(aa, for: .normal)
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: idTxt.frame.size.height+5, width: idTxt.frame.width, height: 1)
        border.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
        idTxt.layer.addSublayer(border)
        
        let border1 = CALayer()
        border1.frame = CGRect(x: 0, y: pwTxt.frame.size.height+5, width: pwTxt.frame.width, height: 1)
        border1.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
        pwTxt.layer.addSublayer(border1)
    }
}
