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
    
    let identfier = "cell"
    private let disposebag = DisposeBag()

    private let getData = BehaviorRelay<Void>(value: ())
    private var heartBool = Bool()
    private let flagIt = PublishSubject<Int>()
    private let deleteFlagIt = PublishSubject<Int>()
    
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
        $0.font = .init(name: Font.fontRegular.rawValue, size: 14)
        $0.textColor = .black
    }
    
    private lazy var profileBtn = UIButton().then {
        $0.backgroundColor = .none
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
        $0.layer.cornerRadius = 3
        $0.font = .init(name: Font.fontBold.rawValue, size: 11)
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
    
    private lazy var heartBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.maskedCorners  = .layerMinXMinYCorner
        $0.layer.maskedCorners = .layerMinXMaxYCorner
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.init(named: "borderColor")?.cgColor
        $0.setImage(.init(systemName: "heart"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t찜하기", for: .normal)
    }
    
    private lazy var chatBtn = UIButton().then {
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
        // Do any additional setup after loading the view.
        self.collectionView.register(MainCollectionViewCell.self,
                                     forCellWithReuseIdentifier: identfier)
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    private func bindViewModel() {
       let model = PostViewModel()
        let input = PostViewModel.Input (
            getPost: getData.asSignal(onErrorJustReturn: ()),
            flagIt: flagIt.asDriver(onErrorJustReturn: 0),
            deleteFlagIt: deleteFlagIt.asDriver(onErrorJustReturn: 0)
        )
        
        let output = model.transform(input)
        
        output.post.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: MainCollectionViewCell.self)) { row, items, cell in
            let url = URL(string: items.image)
            let data = try? Data(contentsOf: url!)
            cell.imgView.image = UIImage(data: data!)!
            cell.titleLabel.text = items.title
            cell.priceLabel.text = String(items.price)
            cell.label.text = items.purpose
            cell.locationLabel.text = items.transaction_region
            self.heartBool = items.liked
            
            if self.heartBool {
                cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
            }
            else {
                cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
            }
            
            cell.heartBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
                if heartBool {
                    flagIt.onNext(row)
                    cell.heartBtn.setImage(.init(systemName: "heart.fill"), for: .normal)
                }
                else {
                    deleteFlagIt.onNext(row)
                    cell.heartBtn.setImage(.init(systemName: "heart"), for: .normal)
                }
            }).disposed(by: cell.disposebag)
        }.disposed(by: disposebag)
    }
    
    private func setup() {
        [imgView, backBtn, profileImg, name, profileBtn, titleLabel, priceLabel, wonLabel,
         pinImg, areaLabel, buyLabel, contentLabel, label, heartBtn, chatBtn, collectionView]
            .forEach{view.addSubview($0)}
        
        self.imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(self.imgView.snp.width)
        }
        
        self.backBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.equalToSuperview().offset(23)
            $0.height.equalTo(14)
            $0.width.equalTo(7)
        }
        
        self.profileImg.snp.makeConstraints {
            $0.top.equalTo(self.imgView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(39)
            $0.height.width.equalTo(32)
        }
        
        self.name.snp.makeConstraints {
            $0.centerY.equalTo(self.profileImg.snp.centerY)
            $0.leading.equalTo(self.profileImg.snp.trailing).offset(6)
        }
        
        self.profileBtn.snp.makeConstraints {
            $0.centerY.equalTo(self.name.snp.centerY)
            $0.leading.equalTo(self.name.snp.trailing).offset(5)
            $0.width.equalTo(7)
            $0.height.equalTo(14)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(16)
            $0.leading.equalTo(39)
        }
        
        self.priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(0)
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
            $0.top.equalTo(self.priceLabel.snp.bottom).offset(9)
            $0.leading.equalTo(self.pinImg.snp.trailing).offset(4)
        }
        
        self.buyLabel.snp.makeConstraints {
            $0.top.equalTo(self.priceLabel.snp.bottom).offset(5)
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
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
        }
        
        self.lineView.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(49)
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        
        self.label.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(39)
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.label.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
            $0.bottom.equalToSuperview().offset(-39)
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
