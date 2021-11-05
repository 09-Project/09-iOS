//
//  ChangeProfileViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeProfileViewController: UIViewController, UITextFieldDelegate {
    
    private let disposeBag = DisposeBag()
    
    private lazy var profileImg = UIImageView().then {
        $0.layer.cornerRadius = 5
    }

    private lazy var pencilBtn = UIButton(type: .system).then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.setImage(.init(systemName: "pencil"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var nickName = customView().then {
        $0.Label.text = "닉네임"
        $0.Label.font = .init(name: Font.fontMedium.rawValue, size: 14)
        $0.Txt.font = .init(name: Font.fontRegular.rawValue, size: 14)
    }
    
    private lazy var introduceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "자기소개"
        $0.font = .init(name: Font.fontMedium.rawValue, size: 14)
        $0.textColor = .black
    }
    
    private lazy var introduceTxtField = UITextView().then {
        $0.backgroundColor = .white
        $0.textColor = .init(named: "placeholderColor")
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
    }
    
    private lazy var changeBtn = UIButton(type: .system).then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var numLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 12)
        $0.textColor = .black
    }
    
    private lazy var numLabel2 = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 12)
        $0.textColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "프로필 수정"
        nickName.Txt.delegate = self
        
        nickName.Txt.rx.text.subscribe(onNext : { [unowned self] str in
            let num = str?.count
            numLabel.text = "(\(num!)/20)"
        }).disposed(by: disposeBag)
        
        introduceTxtField.rx.text.subscribe(onNext: { [unowned self] str in
            let num = str?.count
            numLabel2.text = "(\(num!)/200"
        }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let model = ChangeProfileViewModel()
//        let input = ChangeProfileViewModel.Input(name: nickName.Txt.rx.text.asDriver(), introduction: introduceTxtField.rx.text.asDriver(), profileURL: String(profileImg.rx.image), doneTap: changeBtn.rx.tap.asDriver())
        
//        let output = model.transform(input)
        
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    private func setup() {
        [profileImg, pencilBtn, nickName, introduceLabel, introduceTxtField, changeBtn,
         numLabel, numLabel2].forEach{view.addSubview($0)}
        
        profileImg.snp.makeConstraints {
            $0.top.equalToSuperview().inset(86)
            $0.leading.equalToSuperview().inset(39)
            $0.height.width.equalTo(88)
        }
        
        pencilBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(86)
            $0.leading.equalToSuperview().inset(39)
            $0.height.width.equalTo(88)
        }
        
        nickName.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).inset(60)
            $0.leading.trailing.equalToSuperview()
        }
        
        numLabel.snp.makeConstraints {
            $0.top.equalTo(nickName.View.snp.top).inset(16)
            $0.trailing.equalToSuperview().inset(-39)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(nickName.View.snp.bottom).inset(50)
            $0.leading.equalToSuperview().inset(39)
        }
        
        introduceTxtField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).inset(22)
            $0.leading.trailing.equalToSuperview()
        }
        
        numLabel2.snp.makeConstraints {
            $0.top.equalTo(introduceTxtField.snp.bottom).inset(-17)
            $0.trailing.equalToSuperview().inset(-39)
        }
        
        changeBtn.snp.makeConstraints {
            $0.top.equalTo(introduceTxtField.snp.bottom).inset(158)
            $0.height.equalTo(45)
            $0.leading.equalToSuperview().inset(39)
            $0.trailing.equalToSuperview().inset(-39)
        }
    }
}
