//
//  SignUpVIewModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    struct Input {
        let name: Driver<String>
        let username: Driver<String>
        let password: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let isEnable: Driver<Bool>
        let result: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthAPI()
        let info = Driver.combineLatest(input.name, input.username, input.password)
        let isEnable = info.map {!$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty}
        let result = PublishSubject<String>()
        
        input.doneTap.withLatestFrom(info).asObservable().subscribe(onNext: {[weak self]
            name, userN, pw in
            guard let self = self else {return}
            api.signUp(name, userN, pw).subscribe(onNext: { response in
                switch response{
                case .okay:
                    result.onCompleted()
                case .wrongRq:
                    result.onNext("닉네임은 최대 10까지 가능합니다.")
                case .conflict:
                    result.onNext("닉네임 또는 아이디가 존재합니다.")
                default:
                    result.onNext("회원가입 실패")
                }
            }).disposed(by: self.disposebag)
        }).disposed(by: disposebag)
        return Output(isEnable: isEnable.asDriver(),
                      result: result.asSignal(onErrorJustReturn: "회원가입 실패"))
    }
}
