//
//  SignInViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/02.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    private var eyeBool = false
    
    private lazy var imgView = UIImageView().then {
        $0.image = UIImage(named: "logo&symoblImg")
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var joinusLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.text = "JOIN US"
        $0.font = UIFont.init(name: fontBold, size: 24)
    }
    
    private lazy var nickNameTxt = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.textAlignment = .left
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: fontRegular, size: 14)
        $0.attributedPlaceholder = NSAttributedString(string: "Nickname", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var nickView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var idTxt = UITextField().then {
        $0.borderStyle = .none
        $0.textColor = .init(named: "mainColor")
        $0.textAlignment = .left
        $0.font = .init(name: fontRegular, size: 14)
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var idView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var pwTxt = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.textAlignment = .left
        $0.font = .init(name: fontRegular, size: 14)
        $0.textColor = .init(named: "mainColor")
        $0.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var pwView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var nickErrorLabel =  UILabel().then {
        $0.backgroundColor = .white
        $0.text = "중복된 닉네임입니다."
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: fontRegular, size: 10)
    }
    
    private lazy var idErrorLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "중복된 아이디입니다."
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: fontRegular, size: 10)
    }
    
    private lazy var eyeBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.tintColor = .init(named: "placeholderColor")
        $0.setImage(.init(systemName: "eye.slash"), for: .normal)
    }
    
    private lazy var signupBtn = UIButton().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("JOIN US", for: .normal)
        $0.layer.cornerRadius = 10
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel!.font = .init(name: fontMedium, size: 14)
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "이미 계정이 있으신가요?"
        $0.font = .init(name: fontRegular, size: 12)
        $0.textColor = .black
    }
    
    private lazy var moveLoginBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("로그인하기", for: .normal)
        $0.titleLabel!.font = .init(name: fontRegular, size: 12)
        $0.setTitleColor(.init(named: "mainColor"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        idTxt.delegate = self
        pwTxt.delegate = self
        nickNameTxt.delegate = self
        idTxt.tag = 1
        pwTxt.tag = 2
        nickNameTxt.tag = 3
        eyeBtn.addTarget(self, action: #selector(changeBtn), for: .touchUpInside)
        moveLoginBtn.addTarget(self,
                               action: #selector(moveSignInViewController),
                               for: .touchUpInside)
        idErrorLabel.isHidden = true
        nickErrorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setBorder()
        idErrorLabel.isHidden = true
        nickErrorLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        setUpView()
        setObj()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            let border = CALayer()
            
            border.frame = CGRect(x: 0, y: idView.frame.size.height,
                                  width: idView.frame.width,
                                  height: 1)
            border.backgroundColor = UIColor.init(named: "mainColor")?.cgColor
            idView.layer.addSublayer(border)
            idTxt.textColor = .init(named: "mainColor")
        case 2:
            let border1 = CALayer()
            border1.frame = CGRect(x: 0, y: pwView.frame.size.height,
                                   width: pwView.frame.width,
                                   height: 1)
            border1.backgroundColor = UIColor.init(named: "mainColor")?.cgColor
            pwView.layer.addSublayer(border1)
            pwTxt.textColor = .init(named: "mainColor")
        case 3:
            let border2 = CALayer()
            border2.frame = CGRect(x: 0, y: nickView.frame.size.height,
                                   width: nickView.frame.width,
                                   height: 1)
            border2.backgroundColor = UIColor.init(named: "mainColor")?.cgColor
            nickView.layer.addSublayer(border2)
            nickNameTxt.textColor = .init(named: "mainColor")
        default:
            print(Error.self)
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            let border = CALayer()
            border.frame = CGRect(x: 0, y: idView.frame.size.height,
                                  width: idView.frame.width,
                                  height: 1)
            border.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
            idView.layer.addSublayer(border)
            idTxt.textColor = .init(named: "placeholderColor")
        case 2:
            let border1 = CALayer()
            border1.frame = CGRect(x: 0, y: pwView.frame.size.height,
                                   width: pwView.frame.width,
                                   height: 1)
            border1.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
            pwView.layer.addSublayer(border1)
            pwTxt.textColor = .init(named: "placeholderColor")
        case 3:
            let border2 = CALayer()
            border2.frame = CGRect(x: 0, y: nickView.frame.size.height,
                                   width: nickView.frame.width,
                                   height: 1)
            border2.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
            nickView.layer.addSublayer(border2)
            nickNameTxt.textColor = .init(named: "placeholderColor")
        default:
            print(Error.self)
            
        }
    }
    
    private func setUpView() {
        view.addSubview(imgView)
        view.addSubview(joinusLabel)
        view.addSubview(nickView)
        view.addSubview(nickNameTxt)
        view.addSubview(idView)
        view.addSubview(idTxt)
        view.addSubview(pwView)
        view.addSubview(pwTxt)
        view.addSubview(nickErrorLabel)
        view.addSubview(idErrorLabel)
        view.addSubview(eyeBtn)
        view.addSubview(signupBtn)
        view.addSubview(label)
        view.addSubview(moveLoginBtn)
        
        self.imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(73)
            $0.height.equalTo(28)
        }
        
        self.joinusLabel.snp.makeConstraints {
            $0.top.equalTo(self.imgView.snp.bottom).offset(80)
            $0.centerX.equalTo(self.view)
        }
        
        self.nickView.snp.makeConstraints {
            $0.top.equalTo(self.joinusLabel.snp.bottom).offset(69)
            $0.leading.lessThanOrEqualToSuperview().offset(45)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-45)
            $0.height.equalTo(28)
        }
        
        self.nickNameTxt.snp.makeConstraints {
            $0.top.equalTo(self.nickView.snp.top).offset(0)
            $0.leading.equalTo(self.nickView.snp.leading).offset(18)
            $0.trailing.equalTo(self.nickView.snp.trailing).offset(-18)
        }
        
        self.idView.snp.makeConstraints {
            $0.top.equalTo(self.nickView.snp.bottom).offset(76)
            $0.leading.lessThanOrEqualToSuperview().offset(45)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-45)
            $0.height.equalTo(28)
        }
        
        self.idTxt.snp.makeConstraints {
            $0.top.equalTo(self.idView.snp.top).offset(0)
            $0.leading.equalTo(self.idView.snp.leading).offset(18)
            $0.trailing.equalTo(self.idView.snp.trailing).offset(-18)
        }
        
        self.pwView.snp.makeConstraints {
            $0.top.equalTo(self.idView.snp.bottom).offset(76)
            $0.leading.lessThanOrEqualToSuperview().offset(45)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-45)
            $0.height.equalTo(28)
        }
        
        self.pwTxt.snp.makeConstraints {
            $0.top.equalTo(self.pwView.snp.top).offset(0)
            $0.leading.equalTo(self.pwView.snp.leading).offset(18)
            $0.trailing.equalTo(self.pwView.snp.trailing).offset(-18)
        }
        
        self.nickErrorLabel.snp.makeConstraints {
            $0.top.equalTo(self.nickNameTxt.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-45)
        }
        
        self.idErrorLabel.snp.makeConstraints {
            $0.top.equalTo(self.idTxt.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-45)
        }
        
        self.eyeBtn.snp.makeConstraints {
            $0.top.equalTo(self.pwView.snp.top).offset(8)
            $0.trailing.equalToSuperview().offset(-55)
            $0.width.equalTo(14)
            $0.height.equalTo(10)
        }
        
        self.signupBtn.snp.makeConstraints {
            $0.top.equalTo(self.pwTxt.snp.bottom).offset(136)
            $0.leading.lessThanOrEqualToSuperview().offset(45)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-45)
            $0.height.equalTo(46)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.signupBtn.snp.bottom).offset(20)
            $0.leading.lessThanOrEqualToSuperview().offset(117.5)
        }
        
        self.moveLoginBtn.snp.makeConstraints {
            $0.top.equalTo(self.signupBtn.snp.bottom).offset(20)
            $0.leading.equalTo(self.label.snp.trailing).offset(5)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-117.5)
            $0.height.equalTo(17)
        }
        
    }
    
    @objc
    private func changeBtn() {
        if eyeBool {
            eyeBtn.setImage(.init(systemName: "eye.slash"), for: .normal)
            pwTxt.isSecureTextEntry = false
            eyeBool.toggle()
        }
        else {
            eyeBtn.setImage(.init(systemName: "eye"), for: .normal)
            pwTxt.isSecureTextEntry = true
            eyeBool.toggle()
        }
    }
    
    private func setObj() {
        let aa = NSMutableAttributedString(string: moveLoginBtn.currentTitle!)
        let underLine = NSUnderlineStyle.thick.rawValue
        aa.addAttribute(NSMutableAttributedString.Key.underlineStyle,
                        value: underLine,
                        range: NSRange(location: 0, length: moveLoginBtn.currentTitle!.count))
        moveLoginBtn.setAttributedTitle(aa, for: .normal)
        
    }
    
    private func setBorder() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: idView.frame.size.height,
                              width: idView.frame.width,
                              height: 1)
        border.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
        idView.layer.addSublayer(border)
        
        let border1 = CALayer()
        border1.frame = CGRect(x: 0, y: pwView.frame.size.height,
                               width: pwView.frame.width,
                               height: 1)
        border1.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
        pwView.layer.addSublayer(border1)
        
        let border2 = CALayer()
        border2.frame = CGRect(x: 0, y: nickView.frame.size.height,
                               width: nickView.frame.width,
                               height: 1)
        border2.backgroundColor = UIColor.init(named: "placeholderColor")?.cgColor
        nickView.layer.addSublayer(border2)
    }
    
    @objc
    private func moveSignInViewController() {
        let VC = SignInViewController()
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


