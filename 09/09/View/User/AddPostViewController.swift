//
//  PostViewController.swift
//  09
//
//  Created by 김기영 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    private let fontBold = "NotoSansCJKkr-Bold"
    private let fontRegular = "NotoSansCJKkr-Regular"
    private let fontMedium = "NotoSansCJKkr-Medium"
    private let disposebag = DisposeBag()
    
    private let picker = UIImagePickerController()
    private lazy var scrollView = UIScrollView()
    
    private lazy var View = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    private lazy var titleView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var titleTxt = UITextField().then {
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.font = .init(name: fontRegular, size: 13)
        $0.textColor = .init(named: "placeholderColor")
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var content = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .init(name: fontRegular, size: 13)
        $0.textColor = .init(named: "placeholdeColor")
    }
    
    private lazy var photoLabel = UILabel().then {
        $0.text = "사진"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .black
    }
    
    private lazy var photo = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .init(named: "searchColor")
    }
    
    private lazy var imageBtn = UIButton().then {
        $0.backgroundColor = .none
        $0.layer.cornerRadius = 5
        $0.setTitle( "image", for: .normal)
        $0.titleLabel?.font = .init(name: fontMedium, size: 10)
        $0.setTitleColor(.init(named: "borderColor"), for: .normal)
    }
    
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "*이미지는 상품등록 시\n 정사각형으로\n 잘려서 등록됩니다."
        $0.font = .init(name: fontRegular, size: 11)
        $0.textColor = .black
        $0.numberOfLines = 3
    }
    
    private lazy var buyLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "공동구매"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .black
    }
    
    private lazy var buyBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "circle"), for: .normal)
        $0.tintColor = .init(named: "circleColor")
    }
    
    private lazy var giveLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "무료나눔"
        $0.font = .init(name: fontMedium, size: 13)
        $0.textColor = .black
    }
    
    private lazy var giveBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.init(systemName: "circle"), for: .normal)
        $0.tintColor = .init(named: "circleColor")
    }
    
    private lazy var price = customView().then {
        $0.Label.text = "가격"
        $0.label.isHidden = false
    }
    
    private lazy var area = customView().then {
        $0.Label.text = "거래지역"
        $0.Txt.attributedPlaceholder = NSAttributedString(
            string: "거래지역을 입력해주세요(ex.대덕소프트웨어마이스터고등학교)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.label.isHidden = true
    }
    
    private lazy var openChat = customView().then {
        $0.Label.text = "오픈채팅"
        $0.Txt.attributedPlaceholder = NSAttributedString(
            string: "오픈채팅 링크를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.label.isHidden = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [price, area, openChat]).then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "게시물 작성"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(okBtn))
        imageBtn.rx.tap.subscribe(onNext: {
            self.imageViewTap()
        }).disposed(by: disposebag)
        
        content.delegate = self
        picker.delegate = self
        textViewDidEndEditing(content)
        textViewDidBeginEditing(content)
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "게시물 내용을 입력하세요" {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let currentText = content.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= 40
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "게시물 내용을 입력하세요"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        placeholderSetting()
        imageBtn.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    @objc
    private func okBtn() {
        
    }
    
    
    private func placeholderSetting() {
        content.delegate = self
        content.text = "게시물 내용을 입력하세요"
        content.textColor = .init(named: "placeholderColor")
    }
    
    private func setup() {
        line(view: titleView)
        line(view: contentView)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(View)
        
        [titleView, titleTxt, contentView, content, photoLabel, photo, imageBtn, label,
         buyLabel, buyBtn, giveLabel, giveBtn, stackView].forEach{ self.View.addSubview($0)}
        
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        View.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().offset(0)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().offset(0)
        }
        
        titleTxt.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(34)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(135)
        }
        
        content.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(34)
            $0.trailing.equalToSuperview().offset(-34)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-1)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(32)
            $0.leading.equalTo(34)
        }
        
        photo.snp.makeConstraints {
            $0.top.equalTo(self.photoLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(80)
            $0.leading.equalToSuperview().offset(34)
        }
        
        imageBtn.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.top).offset(0)
            $0.width.height.equalTo(80)
            $0.leading.equalTo(self.photo.snp.leading).offset(0)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.top).offset(29)
            $0.leading.equalTo(self.photo.snp.trailing).offset(20)
        }
        
        buyLabel.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(34)
        }
        
        buyBtn.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(43)
            $0.leading.equalTo(self.buyLabel.snp.trailing).offset(6)
            $0.height.width.equalTo(15)
        }
        
        giveLabel.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(40)
            $0.leading.equalTo(self.buyBtn.snp.trailing).offset(61)
        }
        
        giveBtn.snp.makeConstraints {
            $0.top.equalTo(self.photo.snp.bottom).offset(43)
            $0.leading.equalTo(self.giveLabel.snp.trailing).offset(6)
            $0.width.height.equalTo(15)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.buyLabel.snp.bottom).offset(43)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(400)
            $0.bottom.equalToSuperview()
        }
        
    }
    private func imageViewTap() {
        let alert = UIAlertController(title: "사진을 선택하세요", message: "갤러리의 사진을 선택하세요",
                                      preferredStyle: .alert)
        let libary = UIAlertAction(title: "예",
                                   style: .default, handler: { ACTION in self.openLibary()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(libary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)}
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageBtn.isHidden = true
            photo.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
