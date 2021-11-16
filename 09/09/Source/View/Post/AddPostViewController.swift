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

class AddPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    private let disposebag = DisposeBag()
    private var buyBtnBool = true
    private var giveBtnBool = true
    private let postImg = UIImage.init(named: "postImg")
    private let model = AddPostViewModel()
    
    private let picker = UIImagePickerController()
    private var img = PublishRelay<Data>()
    private let post = PublishRelay<Void>()
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var View = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var titleView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var titleTxt = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "placeholderColor")])
        $0.font = .init(name: Font.fontRegular.rawValue, size: 13)
        $0.textColor = .init(named: "placeholderColor")
    }
    
    private lazy var numLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 11)
        $0.sizeToFit()
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var content = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .init(name: Font.fontRegular.rawValue, size: 13)
        $0.textColor = .init(named: "placeholdeColor")
    }
    
    private lazy var photoLabel = UILabel().then {
        $0.text = "사진"
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
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
        $0.titleLabel?.font = .init(name: Font.fontMedium.rawValue, size: 10)
        $0.setTitleColor(.init(named: "borderColor"), for: .normal)
    }
    
    
    private lazy var label = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "*이미지는 상품등록 시\n 정사각형으로\n 잘려서 등록됩니다."
        $0.font = .init(name: Font.fontRegular.rawValue , size: 11)
        $0.textColor = .black
        $0.numberOfLines = 3
    }
    
    private lazy var buyLabel = UILabel().then {
        $0.backgroundColor = .white
        $0.text = "공동구매"
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
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
        $0.font = .init(name: Font.fontMedium.rawValue, size: 13)
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
    
    private let okBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.backgroundColor = .white
        navigationItem.title = "게시물 작성"
        navigationItem.rightBarButtonItem = okBtn
        navigationItem.rightBarButtonItem!.tintColor = .black
        imageBtn.rx.tap.subscribe(onNext: {
            self.imageViewTap()
        }).disposed(by: disposebag)
        buyBtn.rx.tap.subscribe(onNext: {
            self.buyBtnDidTap()
        }).disposed(by: disposebag)
        giveBtn.rx.tap.subscribe(onNext: {
            self.giveBtnDidTap()
        }).disposed(by: disposebag)
        content.delegate = self
        picker.delegate = self
        price.Txt.delegate = self
        area.Txt.delegate = self
        openChat.Txt.delegate = self
        textViewDidEndEditing(content)
        textViewDidBeginEditing(content)
        setEndEvent()
        content.rx.text.subscribe(onNext: {[unowned self] str in
            if (content.text == "게시물 내용을 입력하세요") {
                numLabel.font = .init(name: Font.fontBold.rawValue, size: 11)
                numLabel.text = "(0/200)"
            }
            else {
                let num: Int? = str?.count
                numLabel.font = .init(name: Font.fontRegular.rawValue, size: 11)
                self.numLabel.text = "(\(num!)/200)"
            }
        }).disposed(by: disposebag)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        placeholderSetting()
        imageBtn.isHidden = false
        titleView.layer.addBorder([.top, .bottom], color: .init(named: "placeholderColor")!, width: 0.5)
        contentView.layer.addBorder([.top, .bottom], color: .init(named: "placeholderColor")!, width: 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        setup()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == price.Txt || textField == area.Txt || textField == openChat.Txt){
            scrollView.setContentOffset(CGPoint(x: 0, y: 350), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
        return changedText.count <= 200
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "게시물 내용을 입력하세요"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindViewModel() {
        let input = AddPostViewModel.Input(
            title: titleTxt.rx.text.orEmpty.asDriver(),
            content: content.rx.text.orEmpty.asDriver(),
            price: price.Txt.rx.text.orEmpty.asDriver(),
            transactionRegion: area.Txt.rx.text.orEmpty.asDriver(),
            openChatLink: openChat.Txt.rx.text.orEmpty.asDriver(),
            image: img.asDriver(onErrorJustReturn: (postImg?.jpegData(compressionQuality: 0.8))!),
            doneTap: okBtn.rx.tap.asSignal()
        )
        let output = model.transform(input)
        
        output.result.asObservable().subscribe(onNext: { [unowned self] bool in
            if bool {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.okAlert(title: "게시물을 전송하는데 실패하셨습니다.", action: { ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }).disposed(by: disposebag)
    }
    
    private func placeholderSetting() {
        content.delegate = self
        content.text = "게시물 내용을 입력하세요"
        content.textColor = .init(named: "placeholderColor")
    }
    
    
    private func setup() {
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(View)
        
        [titleView, titleTxt, contentView, content, numLabel, photoLabel,
         photo, imageBtn, label, buyLabel, buyBtn, giveLabel, giveBtn, stackView].forEach{ self.View.addSubview($0)}
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaInsets)
        }
        
        View.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(self.view)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaInsets).offset(1)
            $0.height.equalTo(52)
            $0.leading.trailing.equalTo(self.View)
        }
        
        titleTxt.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.top).offset(16)
            $0.leading.equalTo(titleView.snp.leading).offset(34)
        }
        
        numLabel.snp.makeConstraints {
            $0.leading.lessThanOrEqualTo(View.snp.leading).inset(345)
            $0.bottom.equalTo(contentView.snp.bottom).inset(14)
            $0.trailing.equalTo(contentView.snp.trailing).inset(39)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(135)
        }
        
        content.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(10)
            $0.leading.equalTo(self.contentView.snp.leading).offset(34)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-34)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-40)
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
        let libary = UIAlertAction(title: "네",
                                   style: .default, handler: { ACTION in self.openLibary()})
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(libary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)}
    
    private func buyBtnDidTap() {
        if buyBtnBool {
            buyBtn.setImage(.init(systemName: "largecircle.fill.circle"), for: .normal)
            buyBtn.tintColor = .init(named: "mainColor")
            giveBtn.setImage(.init(systemName: "circle"), for: .normal)
            giveBtn.tintColor = .init(named: "circleColor")
            price.isHidden = false
            giveBtnBool = true
            buyBtnBool.toggle()
        }
        else {
            buyBtn.setImage(.init(systemName: "circle"), for: .normal)
            buyBtn.tintColor = .init(named: "circleColor")
            buyBtnBool.toggle()
        }
    }
    
    private func giveBtnDidTap() {
        if giveBtnBool {
            giveBtn.setImage(.init(systemName: "largecircle.fill.circle"), for: .normal)
            giveBtn.tintColor = .init(named: "mainColor")
            buyBtn.setImage(.init(systemName: "circle"), for: .normal)
            buyBtn.tintColor = .init(named: "circleColor")
            buyBtnBool = true
            price.isHidden = true
            giveBtnBool.toggle()
        }
        
        else {
            giveBtn.setImage(.init(systemName: "circle"), for: .normal)
            giveBtn.tintColor = .init(named: "circleColor")
            price.isHidden = false
            giveBtnBool.toggle()
        }
    }
    
    private func setEndEvent() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc
    func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo.image = image
            img.accept(image.jpegData(compressionQuality: 0.8)!)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
