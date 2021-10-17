//
//  PostViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class AddPostViewController: UIViewController {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    private let disposebag = DisposeBag()
    
    private lazy var titleView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var titleTxt = UITextField().then {
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.font = .init(name: fontRegular, size: 13)
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var content = UITextField().then {
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "게시물 내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.font = .init(name: fontRegular, size: 13)
    }
    
    private lazy var photoLabel = UILabel().then {
        $0.text = "사진"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .black
    }

    private lazy var photo = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .init(named: "searchColor")
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "*이미지는 상품등록 시\n 정사각형으로\n 잘려서 등록됩니다."
        $0.font = .init(name: fontRegular, size: 11)
        $0.textColor = .black
        $0.numberOfLines = 3
    }
    
    private lazy var buyLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "공동구매"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .black
    }
    
    private lazy var buyBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "circle"), for: .normal)
        $0.tintColor = .init(named: "circleColor")
    }
    
    private lazy var giveLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "무료나눔"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .black
    }
    
    private lazy var giveBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "circle"), for: .normal)
        $0.tintColor = .init(named: "circleColor")
    }
    
    private lazy var price = customView().then {
        $0.Label.text = "가격"
        $0.label.isHidden = false
    }
    
    private lazy var area = customView().then {
        $0.Label.text = "거래지역"
        $0.Txt.attributedPlaceholder = NSAttributedString(
            string: "거래지역을 입력해주세요(ex.대덕소프트웨어마이스터고등학교)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.label.isHidden = true
    }
    
    private lazy var openChat = customView().then {
        $0.Label.text = "오픈채팅"
        $0.Txt.attributedPlaceholder = NSAttributedString(
            string: "오픈채팅 링크를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.label.isHidden = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [price, area, openChat]).then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "게시물 작성"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okBtn))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    @objc
    private func okBtn() {
        
    }
    
    private func setup() {
        line(view: titleView)
        line(view: contentView)
        
        [titleView, titleTxt, contentView, content, photoLabel, photo, label, buyLabel, buyBtn,
         giveLabel, giveBtn, stackView].forEach{ self.view.addSubview($0) }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        
        titleTxt.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(34)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(135)
        }
        
        content.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(34)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(32)
            $0.leading.equalTo(34)
        }
        
        photo.snp.makeConstraints {
            $0.top.equalTo(self.photoLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(80)
            $0.leading.equalToSuperview().offset(34)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.top).offset(29)
            $0.leading.equalTo(self.photo.snp.trailing).offset(20)
        }
        
        buyLabel.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(34)
        }
        
        buyBtn.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(43)
            $0.leading.equalTo(self.buyLabel.snp.trailing).offset(6)
            $0.height.width.equalTo(15)
        }
        
        giveLabel.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(40)
            $0.leading.equalTo(self.buyBtn.snp.trailing).offset(61)
        }
        
        giveBtn.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(43)
            $0.leading.equalTo(self.giveLabel.snp.trailing).offset(6)
            $0.width.height.equalTo(15)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.buyLabel.snp.bottom).offset(43)
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
        }
    }

}
