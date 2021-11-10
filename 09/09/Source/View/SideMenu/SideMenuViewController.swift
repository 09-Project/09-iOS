//
//  SideMenuViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa

class SideMenuViewController: UIViewController {
    
    private let disposebag = DisposeBag()
    
    private lazy var pageLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "페이지선택"
        $0.font = .init(name: Font.fontBold.rawValue, size: 18)
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private lazy var homeBtn = UIButton(type: .system).then {
        $0.setImage(.init(systemName: "house.fill"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t 홈", for: .normal)
        $0.tintColor = .black
        $0.titleLabel!.font = .init(name: Font.fontRegular.rawValue, size: 12)

    }
    
    private lazy var myPageBtn = UIButton(type: .system).then {
        $0.setImage(.init(systemName: "person.fill"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t 마이페이지", for: .normal)
        $0.tintColor = .black
        $0.titleLabel!.font = .init(name: Font.fontRegular.rawValue, size: 12)
    }

    private lazy var postBtn = UIButton(type: .system).then {
        $0.setImage(.init(systemName: "pencil"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t 게시물 작성", for: .normal)
        $0.tintColor = .black
        $0.titleLabel!.font = .init(name: Font.fontRegular.rawValue, size: 12)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners  = .layerMinXMinYCorner
        view.layer.masksToBounds = true
        setButton()
    }
    
    override func viewDidLayoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        [pageLabel, lineView, homeBtn, myPageBtn, postBtn].forEach{view.addSubview($0)}
        
        self.pageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.leading.equalToSuperview().offset(31)
        }
        
        self.lineView.snp.makeConstraints {
            $0.top.equalTo(self.pageLabel.snp.bottom).offset(29)
            $0.leading.equalToSuperview().offset(33)
            $0.trailing.equalToSuperview().offset(-33)
        }
        
        self.homeBtn.snp.makeConstraints {
            $0.top.equalTo(self.lineView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
        }
        
        self.myPageBtn.snp.makeConstraints {
            $0.top.equalTo(self.homeBtn.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(30)
        }
        
        self.postBtn.snp.makeConstraints {
            $0.top.equalTo(self.myPageBtn.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(30)
        }
        
    }
    
    private func setButton() {
        homeBtn.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposebag)
        
        myPageBtn.rx.tap.subscribe(onNext: { _ in
            self.pushVC(MyPageViewController())
        }).disposed(by: disposebag)
        
        postBtn.rx.tap.subscribe(onNext: { _ in
            self.pushVC(AddPostViewController())
        }).disposed(by: disposebag)
    }
}
