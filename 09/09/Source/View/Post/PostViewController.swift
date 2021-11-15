//
//  PostViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/16.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    private let disposebag = DisposeBag()
    var postId = Int()
    let viewModel = PostViewModel()
    
    private let getDetail = BehaviorRelay<Void>(value: ())
    private let getPost = BehaviorRelay<Void>(value: ())
    private var heartBool = Bool()
    private let flagIt = PublishSubject<Int>()
    private let deleteFlagIt = PublishSubject<Int>()
    
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
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
        $0.textColor = .black
    }
    
    private lazy var profileBtn = UIButton(type: .system).then {
        $0.setImage(.init(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .init(named: "Color")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 16)
        $0.textColor = .black
    }
    
    private lazy var priceLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontBold.rawValue, size: 22)
        $0.textColor = .black
    }
    
    private lazy var wonLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "원"
        $0.textColor = .black
        $0.font = .init(name: Font.fontRegular.rawValue, size: 10)
    }
    
    private lazy var pinImg = UIImageView().then {
        $0.image = .init(named: "pinImg")
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var areaLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 12)
        $0.textColor = .black
    }
    
    private lazy var buyLabel = UILabel().then {
        $0.backgroundColor = .init(named: "mainColor")
        $0.text = "공동구매"
        $0.font = .init(name: Font.fontBold.rawValue, size: 11)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 12)
        $0.numberOfLines = 5
        $0.textColor = .black
    }
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "다른 상품 보기"
        $0.font = .init(name: Font.fontBold.rawValue, size: 14)
    }
    
    private lazy var heartBtn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.layer.maskedCorners  = .layerMinXMinYCorner
        $0.layer.maskedCorners = .layerMinXMaxYCorner
        $0.layer.cornerRadius = 5
        $0.setTitle("\t찜하기", for: .normal)
        $0.layer.borderColor = UIColor.init(named: "borderColor")?.cgColor
    }
    
    private lazy var chatBtn = UIButton(type: .system).then {
        $0.backgroundColor = .white
        $0.layer.maskedCorners = .layerMaxXMinYCorner
        $0.layer.maskedCorners = .layerMaxXMaxYCorner
        $0.layer.cornerRadius  = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.init(named: "borderColor")?.cgColor
        $0.setImage(.init(named: "chatImg"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t채팅", for: .normal)
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .init(named: "D3D3D3Color")
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionView()).then {
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindViewModel()
        buyLabel.layer.cornerRadius = 3
        buyLabel.clipsToBounds  = true
        // Do any additional setup after loading the view.
        collectionView.rx.setDelegate(self).disposed(by: disposebag)
        self.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        heartBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            if heartBool {
                flagIt.onNext(postId)
            }
            else {
                flagIt.onNext(postId)
            }
        }).disposed(by: disposebag)
    }
    
    override func viewDidLayoutSubviews() {
        setup()
        if heartBool {
            heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
            heartBtn.semanticContentAttribute = .forceLeftToRight
            heartBtn.tintColor = .init(named: "heartColor")
        }
        else {
            heartBtn.setImage(.init(systemName: "heart"), for: .normal)
            heartBtn.semanticContentAttribute = .forceLeftToRight
            heartBtn.tintColor = .init(named: "borderColor")
        }
    }
    
    private func bindViewModel() {
        let input = PostViewModel.Input (
            getDetail: getDetail.asDriver(onErrorJustReturn: ()),
            post_id: postId,
            getPost: getPost.asSignal(onErrorJustReturn: ()),
            flagIt: flagIt.asDriver(onErrorJustReturn: 0),
            deleteFlagIt: deleteFlagIt.asDriver(onErrorJustReturn: 0)
        )
        
        let output = viewModel.transform(input)
        
        output.post.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: MainCollectionViewCell.self)) { row, items, cell in
            let url = URL(string: items.image)
            let data = try? Data(contentsOf: url!)
            cell.imgView.image = UIImage(data: data!)!
            cell.titleLabel.text! = items.title
            self.heartBool = items.liked
            
            if self.heartBool {
                cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
            }
            else {
                cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
            }
            
            cell.heartBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
                if heartBool {
                    deleteFlagIt.onNext(row)
                    cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
                }
                else {
                    flagIt.onNext(row)
                    cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
                }
            }).disposed(by: cell.disposebag)
        }.disposed(by: disposebag)
        
        output.postInformation.subscribe(onNext: { [unowned self] model in
            let url = URL(string: model!.image)
            let data = try? Data(contentsOf: url!)
            imgView.image = UIImage(data: data!)
            let url1 = URL(string: (model!.member_info.member_profile ?? model?.image)!)
            let data1 = try? Data(contentsOf: url1!)
            profileImg.image = UIImage(data: data1!)
            name.text = model!.member_info.member_name
            titleLabel.text = model?.title
            heartBool = model!.liked
            if model?.price == nil || model?.price == 0 {
                priceLabel.isHidden = true
                label.text = "무료나눔"
            }
            else {
                priceLabel.text = String(model?.price ?? 0)
                label.text = "공동구매"
            }
            areaLabel.text = model?.transaction_region
            contentLabel.text = model?.content
        }).disposed(by: disposebag)
    }
    
    private func setup() {
        [imgView, profileImg, name, profileBtn, titleLabel, priceLabel, wonLabel,
         pinImg, areaLabel, buyLabel, contentLabel, label, heartBtn, chatBtn, lineView, collectionView]
            .forEach{view.addSubview($0)}
        
        self.imgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(300)
        }
        
        self.profileImg.snp.makeConstraints {
            $0.top.equalTo(self.imgView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(39)
            $0.height.width.equalTo(32)
        }
        
        self.name.snp.makeConstraints {
            $0.centerY.equalTo(profileImg)
            $0.leading.equalTo(self.profileImg.snp.trailing).offset(6)
        }
        
        self.profileBtn.snp.makeConstraints {
            $0.centerY.equalTo(name)
            $0.leading.equalTo(self.name.snp.trailing).offset(5)
            $0.width.equalTo(7)
            $0.height.equalTo(14)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(16)
            $0.leading.equalTo(39)
        }
        
        self.priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(39)
        }
        
        self.wonLabel.snp.makeConstraints {
            $0.leading.equalTo(self.priceLabel.snp.trailing).offset(4)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        self.pinImg.snp.makeConstraints {
            $0.top.equalTo(self.priceLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(39)
            $0.width.equalTo(10)
            $0.height.equalTo(14)
        }
        
        self.areaLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.pinImg)
            $0.leading.equalTo(self.pinImg.snp.trailing).offset(4)
        }
        
        self.buyLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.pinImg)
            $0.trailing.equalToSuperview().offset(-39)
            $0.width.equalTo(56)
            $0.height.equalTo(20)
        }
        
        self.heartBtn.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(19)
            $0.leading.equalToSuperview().offset(39)
        }
        
        self.chatBtn.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(19)
            $0.leading.equalTo(self.heartBtn.snp.trailing).offset(0)
            $0.trailing.equalToSuperview().offset(-39)
        }
        
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.heartBtn.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(39)
        }
        
        self.lineView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(49)
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(39)
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1
        let size = CGSize(width: width, height: width)
        
        return size
    }
}
