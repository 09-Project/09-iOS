//
//  MainViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/07.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

class MainViewController: UIViewController {
    
    private let sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController())
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"

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
    
    private lazy var mainCollectionView = UICollectionView().then {
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let img = UIImage(named: "symbol&logo_09")
        navigationItem.titleView = UIImageView(image: img)
        sideMenu.leftSide = false
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIImage.init(systemName: "line.horizontal.3"), target: self, action: #selector(sideMenuDidTap))
        mainCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 73, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "symbol&logo_09")
        imageView.image = image
        navigationItem.titleView = imageView
        setupView()
    }
    
    private func setupView() {
        view.addSubview(searchField)
        view.addSubview(searchBtn)
        view.addSubview(bennerImgView)
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(pageFrontBtn)
        view.addSubview(pageBackBTn)
        view.addSubview(mainCollectionView)
        
        self.searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        self.searchBtn.snp.makeConstraints{
            $0.top.equalTo(self.searchField.snp.top).offset(7)
            $0.trailing.equalTo(self.searchField.snp.trailing).offset(-12)
            $0.height.width.equalTo(11)
        }
        
        self.bennerImgView.snp.makeConstraints {
            $0.top.equalTo(self.searchField.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().offset(0)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.bennerImgView.snp.top).offset(116)
            $0.leading.equalToSuperview().offset(23)
        }
        
        self.label2.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(23)
        }
        
        self.label3.snp.makeConstraints {
            $0.top.equalTo(self.bennerImgView.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(36)
        }
        
        self.pageFrontBtn.snp.makeConstraints {
            $0.top.equalTo(self.bennerImgView.snp.bottom).offset(31)
            $0.trailing.equalToSuperview().offset(-39)
        }
        
        self.pageBackBTn.snp.makeConstraints {
            $0.top.equalTo(self.bennerImgView.snp.bottom).offset(31)
            $0.trailing.equalTo(self.pageFrontBtn.snp.leading).offset(-12)
        }
        
        self.mainCollectionView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.bennerImgView.snp.bottom).offset(62)
            $0.leading.lessThanOrEqualToSuperview().offset(16)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(0)
        }
    }
    @objc
    private func sideMenuDidTap() {
        present(sideMenu, animated: true, completion: nil)
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.frame.width / 2 - 8
            let size = CGSize(width: width, height: width)
        
            return size
        }

    
}
