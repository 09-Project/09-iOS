//
//  MyPageViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import Tabman

class MyPageViewController: UIViewController {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    
    private lazy var profileImg = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.font = .init(name: fontBold, size: 16)
    }
    
    private lazy var gearBtn = UIButton().then {
        $0.setImage(.init(named: "톱니바퀴.PNG.png"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var introduceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 13)
        $0.textColor = .init(named: "myIncludeTxtColor")
    }
    
    // 상품
    private lazy var productView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var productNum = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: fontBold, size: 18)
    }
    
    private lazy var productLabel = UILabel().then {
        $0.backgroundColor = .none
        $0.text = "상품"
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: fontMedium, size: 13)
    }
    
    //찜한 상품
    private lazy var prizeView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var prizeNum = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: fontBold, size: 18)
        $0.textColor = .black
    }
    
    private lazy var prizeLabel = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .init(named: "mainColor")
        $0.text = "찜한 상품"
    }
    
    // 받은 찜
    private lazy var receiveView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var receiveNum = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: fontBold, size: 18)
        $0.textColor = .black
    }
    
    private lazy var receiveLabel = UILabel().then {
        $0.backgroundColor = .none
        $0.text = "받은 찜"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .init(named: "mainColor")
    }
    
    // 거래 내역
    private lazy var transactionView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var transactionNum = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: fontBold, size: 18)
        $0.textColor = .black
    }
    
    private lazy var transactionLabel = UILabel().then {
        $0.backgroundColor = .none
        $0.text = "거래 내역"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .init(named: "mainColor")
    }
    
    
    private lazy var collectionView = UICollectionView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setNavigationItem()
    }
    
    
    
    private func setNavigationItem(){
        navigationItem.title = "마이페이지"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(rightBarBtnDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc
    private func rightBarBtnDidTap() {
        
    }
    private func setupView() {
        view.addSubview(profileImg)
        view.addSubview(nameLabel)
        view.addSubview(gearBtn)
        view.addSubview(introduceLabel)
        view.addSubview(productView)
        view.addSubview(productNum)
        view.addSubview(productLabel)
        view.addSubview(prizeView)
        view.addSubview(prizeNum)
        view.addSubview(prizeLabel)
        view.addSubview(receiveView)
        view.addSubview(receiveNum)
        view.addSubview(receiveLabel)
        view.addSubview(transactionView)
        view.addSubview(transactionNum)
        view.addSubview(transactionLabel)
        view.addSubview(collectionView)
        
        self.profileImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.lessThanOrEqualToSuperview().offset(40)
            $0.width.height.equalTo(80)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalTo(self.profileImg.snp.trailing).offset(23)
        }
        
        self.gearBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalTo(self.nameLabel.snp.trailing).offset(7)
            $0.height.width.equalTo(14)
        }
        
        self.introduceLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.profileImg.snp.trailing).offset(23)
        }
        
        self.productView.snp.makeConstraints {
            $0.top.equalTo(self.profileImg.snp.bottom).offset(19)
            $0.leading.lessThanOrEqualToSuperview().offset(47)
            $0.width.equalTo(48)
            $0.height.equalTo(76)
        }
        
        self.productNum.snp.makeConstraints {
            $0.top.equalTo(self.productView.snp.top).offset(12)
            $0.leading.lessThanOrEqualTo(self.productView.snp.leading).offset(18)
            $0.trailing.greaterThanOrEqualTo(self.productView.snp.trailing).offset(-19)
        }
        
        self.productLabel.snp.makeConstraints {
            $0.top.equalTo(self.productNum.snp.bottom).offset(13)
            $0.leading.lessThanOrEqualTo(self.productView.snp.leading).offset(12)
            $0.trailing.greaterThanOrEqualTo(self.productView.snp.leading).offset(-12)
        }
        
        self.prizeView.snp.makeConstraints {
            $0.top.equalTo(self.profileImg.snp.bottom).offset(19)
            $0.leading.lessThanOrEqualTo(self.productView.snp.trailing).offset(20)
            $0.width.equalTo(75)
            $0.height.equalTo(76)
        }
        
        self.prizeNum.snp.makeConstraints {
            $0.top.equalTo(self.prizeView.snp.top).offset(12)
            $0.leading.lessThanOrEqualTo(self.prizeView.snp.leading).offset(27)
            $0.trailing.greaterThanOrEqualTo(self.prizeView.snp.trailing).offset(-27)
        }
        
        self.prizeLabel.snp.makeConstraints {
            $0.top.equalTo(self.prizeNum.snp.bottom).offset(13)
            $0.leading.lessThanOrEqualTo(self.prizeView.snp.leading).offset(11)
            $0.trailing.greaterThanOrEqualTo(self.prizeView.snp.trailing).offset(-11)
        }
        
        self.receiveView.snp.makeConstraints {
            $0.top.equalTo(self.profileImg.snp.bottom).offset(19)
            $0.leading.lessThanOrEqualTo(self.prizeView.snp.trailing).offset(20)
            $0.width.equalTo(63)
            $0.height.equalTo(76)
        }
        
        self.receiveNum.snp.makeConstraints {
            $0.top.equalTo(self.receiveView.snp.top).offset(12)
            $0.leading.lessThanOrEqualTo(self.receiveView.snp.leading).offset(21)
            $0.trailing.greaterThanOrEqualTo(self.receiveView.snp.trailing).offset(-21)
        }
        
        self.receiveLabel.snp.makeConstraints {
            $0.top.equalTo(self.receiveNum.snp.bottom).offset(13)
            $0.leading.lessThanOrEqualTo(self.receiveView.snp.leading).offset(11)
            $0.trailing.greaterThanOrEqualTo(self.receiveView.snp.trailing).offset(-11)
        }
        
        self.transactionView.snp.makeConstraints {
            $0.top.equalTo(self.profileImg.snp.bottom).offset(19)
            $0.leading.lessThanOrEqualTo(self.receiveView.snp.trailing).offset(20)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-47)
            $0.width.equalTo(74)
            $0.height.equalTo(76)
        }
        
        self.transactionNum.snp.makeConstraints {
            $0.top.equalTo(self.transactionView.snp.top).offset(12)
            $0.leading.lessThanOrEqualTo(self.transactionView.snp.leading).offset(21)
            $0.trailing.greaterThanOrEqualTo(self.transactionView.snp.trailing).offset(-21)
        }
        
        self.transactionLabel.snp.makeConstraints {
            $0.top.equalTo(self.transactionNum.snp.bottom).offset(13)
            $0.leading.lessThanOrEqualTo(self.transactionView.snp.leading).offset(12)
            $0.trailing.greaterThanOrEqualTo(self.transactionView.snp.trailing).offset(-12)
        }
        
    }

}
