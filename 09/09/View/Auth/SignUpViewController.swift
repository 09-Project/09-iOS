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
    
    private var eyeBool = false
    private let disposebag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    private lazy var imgView = UIImageView().then {
        $0.image = UIImage(named: "logo&symoblImg")
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var joinusLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.text = "JOIN US"
        $0.font = UIFont.init(name: Font.fontBold.rawValue, size: 24)
    }
    
    private lazy var nickNameTxt = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.textAlignment = .left
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
        $0.attributedPlaceholder = NSAttributedString(string: "Nickname", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }
    
    private lazy var nickView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var idTxt = UITextField().then {
        $0.borderStyle = .none
        $0.textColor = .init(named: "mainColor")
        $0.textAlignment = .left
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
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
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
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
        $0.font = .init(name: Font.fontRegular.rawValue, size: 10)
    }
    
    private lazy var idErrorLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "중복된 아이디입니다."
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: Font.fontRegular.rawValue, size: 10)
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
        $0.titleLabel!.font = .init(name: Font.fontMedium.rawValue, size: 14)
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "이미 계정이 있으신가요?"
        $0.font = .init(name: Font.fontRegular.rawValue, size: 12)
        $0.textColor = .black
    }
    
    private lazy var moveLoginBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("로그인하기", for: .normal)
        $0.titleLabel!.font = .init(name: Font.fontRegular.rawValue, size: 12)
        $0.setTitleColor(.init(named: "mainColor"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.backgroundColor = .white
        idTxt.delegate = self
        pwTxt.delegate = self
        nickNameTxt.delegate = self
        idTxt.tag = 1
        pwTxt.tag = 2
        nickNameTxt.tag = 3
        eyeBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
            changeBtn()}).disposed(by: disposebag)
        moveLoginBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
            moveSignInViewController()}).disposed(by: disposebag)
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
           underLine(view: idView, txt: idTxt, color: "mainColor")
        case 2:
            underLine(view: pwView, txt: pwTxt, color: "mainColor")
        case 3:
           underLine(view: nickView, txt: nickNameTxt, color: "mainColor")
        default:
            print(Error.self)
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            underLine(view: idView, txt: idTxt, color: "placeholderColor")
        case 2:
           underLine(view: pwView, txt: pwTxt, color: "placeholderColor")
        case 3:
           underLine(view: nickView, txt: nickNameTxt, color: "placeholderColor")
        default:
            print(Error.self)
            
        }
    }
    
    private func bindViewModel() {
        let input = SignUpViewModel.Input(
            name: nickNameTxt.rx.text.orEmpty.asDriver(),
            username: idTxt.rx.text.orEmpty.asDriver(),
            password: pwTxt.rx.text.orEmpty.asDriver(),
            doneTap: signupBtn.rx.tap.asSignal())
        
        let output = viewModel.transform(input)
        output.isEnable.drive(signupBtn.rx.isEnabled).disposed(by: disposebag)
        output.isEnable.drive(onNext: {[unowned self] _ in
            Btn(signupBtn)
        })
        
        output.result.emit(
            onNext: {[unowned self] _ in self.idErrorLabel.isHidden = false
                nickErrorLabel.isHidden = false
            },
            onCompleted: {[unowned self] in
                let VC = SignInViewController()
                present(VC, animated: true, completion: nil)
        }).disposed(by: disposebag)
    }
    
    private func setUpView() {
        [imgView, joinusLabel, nickView, nickNameTxt, idView, idTxt, pwView, pwTxt, nickErrorLabel,
         idErrorLabel, eyeBtn, signupBtn, label, moveLoginBtn].forEach { self.view.addSubview($0)}
        
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
        underLine(view: nickView, txt: nil, color: "placeholderColor")
        
        underLine(view: idView, txt: nil, color: "placeholderColor")
        
        underLine(view: pwView, txt: nil, color: "placeholderColor")
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
extension SignUpViewController {
    private func Btn(_ sender: UIButton){
        if sender.isEnabled{
            sender.isEnabled = true
        }
        else {
            sender.isEnabled = false
        }
    }

}


