//
//  SideMenuViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    private lazy var pageLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "페이지선택"
        $0.font = .init(name: "NotoSansCJKkr-Bold", size: 18)
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private lazy var homeBtn = UIButton().then {
        $0.setImage(.init(systemName: "house.fill"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t 홈", for: .normal)
        $0.tintColor = .black
        $0.titleLabel!.font = .init(name: "NotoSansCJKkr-Regular", size: 12)

    }
    
    private lazy var myPageBtn = UIButton().then {
        $0.setImage(.init(systemName: "person.fill"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t 마이페이지", for: .normal)
        $0.tintColor = .black
        $0.titleLabel!.font = .init(name: "NotoSansCJKkr-Regular", size: 12)
    }

    private lazy var postBtn = UIButton().then {
        $0.setImage(.init(systemName: "pencil"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitle("\t 게시물 작성", for: .normal)
        $0.tintColor = .black
        $0.titleLabel!.font = .init(name: "NotoSansCJKkr-Regular", size: 12)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners  = .layerMinXMinYCorner
        view.layer.masksToBounds = true
        homeBtn.addTarget(self, action: #selector(homeBtnDidTap), for: .touchUpInside)
        myPageBtn.addTarget(self, action: #selector(myPageBtnDidTap), for: .touchUpInside)
        postBtn.addTarget(self, action: #selector(postBtnDidTap), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        view.addSubview(pageLabel)
        view.addSubview(lineView)
        view.addSubview(homeBtn)
        view.addSubview(myPageBtn)
        view.addSubview(postBtn)
        
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
    @objc
    private func homeBtnDidTap() {
        let VC = MainViewController()
        present(VC, animated: true, completion: nil)
    }
    
    @objc
    private func myPageBtnDidTap() {
    }
    
    @objc
    private func postBtnDidTap() {
    }

}
