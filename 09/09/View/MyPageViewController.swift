//
//  MyPageViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit

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
        $0.setImage(.init(systemName: "gear"), for: .normal)
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
    
    private lazy var btn1 = UIButton().then {
        $0.backgroundColor = .white
        $0.titleLabel!.font = .init(name: fontMedium, size: 15)
        $0.setTitle("상품", for: .normal)
    }
    
    private lazy var btn2 = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("찜한 상품", for: .normal)
        $0.titleLabel!.font = .init(name: fontMedium, size: 15)
    }
    
    private lazy var btn3 = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("거래 내역", for: .normal)
        $0.titleLabel!.font = .init(name: fontMedium, size: 15)
    }
    
    private lazy var collectionView = UICollectionView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setNavigationItem()
    }
    
    private func setupView() {
        view.addSubview(profileImg)
    }
    
    private func setNavigationItem(){
        navigationItem.title = "마이페이지"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(rightBarBtnDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    @objc
    private func rightBarBtnDidTap() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
