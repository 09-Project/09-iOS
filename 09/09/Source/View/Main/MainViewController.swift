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
import Alamofire

class MainViewController: UIViewController {
    
    private let disposebag = DisposeBag()
    
    private let model = MainViewModel()
    private let getData = BehaviorRelay<Void>(value: ())
    private let count = PublishRelay<Void>()
    private let flagIt = PublishRelay<Int>()
    private let deleteFlagIt = PublishRelay<Int>()
    private let refreshToken = PublishSubject<Void>()
    private var heartBool = Bool()
    private var page = Int()
    
    private let sideMenu = SideMenuNavigationController(
        rootViewController: SideMenuViewController())
    
    
    private lazy var searchField = UITextField().then {
        $0.backgroundColor = .init(named: "searchColor")
        $0.textAlignment = .left
        $0.font = .init(name: Font.fontRegular.rawValue, size: 13)
    }
    
    private lazy var searchBtn = UIButton(type: .system).then {
        $0.setImage(.init(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var bennerImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.init(named: "banner")
    }
    
    private lazy var label = UILabel().then {
        $0.text = "공동구매부터 무료나눔까지"
        $0.textColor = .white
        $0.font = .init(name: Font.fontBold.rawValue, size: 22)
    }
    
    private lazy var label2 = UILabel().then {
        $0.text = "09"
        $0.textColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 17)
    }
    
    private lazy var label3 = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "추천 상품"
        $0.font = .init(name: Font.fontBold.rawValue, size: 20)
    }
    
    private lazy var pageBackBTn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "arrowtriangle.backward.square"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var pageFrontBtn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "arrowtriangle.forward.square"), for: .normal)
        $0.tintColor = .init(named: "mainColor")
    }
    
    private lazy var pageAllLabel = UILabel().then {
        $0.font = .init(name: Font.fontMedium.rawValue, size: 16)
        $0.textColor = .init(named: "placeholderColor")
    }
    
    private lazy var pageLabel = UILabel().then {
        $0.font = .init(name: Font.fontBold.rawValue, size: 16)
        $0.textColor = .black
    }
    
    private lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionView()).then {
        $0.backgroundColor = .white
    }
    
    private var lineBtn = UIBarButtonItem(image: .init(systemName: "line.horizontal.3"),
                                          style: .plain, target: self, action: nil).then {
        $0.tintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.backgroundColor = .white
        let img = UIImage(named: "logo&symbolImg")
        navigationItem.titleView = UIImageView(image: img)
        navigationItem.rightBarButtonItem = lineBtn
        self.mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        sideMenu.leftSide = false
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        lineBtn.rx.tap.subscribe(onNext: { _ in
            self.present(self.sideMenu, animated: true, completion: nil)
        }).disposed(by: disposebag)
        mainCollectionView.rx.setDelegate(self).disposed(by: disposebag)
        navigationController?.navigationBar.isHidden = false
        pageFrontBtn.rx.tap.subscribe(onNext: { _ in
            self.page += 1
        }).disposed(by: disposebag)
        pageBackBTn.rx.tap.subscribe(onNext: { _ in
            self.page -= 1
        }).disposed(by: disposebag)
    }
    
    override func viewDidLayoutSubviews() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 73, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo&symbolImg")
        imageView.image = image
        navigationItem.titleView = imageView
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData.accept(())
        mainCollectionView.reloadData()
        refreshToken.onNext(())
        self.navigationItem.hidesBackButton = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindViewModel() {
        let input = MainViewModel.Input(
            getPost: getData.asSignal(onErrorJustReturn: ()),
            getMorePost: pageFrontBtn.rx.tap.asSignal(),
            getBackPost: pageBackBTn.rx.tap.asSignal(),
            searchBtn: searchBtn.rx.tap.asSignal(),
            searchTxt: searchField.rx.text.asSignal(onErrorJustReturn: ""),
            flagIt: flagIt.asDriver(onErrorJustReturn: 0),
            deleteFlagIt: deleteFlagIt.asDriver(onErrorJustReturn: 0),
            refresh: refreshToken.asDriver(onErrorJustReturn: ()),
            loadDetail: mainCollectionView.rx.itemSelected.asSignal(),
            count: count.asDriver(onErrorJustReturn: ())
        )
        
        let output = model.transform(input)
        
        output.post.bind(to: mainCollectionView.rx.items(cellIdentifier: "cell", cellType: MainCollectionViewCell.self)) { row, items, cell in
            let url = URL(string: items.image)
            let data = try? Data(contentsOf: url!)
            cell.imgView.image = UIImage(data: data!)
            cell.titleLabel.text = items.title
            cell.locationLabel.text = items.transaction_region
            cell.bool = items.liked
            
            if items.price == 0 || items.price == nil {
                cell.label.isHidden = true
                cell.priceLabel.text = "무료나눔"
            }
            else {
                cell.label.isHidden = false
                cell.label.text = "공동구매"
                cell.priceLabel.text = String(items.price ?? 0) + "원"
            }
            
            if cell.bool {
                cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
            }
            else {
                cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
            }
            
            cell.heartBtn.rx.tap.subscribe(onNext: { _ in
                if cell.bool {
                    self.deleteFlagIt.accept(row)
                }
                else {
                    self.flagIt.accept(row)
                }
                output.flagItResult.subscribe(onNext: { bool in
                    self.heartBool = bool
                    if bool {
                        cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
                    }
                    else {
                        cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
                    }
                }).disposed(by: self.disposebag)
            }).disposed(by: cell.disposebag)
        }.disposed(by: disposebag)
        
        output.refreshResult.subscribe(onNext: { bool in
            if bool == false {
                self.pushVC(SignInViewController())
            }
        }).disposed(by: disposebag)
        
        output.detailIndex.asObservable().subscribe(onNext: { id in
            let vc = PostViewController()
            vc.postId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposebag)
        
        output.PostCount.asObservable().subscribe(onNext: {[unowned self] data in
            pageAllLabel.text = "/" + String(data / 16)
            pageLabel.text = String(page)
        }).disposed(by: disposebag)
    }
    
    private func setupView() {
        [searchField, searchBtn, bennerImgView, label, label2, label3, pageAllLabel, pageLabel,
         pageFrontBtn, pageBackBTn, mainCollectionView].forEach{view.addSubview($0)}
        
        self.searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(26)
        }
        
        self.searchBtn.snp.makeConstraints {
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
        
        self.pageAllLabel.snp.makeConstraints {
            $0.centerY.equalTo(pageFrontBtn)
            $0.trailing.equalTo(pageBackBTn.snp.leading).offset(-12)
        }
        
        self.pageLabel.snp.makeConstraints {
            $0.centerY.equalTo(pageAllLabel)
            $0.trailing.equalTo(pageAllLabel.snp.leading).offset(-3)
        }
        
        self.pageFrontBtn.snp.makeConstraints {
            $0.centerY.equalTo(label3)
            $0.trailing.equalToSuperview().offset(-39)
            $0.width.height.equalTo(20)
        }
        
        self.pageBackBTn.snp.makeConstraints {
            $0.centerY.equalTo(label3)
            $0.trailing.equalTo(self.pageFrontBtn.snp.leading).offset(-12)
            $0.width.height.equalTo(20)
        }
        
        self.mainCollectionView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.bennerImgView.snp.bottom).offset(62)
            $0.leading.lessThanOrEqualToSuperview().offset(16)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(0)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 1
        let size = CGSize(width: width, height: width)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = MainCollectionViewCell()
        cell.disposebag = DisposeBag()
        cell.heartBtn.isSelected = false
    }
    
}

