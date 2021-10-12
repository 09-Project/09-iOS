//
//  ChangeProfileViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit

class ChangeProfileViewController: UIViewController {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    
    private lazy var profileImg = UIImageView().then {
        $0.layer.cornerRadius = 10
    }
    
    private lazy var blackView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 10
        
    }

    private lazy var pencilBtn = UIButton().then {
        $0.backgroundColor = .none
        $0.setImage(.init(systemName: "pencil"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .init(name: fontMedium, size: 14)
        $0.textColor = .black
        $0.backgroundColor = .white
    }
    
    private lazy var nickNameTxtField = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = .init(named: "placeholderColor")
        $0.font = .init(name: fontRegular, size: 14)
    }
    
    private lazy var introduceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "자기소개"
        $0.font = .init(name: fontMedium, size: 14)
        $0.textColor = .black
    }
    
    private lazy var introduceTxtField = UITextView().then {
        $0.backgroundColor = .white
        $0.textColor = .init(named: "placeholderColor")
        $0.font = .init(name: fontRegular, size: 14)
    }
    
    private lazy var changeBtn = UIButton().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "프로필 수정"
    }
    
    override func viewDidLayoutSubviews() {
        <#code#>
    }
    
    private func setup() {
        
    }
}
