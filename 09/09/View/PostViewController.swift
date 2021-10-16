//
//  PostViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/16.
//

import UIKit

class PostViewController: UIViewController {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    
    private lazy var backBtn = UIButton().then {
        $0.backgroundColor = .none
        $0.setImage(.init(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var imgView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var profileImg = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var name = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 14)
        $0.textColor = .black
    }
    
    private lazy var profileBtn = UIButton().then {
        $0.backgroundColor = .none
        $0.setImage(.init(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .init(named: "Color")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 16)
        $0.textColor = .black
    }
    
    private lazy var priceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontBold, size: 22)
        $0.textColor = .black
    }
    
    private lazy var wonLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "원"
        $0.textColor = .black
        $0.font = .init(name: fontRegular, size: 10)
    }
    
    private lazy var pinImg = UIImageView().then {
        $0.image = .init(named: "pinImg")
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var areaLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 12)
        $0.textColor = .black
    }
    
    private lazy var buyBtn = UIButton().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.setTitle("공동구매", for: .normal)
        $0.layer.cornerRadius = 3
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel!.font = .init(name: fontBold, size: 11)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    private func setup() {
        
    }
}
