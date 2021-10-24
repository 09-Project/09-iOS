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
        let result: Signal<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let info = Driver.combineLatest(input.name, input.username, input.password)
        let isEnable = info.map {!$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty}
        let result = PublishSubject<Bool>()
        
        input.doneTap.asObservable()
            .withLatestFrom(info)
            .flatMap{ name, userN, userP in
                api.signUp(name, userN, userP)
            }.subscribe(onNext: {_ in
                result.onCompleted()
            }).disposed(by: disposebag)
        return Output(isEnable: isEnable.asDriver(),
                      result: result.asSignal(onErrorJustReturn: false))
    }
}
