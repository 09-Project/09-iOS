//
//  MainViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/07.
//

import UIKit

class MainViewController: UIViewController {
    
    private let img = UIImage(named: "symbol&logo_09")
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    
    private lazy var imgView = UIImageView().then {
        $0.image = img
        $0.contentMode = .scaleAspectFit
    }
    private lazy var searchField = UITextField().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.textAlignment = .left
        $0.font = .init(name: fontRegular, size: 13)
    }
    
    private lazy var searchBtn = UIButton().then {
        $0.setImage(.init(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var bennerImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .none
        $0.text = "공동구매부터 무료나눔까지"
        $0.textColor = .white
        $0.font = .init(name: fontBold, size: 22)
    }
    
    private lazy var label2 = UILabel().then {
        $0.backgroundColor = .none
        $0.text = "09"
        $0.textColor = .white
        $0.font = .init(name: fontRegular, size: 17)
    }
    
    private lazy var label3 = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "추천 상품"
        $0.font = .init(name: fontBold, size: 20)
    }
    
    private lazy var pageBackBTn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "arrowtriangle.backward.square"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }

    private lazy var pageFrontBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "arrowtriangle.forward.square"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    private func setupView() {
        
    }
    
}
