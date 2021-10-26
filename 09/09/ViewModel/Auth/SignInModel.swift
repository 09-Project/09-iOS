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
        let result: Signal<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let info = Driver.combineLatest(input.username, input.password)
        let isEnabel = info.map{!$0.0.isEmpty && !$0.1.isEmpty}
        let result = PublishSubject<Bool>()
        
        input.doneTap.withLatestFrom(info).asObservable().flatMap{ userN, userP in
            api.signIn(userN, userP)
        }.subscribe(onNext: { _ in
            result.onCompleted()
        })
        return Output(isEnable: isEnabel.asDriver(),
                      result: result.asSignal(onErrorJustReturn: false))
    }
}
