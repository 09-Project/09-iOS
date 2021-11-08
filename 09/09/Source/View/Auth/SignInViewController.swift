//
//  SignUpViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/02.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private var eyeBtnBool: Bool = false
    private var checkBtnBool: Bool = false
    private var disposeBag = DisposeBag()
    private let viewModel = SignInModel()
    
    
    private lazy var imgView = UIImageView().then {
        $0.image = UIImage(named: "logo&symbolImg")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
    }   // 로고 이미지
    
    private lazy var loginLabel = UILabel().then {
        $0.text = "LOG IN"
        $0.font = UIFont(name: Font.fontBold.rawValue, size: 24)
        $0.textColor = .black
        $0.backgroundColor = .white
    }   // 로그인 라벨
    
    private lazy var idTxt = UITextField().then {
        $0.borderStyle = .none
        $0.textAlignment = .left
        $0.backgroundColor = .white
        $0.font = UIFont(name: Font.fontRegular.rawValue, size: 14)
        $0.textColor = UIColor.init(named: "placeholderColor")
        $0.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")!])
    }   // 아이디
    
    private lazy var idView = UIView().then {
        $0.backgroundColor = .white
    }   // 아이디 뷰
    
    private lazy var pwTxt = UITextField().then {
        $0.borderStyle = .none
        $0.textAlignment = .left
        $0.backgroundColor = .white
        $0.textColor = UIColor.init(named: "placeholderColor")
        $0.font = UIFont(name: Font.fontRegular.rawValue, size: 14)
        $0.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")!])
    }   // 비밀번호
    
    private lazy var pwView = UIView().then {
        $0.backgroundColor = .white
    }   // 비밀번호 뷰
    
    private lazy var errorLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "아이디 또는 비밀번호가 일치하지 않습니다."
        $0.font = .init(name: Font.fontRegular.rawValue, size: 10)
        $0.textColor = .init(named: "mainColor")
    }   // 에러 라벨
    
    private lazy var eyeBtn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        $0.tintColor = .init(named: "placeholderColor")
    }   // 눈 버튼
    
    private lazy var checkBtn = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = .init(named: "idCheckColor")
    }   // 아이디 저장 버튼
    
    private lazy var idCheckLabel = UILabel().then {
        $0.font = UIFont(name: Font.fontMedium.rawValue, size: 10)
        $0.text = "아이디 저장"
        $0.textColor = .black
        $0.backgroundColor = .white
    }   // 아이디 저장 라벨
    
    private lazy var loginBtn = UIButton(type: .system).then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("LOGIN", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Font.fontMedium.rawValue, size: 14)
        $0.layer.cornerRadius = 10
    }   // 로그인 버튼
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "계정이 없으신가요?"
        $0.textColor = .black
        $0.font = UIFont(name: Font.fontRegular.rawValue, size: 12)
    }   // 회원가입 안내 라벨
    
    private lazy var moveSignupBtn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.setTitle("회원가입하기", for: .normal)
        $0.setTitleColor(.init(named: "mainColor"), for: .normal)
        $0.titleLabel!.font = UIFont(name: Font.fontRegular.rawValue, size: 12)
    }   // 회원가입 이동 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindViewModel()
        // Do any additional setup after loading the view.
        setBtn()
        pwTxt.text! = ""
        idTxt.delegate = self
        pwTxt.delegate = self
        idTxt.tag = 1
        pwTxt.tag = 2
        moveSignupBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
           presentVC(SignUpViewController())
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.string(forKey: "id")
        idTxt.text! = UserDefaults.standard.string(forKey: "id") ?? ""
        setBorder()
        checkBtnBool = UserDefaults.standard.bool(forKey: "bool")
        changeCheckBtnImg()
    }
    
    override func viewDidLayoutSubviews() {
        idCheckLabel.sizeToFit()
        setObj()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            idView.layer.addBorder([.bottom], color: UIColor.init(named: "mainColor")!, width: 1)
            idTxt.textColor = .init(named: "mainColor")
        case 2:
            
            pwView.layer.addBorder([.bottom], color: UIColor.init(named: "mainColor")!, width: 1)
            pwTxt.textColor = .init(named: "mainColor")
        default:
            print(Error.self)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            idView.layer.addBorder([.bottom], color: UIColor.init(named: "placeholderColor")!, width: 1)
            idTxt.textColor = .init(named: "placeholderColor")
        case 2:
            pwView.layer.addBorder([.bottom], color: UIColor.init(named: "placeholderColor")!, width: 1)
            pwTxt.textColor = .init(named: "placeholderColor")
        default:
            print(Error.self)
            
        }
    }
    
    private func bindViewModel() {
        let input = SignInModel.Input(
            username: idTxt.rx.text.orEmpty.asDriver(),
            password: pwTxt.rx.text.orEmpty.asDriver(),
            doneTap: loginBtn.rx.tap.asSignal())
        
        let output = viewModel.transform(input)
        output.isEnable.drive(loginBtn.rx.isEnabled).disposed(by: disposeBag)
        
        output.result.subscribe(onNext: { [unowned self] bool in
            if bool {
                self.presentVC(MainViewController())
            }
            else {
                errorLabel.isHidden = false
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        [imgView, loginLabel, idView, idTxt, pwView, pwTxt, eyeBtn, checkBtn, idCheckLabel,
         loginBtn, label, moveSignupBtn].forEach { self.view.addSubview($0)}
        
        self.imgView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaInsets).offset(52)
            $0.centerX.equalTo(self.view)
            $0.height.equalTo(28)
            $0.width.equalTo(73)
        }
        
        self.loginLabel.snp.makeConstraints {
            $0.top.equalTo(self.imgView.snp.bottom).offset(80)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(85)
        }
        
        self.idTxt.snp.makeConstraints {
            $0.top.equalTo(self.idView.snp.top).offset(0)
            $0.leading.equalTo(self.idView.snp.leading).offset(18)
            $0.trailing.equalTo(self.idView.snp.trailing).offset(-18)
        }
        
        self.idView.snp.makeConstraints {
            $0.top.equalTo(self.loginLabel.snp.bottom).offset(50)
            $0.leading.lessThanOrEqualToSuperview().offset(45)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-45)
            $0.height.equalTo(28)
        }
        
        self.pwTxt.snp.makeConstraints {
            $0.top.equalTo(self.pwView.snp.top).offset(0)
            $0.leading.equalTo(self.pwView.snp.leading).offset(18)
            $0.trailing.equalTo(self.pwView.snp.trailing).offset(-18)
        }
        
        self.pwView.snp.makeConstraints {
            $0.top.equalTo(self.idView.snp.bottom).offset(70)
            $0.leading.lessThanOrEqualToSuperview().offset(45)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-45)
            $0.height.equalTo(28)
        }
        
        self.eyeBtn.snp.makeConstraints {
            $0.top.equalTo(self.pwView.snp.top).offset(8)
            $0.trailing.equalTo(self.pwView.snp.trailing).offset(-8)
            $0.width.equalTo(14)
            $0.height.equalTo(10)
        }
        
        self.checkBtn.snp.makeConstraints {
            $0.top.equalTo(self.pwTxt.snp.bottom).offset(21.5)
            $0.leading.equalToSuperview().offset(45)
            $0.height.width.equalTo(12)
        }
        
        self.idCheckLabel.snp.makeConstraints {
            $0.top.equalTo(self.pwTxt.snp.bottom).offset(20)
            $0.leading.equalTo(self.checkBtn.snp.trailing).offset(5)
        }
        
        self.loginBtn.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.pwTxt.snp.bottom).offset(230)
            $0.leading.lessThanOrEqualToSuperview().offset(39)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-39)
            $0.height.equalTo(46)
        }
        
        self.label.snp.makeConstraints {
            $0.leading.lessThanOrEqualToSuperview().offset(120)
            $0.top.equalTo(self.loginBtn.snp.bottom).offset(20)
        }
        
        self.moveSignupBtn.snp.makeConstraints {
            $0.leading.equalTo(self.label.snp.trailing).offset(5)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-120)
            $0.top.equalTo(self.loginBtn.snp.bottom).offset(12.5)
        }
    }
    
    private func setBorder() {
        idView.layer.addBorder([.bottom], color: UIColor.init(named: "placeholderColor")!, width: 1)
        pwView.layer.addBorder([.bottom], color: UIColor.init(named: "placeholderColor")!, width: 1)
    }
    
    private func changeEyeBtnImg() {
        if eyeBtnBool {
            pwTxt.isSecureTextEntry = false
            eyeBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeBtnBool.toggle()
        }
        else {
            pwTxt.isSecureTextEntry = true
            eyeBtn.setImage(UIImage(systemName: "eye"), for: .normal)
            eyeBtnBool.toggle()
        }
    }
    
    private func changeCheckBtnImg() {
        if checkBtnBool {
            checkBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            UserDefaults.standard.set(nil, forKey: "id")
            UserDefaults.standard.set(true, forKey: "bool")
            checkBtnBool.toggle()
        }
        
        else {
            checkBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            UserDefaults.standard.set(idTxt.text!, forKey: "id")
            UserDefaults.standard.set(false, forKey: "bool")
            checkBtnBool.toggle()
        }
    }
    
    
    
}

private extension SignInViewController {
    
    private func setBtn() {
        self.eyeBtn.rx.tap.subscribe(onNext: {[unowned self] _ in changeEyeBtnImg()})
            .disposed(by: disposeBag)
        self.checkBtn.rx.tap.subscribe(onNext: {[unowned self] _ in changeCheckBtnImg()})
            .disposed(by: disposeBag)
    }
    private func setObj() {
        let aa = NSMutableAttributedString(string: moveSignupBtn.currentTitle!)
        let underLine = NSUnderlineStyle.thick.rawValue
        aa.addAttribute(NSMutableAttributedString.Key.underlineStyle,
                        value: underLine,
                        range: NSRange(location: 0, length: moveSignupBtn.currentTitle!.count))
        moveSignupBtn.setAttributedTitle(aa, for: .normal)
    }
}
