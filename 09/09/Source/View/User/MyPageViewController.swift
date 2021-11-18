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
    
    var memberID = Int()
    
    private let disposebag = DisposeBag()
    private let viewmodel = MyPageViewModel()
    private var gearBool = false
    
    private let getProfileData = PublishRelay<Void>()
    
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
    
    private lazy var buttonView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 1
    }
    
    private lazy var gearBtn = UIButton(type: .system).then {
        $0.setImage(.init(named: "gearImg"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var btnView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
    }
    
    private lazy var changeInfoBtn = UIButton(type: .system).then {
        $0.setTitle("프로필 수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var changePwBtn = UIButton(type: .system).then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("비밀번호 변경", for: .normal)
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
        view.backgroundColor = .white
        bindViewModel()
        collectionView.rx.setDelegate(self).disposed(by: disposebag)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        setBtn()
        logoutBtn.rx.tap.subscribe(onNext: { _ in
            self.alert(title: "로그아웃 하시겠습니까?", action: { ACTION in
                Token.logOut()
                self.navigationController?.popViewController(animated: true)
            })
        }).disposed(by: disposebag)
        gearBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
            btnView.isHidden = gearBool
            changePwBtn.isHidden = gearBool
            changeInfoBtn.isHidden = gearBool
            gearBool.toggle()
        }).disposed(by: disposebag)
        changePwBtn.rx.tap.subscribe(onNext: { _ in
            self.pushVC(ChangePasswordViewController())
        }).disposed(by: disposebag)
        changeInfoBtn.rx.tap.subscribe(onNext: { _ in
            self.pushVC(ChangeProfileViewController())
        }).disposed(by: disposebag)
    }
    
    override func viewDidLayoutSubviews() {
        setNavigationItem()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnView.isHidden = true
        changePwBtn.isHidden = true
        changeInfoBtn.isHidden = true
        gearBool = false
        changeInfoBtn.layer.addBorder([.bottom], color: .init(named: "borderColor")!, width: 1)
        changeInfoBtn.clipsToBounds = true
        getProfileData.accept(())
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(getUserInfo: getProfileData.asSignal(),
                                          getPost: postBtn.rx.tap.asSignal(),
                                          getLikePost: likePostBtn.rx.tap.asSignal(),
                                          getDetail: detailBtn.rx.tap.asSignal(),
                                          memberID: memberID)
        
        let output = viewmodel.transform(input)
        
        output.myInfo.subscribe(onNext: { [unowned self] data in
            if data?.profile_url != nil {
            let url = URL(string: data!.profile_url ?? "")
            let img = try? Data(contentsOf: url!)
             profileImg.image = UIImage(data: img!)}
            memberID = data!.member_id
            nameLabel.text = data!.name
            introduceLabel.text = data!.introduction ?? ""
            productNum.text = String(data!.all_posts_count)
            prizeNum.text = String(data!.like_posts_count)
            receiveNum.text = String(data!.get_likes_count)
            transactionNum.text = String(data!.completed_posts_count)
        }).disposed(by: disposebag)
        
        output.post.bind(to: collectionView.rx.items(cellIdentifier: "cell",
                                                     cellType: MainCollectionViewCell.self))
        { row, items, cell in
            let url = URL(string: items.image)
            let data = try? Data(contentsOf: url!)
            cell.imgView.image = UIImage(data: data!)
            cell.titleLabel.text = items.title
            cell.locationLabel.text = items.transaction_region
            if items.price == 0 || items.price == nil {
                cell.priceLabel.isHidden = true
                cell.label.text! = "무료나눔"
            } else {
                cell.priceLabel.text = String(items.price ?? 0)
                cell.label.text! = "공동구매"
            }
            if items.liked {
                cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
            } else {
                cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
            }
        }.disposed(by: disposebag)
    }
    
    private func setNavigationItem(){
        navigationItem.title = "마이페이지"
        navigationItem.rightBarButtonItem = logoutBtn
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    private func setBtn() {
        postBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            setButton(postBtn, likePostBtn, detailBtn)
        }).disposed(by: disposebag)
        
        likePostBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            setButton(likePostBtn, detailBtn, postBtn)
        }).disposed(by: disposebag)
        
        detailBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            setButton(detailBtn, likePostBtn, postBtn)
        }).disposed(by: disposebag)
    }
    
    private func setButton(_ mainBtn : UIButton, _ secondBtn: UIButton, _ thirthBtn: UIButton) {
        mainBtn.layer.addBorder([.bottom], color: .init(named: "mainColor")!, width: 1)
        secondBtn.layer.addBorder([.bottom], color: .init(named: "placeholderColor")!, width: 1)
        thirthBtn.layer.addBorder([.bottom], color: .init(named: "placeholderColor")!, width: 1)
    }
    
    private func setupView() {
        [profileImg, nameLabel, gearBtn, introduceLabel, btnView, changeInfoBtn, changePwBtn,
         productView, productNum, productLabel,  prizeView, prizeNum, prizeLabel, receiveView,
         receiveNum, receiveLabel, transactionView,  transactionNum, transactionLabel,
         collectionView, postBtn, likePostBtn, detailBtn].forEach {self.view.addSubview($0)}
        
        
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
        
        self.btnView.snp.makeConstraints {
            $0.centerY.equalTo(gearBtn)
            $0.leading.equalTo(self.gearBtn.snp.trailing).offset(8)
            $0.width.equalTo(120)
            $0.height.equalTo(80)
        }
        
        self.changeInfoBtn.snp.makeConstraints {
            $0.top.equalTo(self.btnView.snp.top).offset(5)
            $0.centerX.equalTo(btnView)
        }
        
        self.changePwBtn.snp.makeConstraints {
            $0.top.equalTo(changeInfoBtn.snp.bottom).offset(15)
            $0.centerX.equalTo(btnView)
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
            $0.centerX.equalTo(productView)
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
            $0.centerX.equalTo(prizeView)
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
            $0.centerX.equalTo(receiveView)
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
            $0.centerX.equalTo(transactionView)
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
