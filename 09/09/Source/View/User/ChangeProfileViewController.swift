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
    private let img = PublishRelay<Data>()
    private let picker = UIImagePickerController()
    let profileImage = UIImage.init(named: "ProfileImg")
    let model = ChangeProfileViewModel()
    
    private lazy var profile = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.image = .init(named: "ProfileImg")
    }
    
    private lazy var pencilBtn = UIButton(type: .system).then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.setImage(.init(systemName: "pencil"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var nickName = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var nickLabel = UILabel().then {
        $0.font = .init(name: Font.fontMedium.rawValue, size: 14)
        $0.text = "닉네임"
        $0.textColor = .black
    }
    
    private lazy var nickTxt = UITextField().then {
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
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
        bindViewModel()
        view.backgroundColor = .white
        navigationItem.title = "프로필 수정"
        nickTxt.delegate = self
        picker.delegate = self
        
        pencilBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            openLibary()
        }).disposed(by: disposeBag)
        
        nickTxt.rx.text.subscribe(onNext : { [unowned self] str in
            let num = str?.count
            numLabel.text = "(\(num!)/20)"
        }).disposed(by: disposeBag)
        
        introduceTxtField.rx.text.subscribe(onNext: { [unowned self] str in
            let num = str?.count
            numLabel2.text = "(\(num!)/200)"
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        img.accept(profileImage!.jpegData(compressionQuality: 0.8)!)
        introduceTxtField.layer.addBorder([.top, .bottom],
                                          color: .init(named: "placeholderColor")!, width: 0.5)
        nickName.layer.addBorder([.bottom, .top],
                                 color: .init(named: "placeholderColor")!, width: 0.5)
    }
    
    private func bindViewModel() {
        let input = ChangeProfileViewModel.Input(
            name: nickTxt.rx.text.orEmpty.asDriver(),
            introduction: introduceTxtField.rx.text.orEmpty.asDriver(),
            profileURL: img.asDriver(onErrorJustReturn: (profileImage?.jpegData(compressionQuality: 0.8))!),
            doneTap: changeBtn.rx.tap.asSignal())
        
        let output = model.transform(input)
        
        output.result.subscribe(onNext: { [unowned self] bool in
            if bool {
                okAlert(title: "프로필을 바꾸시는데 성공하셨습니다.", action: { ACTION in
                    navigationController?.popViewController(animated: true)
                })
            }
            else {
                okAlert(title: "프로필을 바꾸시는데 실패하셨습니다.", action: { ACTION in
                    navigationController?.popViewController(animated: true)
                })
            }
        }).disposed(by: disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setup() {
        [profile, pencilBtn, nickName, nickTxt, nickLabel, introduceLabel, introduceTxtField,
         changeBtn, numLabel, numLabel2].forEach{view.addSubview($0)}
        
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(39)
            $0.height.width.equalTo(88)
        }
        
        pencilBtn.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(profile)
        }
        
        nickName.snp.makeConstraints {
            $0.top.equalTo(nickLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        numLabel.snp.makeConstraints {
            $0.centerY.equalTo(nickTxt)
            $0.trailing.equalToSuperview().offset(-39)
        }
        
        nickLabel.snp.makeConstraints {
            $0.top.equalTo(pencilBtn.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(39)
        }
        
        nickTxt.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.top).offset(15)
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(nickTxt.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(39)
        }
        
        introduceTxtField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        numLabel2.snp.makeConstraints {
            $0.bottom.equalTo(introduceTxtField.snp.bottom).offset(-17)
            $0.trailing.equalToSuperview().offset(-39)
        }
        
        changeBtn.snp.makeConstraints {
            $0.top.equalTo(introduceTxtField.snp.bottom).offset(158)
            $0.height.equalTo(45)
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
        }
    }
}

extension ChangeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profile.image = image
            img.accept(image.jpegData(compressionQuality: 0.8)!)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
