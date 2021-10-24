//
//  SignInModel.swift
//  09
//
//  Created by 김기영 on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa

class SignInModel: ViewModelType {
    
    private let disposebag = DisposeBag()
    
    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let doneTap: Signal<Void>
    }
    
    struct Output {
        let isEnable: Driver<Bool>
        let result: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let info = Driver.combineLatest(input.username, input.password)
        let isEnabel = info.map{!$0.0.isEmpty && !$0.1.isEmpty}
        let result = PublishSubject<String>()
        
        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: { [weak self]
            userN, userP in
            
            guard let self = self else {return}
            
            api.signIn(userN, userP).subscribe({_ in
                result.onCompleted()
            }).disposed(by: self.disposebag)
        }).disposed(by: disposebag)
        
        return Output(isEnable: isEnabel.asDriver(),
                      result: result.asSignal(onErrorJustReturn: "아이디나 비밀번호가 일치하지 않습니다."))
    }
}
