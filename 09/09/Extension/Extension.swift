//
//  Extension.swift
//  09
//
//  Created by 김기영 on 2021/10/11.
//

import Foundation
import UIKit

//extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 16
//        }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 16
//        }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            let width = collectionView.frame.width / 2 - 1
//            let size = CGSize(width: width, height: width)
//
//            return size
//        }
//
//}
//
//extension MyPageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}

extension UIViewController {
    func alert(title: String, action: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default, handler: action)
        let cancel = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func underLine(view: UIView, txt: UITextField?, color: String) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: view.frame.size.height,
                              width: view.frame.width,
                              height: 1)
        border.backgroundColor = UIColor.init(named: color)?.cgColor
        view.layer.addSublayer(border)
        txt?.textColor = .init(named: color)
    }
    
    func line(view: UIView) {
        lazy var lineView1 = UIView().then {
        $0.backgroundColor = .init(named: "placeholderColor")
    }
        lazy var lineView2 = UIView().then {
        $0.backgroundColor = .init(named: "placeholderColor")
    }
        
        view.addSubview(lineView1)
        view.addSubview(lineView2)
        
        lineView1.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.top).offset(0)
            $0.height.equalTo(0.5)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        
        lineView2.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(0)
            $0.height.equalTo(0.5)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        
    }
}
