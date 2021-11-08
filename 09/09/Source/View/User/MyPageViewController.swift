//
//  MyPageViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
    
    let identfier = "cell"
    var memberID = Int()
    
    private let disposebag = DisposeBag()
    private let viewmodel = MyPageViewModel()
    private var postDidTap = true
    private var likePostDidTap = true
    private var detailDidTap = true
    
    private let getProfileData = BehaviorRelay<Void>(value: ())
    
    private lazy var profileImg = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.image = .init(named: "ProfileImg")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.font = .init(name: Font.fontBold.rawValue, size: 16)
    }
    
    private lazy var gearBtn = UIButton(type: .system).then {
        $0.setImage(.init(named: "gearImg"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var introduceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 13)
        $0.textColor = .init(named: "myIncludeTxtColor")
    }
    
    // 상품
    private lazy var productView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var productNum = UILabel().then {
        $0.font = .init(name: Font.fontBold.rawValue, size: 18)
    }
    
    private lazy var productLabel = UILabel().then {
        $0.text = "상품"
        $0.textColor = .init(named: "mainColor")
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
    }
    
    //찜한 상품
    private lazy var prizeView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var prizeNum = UILabel().then {
        $0.font = .init(name: Font.fontBold.rawValue, size: 18)
        $0.textColor = .black
    }
    
    private lazy var prizeLabel = UILabel().then {
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
        $0.textColor = .init(named: "mainColor")
        $0.text = "찜한 상품"
    }
    
    // 받은 찜
    private lazy var receiveView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var receiveNum = UILabel().then {
        $0.font = .init(name: Font.fontBold.rawValue, size: 18)
        $0.textColor = .black
    }
    
    private lazy var receiveLabel = UILabel().then {
        $0.text = "받은 찜"
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
        $0.textColor = .init(named: "mainColor")
    }
    
    // 거래 내역
    private lazy var transactionView = UIView().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.layer.cornerRadius = 3
    }
    
    private lazy var transactionNum = UILabel().then {
        $0.font = .init(name: Font.fontBold.rawValue, size: 18)
        $0.textColor = .black
    }
    
    private lazy var transactionLabel = UILabel().then {
        $0.text = "거래 내역"
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
        $0.textColor = .init(named: "mainColor")
    }
    
    private lazy var postBtn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.setTitle("상품", for: .normal)
        $0.titleLabel!.font = .init(name: Font.fontMedium.rawValue, size: 15)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var likePostBtn = UIButton(type: .system).then {
        $0.setTitle("찐함 상품", for: .normal)
        $0.titleLabel!.font = .init(name: Font.fontMedium.rawValue, size: 15)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var detailBtn = UIButton(type: .system).then {
        $0.setTitle("거래 내역", for: .normal)
        $0.titleLabel!.font = .init(name: Font.fontMedium.rawValue, size: 15)
        $0.setTitleColor(.black, for: .normal)
    }
    
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionView()).then {
        $0.backgroundColor = .white
    }
    
    private let logoutBtn = UIBarButtonItem(title: "로그아웃", style: .plain,
                                            target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: identfier)
        view.backgroundColor = .white
        setBtn()
    }
    
    override func viewDidLayoutSubviews() {
        setNavigationItem()
        setupView()
    }
    
    private func bindViewModel() {
        let model = MyPageViewModel()
        let input = MyPageViewModel.Input(getUserInfo: getProfileData.asDriver(), getPost: postBtn.rx.tap.asDriver(), getLikePost: likePostBtn.rx.tap.asDriver(), getDetail: detailBtn.rx.tap.asDriver(), memberID: memberID)
        
        let output = model.transform(input)
        
        output.myInfo.subscribe(onNext: { [self] data in
            let url = URL(string: data.profileUrl)
            let img = try? Data(contentsOf: url!)
            profileImg.image = UIImage(data: img!)
            nameLabel.text = data.name
            introduceLabel.text = data.introduction
            productNum.text = String(data.allPostCount)
            prizeNum.text = String(data.likePostCount)
            receiveNum.text = String(data.getLikesCount)
            transactionNum.text = String(data.completedPostCount)
        }).disposed(by: disposebag)
        
        output.post.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: MainCollectionViewCell.self)) { row, items, cell in
            let url = URL(string: items.image)
            let data = try? Data(contentsOf: url!)
            cell.imgView.image = UIImage(data: data!)
            cell.titleLabel.text = items.title
            cell.priceLabel.text = String(items.price)
            cell.label.text = items.purpose
        }.disposed(by: disposebag)
    }
    
    private func setNavigationItem(){
        navigationItem.title = "마이페이지"
        navigationItem.rightBarButtonItem = logoutBtn
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    private func setBtn() {
        postBtn.rx.tap.subscribe(onNext: {
            if(self.postDidTap) {
                self.postBtn.layer.addBorder([.bottom], color: .init(named: "mainColor")!, width: 1)
                self.postDidTap.toggle()
                self.likePostDidTap = true
                self.detailDidTap = true
            }
            else {
                self.postBtn.layer.addBorder([.bottom], color: .init(named: "placeholderColor")!, width: 1)
                self.postDidTap.toggle()
            }
        }).disposed(by: disposebag)
        
        likePostBtn.rx.tap.subscribe(onNext: {
            if(self.likePostDidTap) {
                self.likePostBtn.layer.addBorder([.bottom], color: .init(named: "mainColor")!, width: 1)
                self.likePostDidTap.toggle()
                self.postDidTap = true
                self.detailDidTap = true
            }
            else {
                self.likePostBtn.layer.addBorder([.bottom], color: .init(named: "placeholderColor")!, width: 1)
                self.likePostDidTap.toggle()
            }
        }).disposed(by: disposebag)
        
        detailBtn.rx.tap.subscribe(onNext: {
            if(self.detailDidTap) {
                self.detailBtn.layer.addBorder([.bottom], color: .init(named: "mainColor")!, width: 1)
                self.detailDidTap.toggle()
                self.likePostDidTap = true
                self.postDidTap = true
            }
            else {
                self.detailBtn.layer.addBorder([.bottom], color: .init(named: "placeholderColor")!, width: 1)
                self.detailDidTap.toggle()
            }
        }).disposed(by: disposebag)
        
        logoutBtn.rx.tap.subscribe(onNext: { _ in
            Token.logOut()
        }).disposed(by: disposebag)
    }
    
    private func setupView() {
        [profileImg, nameLabel, gearBtn, introduceLabel, productView, productNum, productLabel,
         prizeView, prizeNum, prizeLabel, receiveView, receiveNum, receiveLabel, transactionView,
         transactionNum, transactionLabel, collectionView, postBtn, likePostBtn, detailBtn].forEach {self.view.addSubview($0)}
        
        
        self.profileImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(126)
            $0.leading.lessThanOrEqualToSuperview().offset(40)
            $0.width.height.equalTo(80)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(132)
            $0.leading.equalTo(self.profileImg.snp.trailing).offset(23)
        }
        
        self.gearBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(132)
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
        
        self.postBtn.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().offset(67)
        }
        
        self.likePostBtn.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(36)
            $0.leading.lessThanOrEqualTo(postBtn.snp.trailing).offset(83)
        }
        
        self.detailBtn.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(36)
            $0.leading.lessThanOrEqualTo(likePostBtn.snp.trailing).offset(51)
            $0.trailing.equalToSuperview().inset(66)
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(postBtn.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
        }
        
    }
    
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.frame.width / 2 - 1
            let size = CGSize(width: width, height: width)

            return size
        }
}
