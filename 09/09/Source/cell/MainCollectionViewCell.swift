//
//  MainCollectionViewCell.swift
//  09
//
//  Created by 김기영 on 2021/10/07.
//

import UIKit
import RxSwift

class MainCollectionViewCell: UICollectionViewCell {
    
    let disposebag = DisposeBag()
    
    lazy var imgView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = .init(name: Font.fontMedium.rawValue, size: 14)
        $0.textAlignment = .left
    }
    
    lazy var locationLabel = UILabel().then {
        $0.font = .init(name: Font.fontRegular.rawValue, size: 11)
    }
    
    lazy var label = UILabel().then {
        $0.text = "공동구매"
        $0.backgroundColor = .init(named: "searchColor")
        $0.font = .init(name: Font.fontRegular.rawValue, size: 11)
    }
    
    lazy var pinImg = UIImageView().then {
        $0.image = .init(named: "pinImg")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var heartBtn = UIButton(type: .system).then {
        $0.tintColor = .init(named: "heartColor")
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = .init(name: Font.fontBold.rawValue, size: 13)
    }
    
    lazy var endView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 0
    }
    
    lazy var endLabel = UILabel().then {
        $0.backgroundColor = .none
        $0.font = .init(name: Font.fontBold.rawValue, size: 16)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [endView, endLabel].forEach{$0.isHidden = true}
        label.clipsToBounds = true
        label.layer.cornerRadius = 2
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        [imgView, titleLabel, locationLabel, label, pinImg,
         heartBtn, priceLabel, endView, endLabel].forEach{self.addSubview($0)}
        
        self.imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.height.lessThanOrEqualTo(160)
        }
        
        self.heartBtn.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.top).offset(8)
            $0.trailing.equalToSuperview().offset(-15)
            $0.width.equalTo(14)
            $0.height.equalTo(12)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(20)
        }
        
        self.pinImg.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(12)
            $0.width.equalTo(8)
        }
        
        self.locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(pinImg)
            $0.leading.equalTo(self.pinImg.snp.trailing).offset(3)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.locationLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview()
        }
        
        self.priceLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        self.endView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        self.endLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.center.equalTo(self.endView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
