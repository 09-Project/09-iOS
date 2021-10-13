//
//  ChangePasswordViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    
    private lazy var pwLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "기존 비밀번호"
        $0.textColor = .black
        $0.font = .init(name: fontMedium, size: 14)
    }   // 기존 비밀번호 라벨
    
    private lazy var pwTxtField = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = .init(named: "changePwColor")
        $0.isSecureTextEntry = true
        $0.font = .init(name: fontRegular, size: 14)
        $0.attributedPlaceholder = NSAttributedString(string: "     기존비밀번호를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }   // 기존 비밀번호 쓰는 텍스트필드
    
    private lazy var pwView = UIView().then {
        $0.backgroundColor = .white
    }   // 기존 비밀번호 뷰
    
    private lazy var newPwLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "새 비밀번호"
        $0.textColor = .black
        $0.font = .init(name: fontMedium, size: 14)
    }   // 새로운 비밀번호 라벨
    
    private lazy var newPwTxtField = UITextField().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 14)
        $0.isSecureTextEntry = true
        $0.textColor = .init(named: "changePwColor")
        $0.attributedPlaceholder = NSAttributedString(string: "새 비밀번호를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }   // 새로운 비밀번호 쓰는 텍스트필드
    
    private lazy var newPwView = UIView().then {
        $0.backgroundColor = .white
    }   // 새로운 비밀번호 뷰
    
    private lazy var checkPwLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontMedium, size: 14)
        $0.text = "비밀번호 확인"
        $0.textColor = .init(named: "changePwColor")
    }   // 비밀번호 확인 라벨
    
    private lazy var checkPwTxtField = UITextField().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 14)
        $0.isSecureTextEntry = true
        $0.textColor = .init(named: "changePwColor")
        $0.attributedPlaceholder = NSAttributedString(string: "변경한 비밀번호를 다시 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
    }   // 비밀번호 확인 텍스트필드
    
    private lazy var checkPwView = UIView().then {
        $0.backgroundColor = .white
    }   // 비밀번호 확인 뷰
    
    private lazy var errorLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .red
        $0.text = "비밀번호가 일치하지 않습니다."
    }   // 에러 라벨
    
    private lazy var changeBtn = UIButton().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("변경하기", for: .normal)
        $0.titleLabel!.font = .init(name: fontBold, size: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }   // 변경하기 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "비밀번호 변경"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    private func setup() {
        view.addSubview(pwLabel)
        view.addSubview(pwTxtField)
        view.addSubview(newPwLabel)
        view.addSubview(newPwTxtField)
        view.addSubview(checkPwLabel)
        view.addSubview(checkPwTxtField)
        view.addSubview(errorLabel)
        view.addSubview(changeBtn)
        
        self.pwLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(59)
            $0.leading.equalToSuperview().offset(40)
        }
        
        self.pwTxtField.snp.makeConstraints {
            $0.top.equalTo(self.pwLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(52)
        }
        
        self.newPwLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.pwTxtField.snp.bottom).offset(103)
            $0.leading.equalToSuperview().offset(40)
        }
        
        self.newPwTxtField.snp.makeConstraints {
            $0.top.equalTo(self.pwLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(52)
        }
        
        self.checkPwLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.newPwTxtField.snp.bottom).offset(103)
            $0.leading.equalToSuperview().offset(40)
        }
        
        self.checkPwTxtField.snp.makeConstraints {
            $0.top.equalTo(self.checkPwLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(52)
        }
        
        self.errorLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-40)
            $0.top.equalTo(self.checkPwTxtField.snp.top).offset(18)
        }
        
        self.changeBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-34)
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
            $0.height.equalTo(45)
        }
    }
    
}
