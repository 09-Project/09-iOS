//
//  MainCollectionViewCell.swift
//  09
//
//  Created by 김기영 on 2021/10/07.
//

import UIKit
import RxSwift

class MainCollectionViewCell: UICollectionViewCell {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    
    lazy var imgView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontMedium, size: 14)
    }
    
    lazy var locationLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 11)
    }
    
    lazy var label = UILabel().then {
        $0.text = "공동구매"
        $0.backgroundColor = .init(named: "searchColor")
        $0.font = .init(name: fontRegular, size: 11)
    }
    
    lazy var pinImg = UIImageView().then {
        $0.image = .init(named: "pin")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
    }
    
    lazy var heartBtn = UIButton().then {
        $0.setImage(.init(systemName: "heart"), for: .normal)
        $0.tintColor = .init(named: "hearColor")
    }
    
    lazy var priceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontBold, size: 13)
    }
    
    lazy var endView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 0
    }
    
    lazy var endLabel = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: fontBold, size: 16)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(locationLabel)
        addSubview(label)
        addSubview(pinImg)
        addSubview(heartBtn)
        addSubview(priceLabel)
        addSubview(endView)
        addSubview(endLabel)
        
        self.imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        self.heartBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.width.equalTo(14)
            $0.height.equalTo(12)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.imgView.snp.bottom).offset(8)
            $0.leading.lessThanOrEqualToSuperview().offset(8)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-8)
        }
        
        self.pinImg.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(12)
            $0.width.equalTo(8)
        }
        
        self.locationLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(7)
            $0.leading.equalTo(self.pinImg.snp.trailing).offset(4)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(8)
        }
        
        self.priceLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(self.label.snp.trailing).offset(41)
        }
        
        self.endView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        self.endLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.center.equalTo(self.endLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
