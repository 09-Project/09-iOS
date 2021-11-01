//
//  ChangePasswordViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    private let disposebag = DisposeBag()
    private let viewModel = ChangePwViewModel()
    
    
    private lazy var pw = customView().then {
        $0.Label.text = "기존 비밀번호"
        $0.label.isHidden = true
        $0.Txt.attributedPlaceholder = NSAttributedString(string: "기존비밀번호를 입력해주세요",
                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")!])
    }
    
    private lazy var newPW = customView().then {
        $0.Label.text = "새 비밀번호"
        $0.Txt.attributedPlaceholder = NSAttributedString(string: "새 비밀번호를 입력해주세요",
                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")!])
        $0.label.isHidden = true
    }
    
    private lazy var checkPW = customView().then {
        $0.Label.text = "비밀번호 확인"
        $0.Txt.attributedPlaceholder = NSAttributedString(string: "변경한 비밀번호를 다시 입력해주세요",
                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")!])
        $0.label.isHidden = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [pw, newPW, checkPW]).then {
        $0.axis = .vertical
        $0.spacing = 40
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private lazy var errorLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .red
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.font = .init(name: Font.fontRegular.rawValue, size: 11)
    }   // 에러 라벨
    
    private lazy var changeBtn = UIButton().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("변경하기", for: .normal)
        $0.titleLabel!.font = .init(name: Font.fontBold.rawValue, size: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
    }   // 변경하기 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "비밀번호 변경"
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        errorLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        error()
    }
    
    private func bindViewModel() {
        let input = ChangePwViewModel.Input(
            password: pw.Txt.rx.text.orEmpty.asDriver(),
            new_password: newPW.Txt.rx.text.orEmpty.asDriver(),
            check_password: checkPW.Txt.rx.text.orEmpty.asDriver(),
            doneTap: changeBtn.rx.tap.asSignal())
        
        let output = viewModel.transform(input)
        
        output.isEnable.drive(changeBtn.rx.isEnabled).disposed(by: disposebag)
        output.isEnable.drive(onNext: {[unowned self] bool in
            changeBtn.isEnabled = bool
        }).disposed(by: disposebag)
        
        output.result.emit(onNext: {[unowned self] bool in
            errorLabel.isHidden = bool},
                           onCompleted: {[unowned self] in
            let VC = MyPageViewController()
            present(VC, animated: true, completion: nil)
        }).disposed(by: disposebag)
    }
    
    private func error() {
        if newPW.Txt.text == checkPW.Txt.text {
            errorLabel.isHidden = true
        }
        
        else {
            errorLabel.isHidden = false
        }
    }
    
    private func setup() {
        [stackView, errorLabel, changeBtn].forEach { self.view.addSubview($0)}
        
        self.stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        
        self.errorLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-34)
            $0.centerY.equalTo(self.checkPW.Txt.snp.centerY)
        }
        
        self.changeBtn.snp.makeConstraints {
            $0.bottom.greaterThanOrEqualToSuperview().offset(-34)
            $0.leading.equalToSuperview().offset(34)
            $0.trailing.equalToSuperview().offset(-34)
            $0.top.lessThanOrEqualTo(self.stackView.snp.bottom).offset(247)
            $0.height.equalTo(45)
        }
    }
    
}
